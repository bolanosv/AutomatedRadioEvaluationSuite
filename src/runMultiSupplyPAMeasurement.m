function runMultiSupplyPAMeasurement(app)
    try
        % Decide if the user wants to run a single frequency test
        % or a sweep of frequencies test.
        isFrequencySweep = strcmp(app.TypeFreqMeasurement, 'Sweep Frequencies');

        if isFrequencySweep
            frequencies = app.StartFrequency.Value*1E6:app.FrequencyStep.Value*1E6:app.EndFrequency.Value*1E6;
        else
            frequencies = app.StartFrequency.Value*1E6;
        end

        numFreqs = length(frequencies);

        % Initialize the arrays and cells holding all information regarding
        % the PSU channels, voltage values, and if the user wants to sweep
        % the channels or not.
        numChannels = length(app.FilledPSUChannels);
        voltages = cell(1, numChannels);
        numVoltages = zeros(1, numChannels);
        isVoltageSweep = false(1, numChannels);

        % Process each channel based on what the user wants to run, a 
        % static voltage value or a voltage sweep.
        for i = 1:numChannels
            channel = app.FilledPSUChannels{i};
            channelSettings = app.ChannelNames.(channel);
            isVoltageSweep(i) = strcmp(channelSettings.Mode, 'Sweep');

            if isVoltageSweep(i)
                voltages{i} = channelSettings.Start:channelSettings.Step:channelSettings.Stop;
            else
                voltages{i} = channelSettings.Start;
            end

            numVoltages(i) = length(voltages{i});
        end

        % Get the input RF power levels from the GUI.
        RFInputPower = app.StartPower.Value:app.PowerStep.Value:app.EndPower.Value;
        numPowers = length(RFInputPower);

        RFOutputPower = zeros(dims);
        %app.DCDrainPower = zeros(dims);
        %app.DCGatePower = zeros(dims);
        DCDrainPower = zeros(dims);
        DCGatePower = zeros(dims);

        % Get spectrum analyzer information from the GUI.
        sweepPoints = app.SweepPointsValueField.Value;
        referenceLevel = app.ReferenceLevelValueField.Value;

        % Configure the spectrum analyzer.
        writeline(app.SpectrumAnalyzer, sprintf(':SENSe:SWEep:POINts %d', sweepPoints));
        writeline(app.SpectrumAnalyzer, sprintf(':DISPlay:WINDow:TRACe:Y:SCALe:RLEVel %g', referenceLevel));
        writeline(app.SpectrumAnalyzer, sprintf(':FORMat:TRACe:DATA %s,%d', 'REAL', 64));
        writeline(app.SpectrumAnalyzer, sprintf(':FORMat:BORDer %s', 'SWAPped'));

        % Create a progress dialog for the PA measurement.
        d = uiprogressdlg(app.UIFigure, 'Title', 'Measurement Progress', 'Message', 'Multi-channel measurement in progress');

        % Calculate the total number of steps that will run in the
        % measurement process.
        totalSteps = prod(numVoltages) * numFreqs * numPowers;
        currentStep = 0;

    catch 
    end
end

