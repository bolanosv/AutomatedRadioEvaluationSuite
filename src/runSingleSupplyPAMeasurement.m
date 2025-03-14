function runSingleSupplyPAMeasurement(app)
            try
                % Get the frequency sweep or the single frequency.
                isFrequencySweep = strcmp(app.TypeFreqMeasurement, 'Sweep Frequencies');
                if isFrequencySweep
                    frequencies = app.StartFrequency.Value*1E6:app.FrequencyStep.Value*1E6:app.EndFrequency.Value*1E6;
                else
                    frequencies = app.StartFrequency.Value * 1E6;
                end
                numFreqs = length(frequencies);

                % Get the voltage sweep of the single voltage value.
                % In single supply mode only one channel should be filled.
                channel = app.FilledPSUChannels{1}; 
                channelSettings = app.ChannelNames.(channel);
                isVoltageSweep = strcmp(channelSettings.Mode, 'Sweep');
                if isVoltageSweep
                    voltages = channelSettings.Start:channelSettings.Step:channelSettings.Stop;
                else
                    voltages = channelSettings.Start;
                end
                numVoltages = length(voltages);

                % Get the input RF power levels.
                RFInputPower = app.StartPower.Value:app.PowerStep.Value:app.EndPower.Value;
                numPowers = length(RFInputPower);

                % Initialize the output variables. 
                if isVoltageSweep && isFrequencySweep
                    dims = [numVoltages, numFreqs, numPowers];
                elseif isVoltageSweep
                    dims = [numVoltages, numPowers];
                elseif isFrequencySweep
                    dims = [numFreqs, numPowers];
                else
                    dims = [1, numPowers];
                end
                RFOutputPower = zeros(dims);
                app.DCDrainPower = zeros(dims);
                app.DCGatePower = zeros(dims);

                % Get spectrum analyzer information from the GUI.
                sweepPoints = app.SweepPointsValueField.Value;
                referenceLevel = app.ReferenceLevelValueField.Value;
                
                % Configure the spectrum analyzer.
                writeline(app.SpectrumAnalyzer, sprintf(':SENSe:SWEep:POINts %d', sweepPoints));
                writeline(app.SpectrumAnalyzer, sprintf(':DISPlay:WINDow:TRACe:Y:SCALe:RLEVel %g', referenceLevel));
                writeline(app.SpectrumAnalyzer, sprintf(':FORMat:TRACe:DATA %s,%d', 'REAL', 64));
                writeline(app.SpectrumAnalyzer, sprintf(':FORMat:BORDer %s', 'SWAPped'));

                % Create the progress dialog message for each scenario.
                if isVoltageSweep && isFrequencySweep
                    progressMsg = 'Frequency and voltage sweep measurement';
                elseif isVoltageSweep && ~isFrequencySweep
                    progressMsg = 'Single frequency with voltage sweep measurement\nVoltage: -- V, Power: -- dBm';
                elseif ~isVoltageSweep && isFrequencySweep
                    progressMsg = 'Frequency sweep with static voltage measurement';
                else
                    progressMsg = 'Single frequency with static voltage measurement';
                end

                % Create progress dialog.
                d = uiprogressdlg(app.UIFigure, 'Title', 'Measurement Progress', 'Message', progressMsg);
                
                % Total steps for tracking in progress dialog.
                totalSteps = numVoltages * numFreqs * numPowers;
                currentStep = 0;

                % Primary Measurement Loop: Voltages
                for v = 1:numVoltages
                    % Set the voltage.
                    app.setPSUChannels(channel, voltages(v), channelSettings.Current);
                    % Enable the channel.
                    app.enablePSUChannels(app.FilledPSUChannels, true);
                    % Small delay.
                    pause(app.MeasurementDelayValueField.Value / 2);
                    % Turn on the signal generator.
                    writeline(app.SignalGenerator, sprintf(':OUTPut1:STATe %d', 1));

                    % Secondary Measurement Loop: Frequencies
                    for f = 1:numFreqs
                        centerFrequency = frequencies(f);
                        span = app.SpanValueField.Value * 1E6;
                        % Set target frequency in the signal generator.
                        writeline(app.SignalGenerator, sprintf(':SOURce1:FREQuency:CW %d', centerFrequency));
                        % Set center freuqnecy and span in the spectrum analyzer.
                        writeline(app.SpectrumAnalyzer, sprintf(':SENSe:FREQuency:CENTer %g', centerFrequency));
                        writeline(app.SpectrumAnalyzer, sprintf(':SENSe:FREQuency:SPAN %g', span));

                        % Tertiary Measurement Loop: Input RF Powers
                        for p = 1:numPowers
                            currentStep = currentStep + 1;

                            d.Value = currentStep / totalSteps;

                            if isVoltageSweep && isFrequencySweep
                                d.Message = sprintf('Frequency and voltage sweep measurement\nVoltage: %.2f V (%d/%d), \nFrequency: %.2f MHz (%d/%d), \nPower: %.2f dBm (%d/%d)', ...
                                    voltageValues(v), v, numVoltages, centerFrequency/1E6, f, numFreqs, RFInputPower(p), p, numPowers);
                            elseif isVoltageSweep && ~isFrequencySweep
                                d.Message = sprintf('Single frequency with voltage sweep measurement\nVoltage: %.2f V (%d/%d), Power: %.2f dBm (%d/%d)', ...
                                    voltageValues(v), v, numVoltages, RFInputPower(p), p, numPowers);
                            elseif ~isVoltageSweep && isFrequencySweep
                                d.Message = sprintf('Frequency sweep with static voltage measurement\nFrequency: %.2f MHz (%d/%d), Power: %.2f dBm (%d/%d)', ...
                                    centerFrequency/1E6, f, numFreqs, RFInputPower(p), p, numPowers);
                            else
                                d.Message = sprintf('Single frequency with static voltage measurement\nPower: %.2f dBm (%d/%d)', RFInputPower(p), p, numPowers);
                            end

                            pause(app.MeasurementDelayValueField.Value / 2);

                            if isVoltageSweep && isFrequencySweep
                                [RFOutputPower(v, f, p), app.DCDrainPower(v, f, p), app.DCGatePower(v, f, p)] = measureRFOutputDCPower(app, RFInputPower(p));
                            elseif isVoltageSweep && ~isFrequencySweep
                                [RFOutputPower(v, p), app.DCDrainPower(v, p), app.DCGatePower(v, p)] = measureRFOutputDCPower(app, RFInputPower(p));
                            elseif ~isVoltageSweep && isFrequencySweep
                                [RFOutputPower(f, p), app.DCDrainPower(f, p), app.DCGatePower(f, p)] = measureRFOutputandDCPower(app, RFInputPower(p));
                            else
                                [RFOutputPower(p), app.DCDrainPower(p), app.DCGatePower(p)] = measureRFOutputandDCPower(app, RFInputPower(p));
                            end
                        end
                    end
                end

                % Close progress dialog.
                close(d);

                % Turn off the signal generator.
                writeline(app.SignalGenerator, sprintf(':SOURce1:POWer:LEVel:IMMediate:AMPLitude %d', -145));
                writeline(app.SignalGenerator, sprintf(':OUTPut1:STATe %d', 0));
                
                % Disable the channel.
                app.enablePSUChannels(app.FilledPSUChannels, false);

                 % Calculate Gain, DE, and PAE
                [Gain, DE, PAE] = measureRFParameters(RFInputPower, RFOutputPower, app.DCDrainPower);  

                % Save workspace variables to the app.
                app.PA_Frequencies = frequencies;
                app.PA_Voltages = voltages;
                app.PA_RFInputPower = RFInputPower;
                app.PA_RFOutputPower = RFOutputPower;
                app.PA_Gain = Gain;
                app.PA_DE = DE;
                app.PA_PAE = PAE;
            catch ME
                app.displayError(ME)
                % If an error occurs during the PA test measurement, then
                % for safety reasons the instruments will be turned off.
                app.enablePSUChannels(app.FilledPSUChannels, false);
                writeline(app.SignalGenerator, sprintf(':OUTPut1:STATe %d', 0));
            end   
        end