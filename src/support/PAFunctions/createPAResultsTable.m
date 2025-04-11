function ResultsTable = createPAResultsTable(app, totalMeasurements)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function creates a results table for power amplifier (PA)
    % measurements, dynamically adjusting the column headers based on the 
    % number of active power supply channels.
    %
    % INPUT PARAMETERS
    % app:               The application object containing configuration
    %                    details, including the active PSU channels.
    % totalMeasurements: Total number of measurements to be recorded in
    %                    the table.
    %
    % OUTPUT PARAMETERS
    % ResultsTable:   The PA results table initialized with appropriate 
    %                 columns for storing frequency, voltage, RF power,
    %                 DC power, gain, and efficiency metrics.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Add frequency column.
    varNames = {'Frequency (MHz)'};
    
    % Number of channels that will be used.
    numChannels = length(app.FilledPSUChannels);

    % Add voltage columns based on the number of active channels.
    for i = 1:numChannels
        varNames{end+1} = sprintf('Channel %d Voltages (V)', i);
    end
    
    % Add measurement columns independent of active channels.
    varNames = [varNames, 'RF Input Power (dBm)', 'RF Output Power (dBm)', 'Gain'];
    
    % Add DC power coumns based on the number of active channels.
    for i = 1:numChannels
        varNames{end+1} = sprintf('Channel %d DC Power (W)', i);
    end
    
    % Add total DC drain power if there are multiple channels.
    if numChannels > 1
        varNames{end+1} = 'Total DC Drain Power (W)';
        varNames{end+1} = 'Total DC Gate Power (W)';
    end
        
    % Add efficiency columns independent of active channels.
    varNames = [varNames, 'DE (%)', 'PAE (%)'];
    varTypes = repmat({'double'}, 1, length(varNames));
    
    % Create the PA results table.
    ResultsTable = table('Size', [totalMeasurements, length(varNames)], ...
                         'VariableTypes', varTypes, ...
                         'VariableNames', varNames);
end
