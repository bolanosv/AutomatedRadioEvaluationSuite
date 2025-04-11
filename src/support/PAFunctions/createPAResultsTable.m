function ResultsTable = createPAResultsTable(app, totalMeasurements)
    % Create table with appropriate columns based on number of channels
    varNames = {'Frequency (MHz)'};
    
    % Number of channels that will be used.
    numChannels = length(app.FilledPSUChannels);

    % Add voltage columns for each channel
    for i = 1:numChannels
        varNames{end+1} = sprintf('Channel %d Voltages (V)', i);
    end
    
    % Add measurement columns
    varNames = [varNames, 'RF Input Power (dBm)', 'RF Output Power (dBm)', 'Gain'];
    
    % Add DC power columns for each channel
    for i = 1:numChannels
        varNames{end+1} = sprintf('Channel %d DC Power (W)', i);
    end
    
    % Add total DC drain power if multiple channels
    if numChannels > 1
        varNames{end+1} = 'Total DC Drain Power (W)';
        varNames{end+1} = 'Total DC Gate Power (W)';
    end
        
    % Add efficiency columns
    varNames = [varNames, 'DE (%)', 'PAE (%)'];
    varTypes = repmat({'double'}, 1, length(varNames));
    
    % Create results table
    ResultsTable = table('Size', [totalMeasurements, length(varNames)], ...
                       'VariableTypes', varTypes, ...
                       'VariableNames', varNames);
end
