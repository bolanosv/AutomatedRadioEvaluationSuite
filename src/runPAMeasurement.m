function runPAMeasurement(app)
    try
        % Frequency settings.
        if strcmp(app.TypeFreqMeasurementMode, 'Sweep Frequencies')
            frequencies = app.StartFrequency.Value*1E6:app.FrequencyStep.Value*1E6:app.EndFrequency.Value*1E6;
        else
            frequencies = app.StartFrequency.Value * 1E6;
        end
        numFreqs = length(frequencies);

        % RF power settings.
        RFInputPower = app.StartPower.Value:app.PowerStep.Value:app.EndPower.Value;
        numPowers = length(RFInputPower);

        % Number of channels that will be used.
        numChannels = length(app.FilledPSUChannels);

        % Create the PA test parameters table.
        parametersTable = createPAParametersTable(app, frequencies, RFInputPower, numChannels);
        totalMeasurements = height(parametersTable);

        % Creates the PA test results table.
        resultsTable = createPAResultsTable(app, numChannels, totalMeasurements);
        
        % Configure the spectrum analyzer.
        writeline(app.SpectrumAnalyzer, sprintf(':SENSe:SWEep:POINts %d', app.SweepPointsValueField.Value));
        writeline(app.SpectrumAnalyzer, sprintf(':DISPlay:WINDow:TRACe:Y:SCALe:RLEVel %g', app.ReferenceLevelValueField.Value));
        %% CHECK IF SPAN THING WORKS HERE
        writeline(app.SpectrumAnalyzer, sprintf(':SENSe:FREQuency:SPAN %g', app.SpanValueField.Value * 1E6));
        writeline(app.SpectrumAnalyzer, sprintf(':FORMat:TRACe:DATA %s,%d', 'REAL', 64));
        writeline(app.SpectrumAnalyzer, sprintf(':FORMat:BORDer %s', 'SWAPped'));

        % Create a progress dialog to inform the user of the
        % measurement progress.
        d = uiprogressdlg(app.UIFigure, 'Title', 'Measurement Progress');

        for i = 1:totalMeasurements
            % Update the progress dialog window.
            d.Value = i / totalMeasurements;
            %d.Message = 

            % Set target frequency in the signal generator.
            frequency = parametersTable.Frequency(i);
            writeline(app.SignalGenerator, sprintf(':SOURce1:FREQuency:CW %d', frequency));
            % Set center frequency in the signal analyzer.
            writeline(app.SpectrumAnalyzer, sprintf(':SENSe:FREQuency:CENTer %g', frequency));

            %% MAYBE NOT NEEDED 
            RFPower = parametersTable.('RF Input Power')(i);
            writeline(app.SignalGenerator, sprintf(':SOURce1:POWer:LEVel:IMMediate:AMPLitude %g', RFPower));

            % Set all active channel voltages and currents.
            for ch = 1:numChannels
                channel = app.FilledPSUChannels{ch};
                voltage = paramTable.(sprintf('Channel %d Voltage', ch))(i);
                current = paramTable.(sprintf('Channel %d Current', ch))(i);
                setPSUChannels(app, channel, voltage, current);
            end
    
            % Enable all channels.
            enablePSUChannels(app, app.FilledPSUChannels, true);

            if i == 1
                % Longer delay for first measurement to allow PA to
                % settle.
                pause(app.PAMeasurementDelayValueField.Value * 10); 
            else
                % Shorter delay for subsequent measurements
                pause(app.PAMeasurementDelayValueField.Value / 2);  
            end

            % Turn on signal generator if it's the first measurement
            if i == 1
                writeline(app.SignalGenerator, sprintf(':OUTPut1:STATe %d', 1));
            end



        end

        % Close progress dialog.
        close(d);
        
        % Turn off the signal generator.
        writeline(app.SignalGenerator, sprintf(':SOURce1:POWer:LEVel:IMMediate:AMPLitude %d', -145));
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
    catch ME
        app.displayError(ME);
        % If an error occurs during the PA test measurement, then
        % for safety reasons the instruments will be turned off.
        enablePSUChannels(app, app.FilledPSUChannels, false);
        writeline(app.SignalGenerator, sprintf(':SOURce1:POWer:LEVel:IMMediate:AMPLitude %d', -145));
        writeline(app.SignalGenerator, sprintf(':OUTPut1:STATe %d', 0));
    end
end