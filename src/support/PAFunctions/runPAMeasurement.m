function runPAMeasurement(app)
    try
        % Create the PA test parameters table.
        parametersTable = createPAParametersTable(app);
        totalMeasurements = height(parametersTable);

        % Creates the PA test results table.
        resultsTable = createPAResultsTable(app, totalMeasurements);
        
        % Configure the spectrum analyzer.
        writeline(app.SpectrumAnalyzer, sprintf(':SENSe:SWEep:POINts %d', app.SweepPointsValueField.Value));
        writeline(app.SpectrumAnalyzer, sprintf(':DISPlay:WINDow:TRACe:Y:SCALe:RLEVel %g', app.ReferenceLevelValueField.Value));
        
        % CHECK IF SPAN THING WORKS HERE
        writeline(app.SpectrumAnalyzer, sprintf(':SENSe:FREQuency:SPAN %g', app.SpanValueField.Value * 1E6));
        writeline(app.SpectrumAnalyzer, sprintf(':FORMat:TRACe:DATA %s,%d', 'REAL', 64));
        writeline(app.SpectrumAnalyzer, sprintf(':FORMat:BORDer %s', 'SWAPped'));
        
        avgRunTime = 0; % Average measurement time
        remainingTime = 0; % Remaining test time

        % Create a progress dialog to inform the user of the progress.
        d = uiprogressdlg(app.UIFigure, 'Title', 'Measurement Progress');
        
        for i = 1:totalMeasurements
            tic;
            estimatedTime = duration(round(remainingTime/3600),round(remainingTime/60),remainingTime);
            % Update the progress dialog window.
            d.Value = i / totalMeasurements;
            d.Message = sprintf("Measurement Progress: %d%% \nRemaining Time: %s\n", round(d.Value*100), string(estimatedTime));

            % Loop parameters
            RFInputPower = parametersTable.('RF Input Power')(i);
            frequency = parametersTable.Frequency(i);


            % Set target frequency in the signal generator.
            writeline(app.SignalGenerator, sprintf(':SOURce1:FREQuency:CW %d', frequency));
            % Set center frequency in the signal analyzer.
            writeline(app.SpectrumAnalyzer, sprintf(':SENSe:FREQuency:CENTer %g', frequency));

            % Set all active channel voltages and currents.
            for ch = 1:length(app.FilledPSUChannels)
                channelName = app.FilledPSUChannels{ch};
                voltage = parametersTable.(sprintf('Channel %d Voltage', ch))(i);
                current = parametersTable.(sprintf('Channel %d Current', ch))(i);
                setPSUChannels(app, channelName, voltage, current);
            end
    

            if i == 1
                % For the first measurement:
                % Enable all channels.
                enablePSUChannels(app, app.FilledPSUChannels, true);

                % Longer delay to allow PA to settle.
                pause(app.PAMeasurementDelayValueField.Value * 10); 

                % Turn on signal generator.
                writeline(app.SignalGenerator, sprintf(':OUTPut1:STATe %d', 1));
            end

            % Small delay.
            pause(app.PAMeasurementDelayValueField.Value);

            % Measure RF and DC Power.
            [RFOutputPower, DCDrainPower, DCGatePower] = measureRFOutputandDCPower(app, RFInputPower);
            
            % Apply de-embedding calibration based on user
            % selected calibration mode.
            [inCal, outCal] = deembedPA(app, frequency, RFInputPower);
            % 
            % Subtract inCal to get actual PA input power.
            correctedRFInputPower = RFInputPower - inCal;  
            
            % Add outCal to get actual PA output power.
            correctedRFOutputPower = RFOutputPower + outCal;
            
            % Calculate total DC Power.
            TotalDCDrainPower = sum(DCDrainPower);
            TotalDCGatePower = sum(DCGatePower);
            
            % Calculate Gain.
            Gain = correctedRFOutputPower - correctedRFInputPower;
             
            % Calculate DE and PAE.
            if TotalDCDrainPower == 0
                DE = 0;
                PAE = 0;
            else
                [~, DE, PAE] = measureRFParameters(correctedRFInputPower, correctedRFOutputPower, TotalDCDrainPower);
            end
            
            % Add to results table
            resultsTable.("Frequency (MHz)")(i) = frequency/1e6;
            resultsTable.("RF Input Power (dBm)")(i) = correctedRFInputPower;
            resultsTable.("RF Output Power (dBm)")(i) = correctedRFOutputPower;
            resultsTable.Gain(i) = Gain;
            resultsTable.("Total DC Drain Power (W)")(i) = TotalDCDrainPower;
            resultsTable.("DE (%)")(i) = DE;
            resultsTable.("PAE (%)")(i) = PAE;            
            for ch = 1:length(app.FilledPSUChannels)
                channelName = app.FilledPSUChannels{ch};
                resultsTable.(sprintf('Channel %d Voltages (V)', ch))(i) = parametersTable.(sprintf('Channel %d Voltage', ch))(i);
                resultsTable.(sprintf('Channel %d DC Power (W)', ch))(i) = DCDrainPower(1,ch);
            end
            avgRunTime = (avgRunTime*(i-1) + toc)/i;
            remainingTime = (totalMeasurements-i)*avgRunTime;
        end

        % Close progress dialog.
        close(d);
        
        % Turn off the signal generator.
        writeline(app.SignalGenerator, sprintf(':SOURce1:POWer:LEVel:IMMediate:AMPLitude %d', -135));
        writeline(app.SignalGenerator, sprintf(':OUTPut1:STATe %d', 0));
        
        % Disable the channels.
        enablePSUChannels(app, app.FilledPSUChannels, false);

        % Save table as a variable in the app
        app.PAMeasurementsTable = resultsTable;

        % Prepare data for plotting
        %prepareResultsForPlotting(app);

        % DEBUGGING
        disp(resultsTable);
        writetable(resultsTable, 'PARESULTS.xlsx')

        % Save data
        saveData(resultsTable);
    catch ME
        displayError(app,ME);
        % If an error occurs during the PA test measurement, then
        % for safety reasons the instruments will be turned off.
        enablePSUChannels(app, app.FilledPSUChannels, false);
        writeline(app.SignalGenerator, sprintf(':SOURce1:POWer:LEVel:IMMediate:AMPLitude %d', -145));
        writeline(app.SignalGenerator, sprintf(':OUTPut1:STATe %d', 0));
    end
end