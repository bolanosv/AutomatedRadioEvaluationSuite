function paramTable = createPAParametersTable(app)
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
    
    voltageSets = cell(1, numChannels);
    currentSets = cell(1, numChannels); 
    
    % Build variable names dynamically
    varNames = [{'Frequency', 'RF Input Power'},... 
               arrayfun(@(i) {sprintf('Channel %d Voltage', i), sprintf('Channel %d Current', i) }, 1:numChannels, 'UniformOutput', false)];
    varNames = horzcat(varNames{:});
    
    for i = 1:numChannels
        channel = app.FilledPSUChannels{i};
        settings = app.ChannelNames.(channel);
    
        if strcmp(settings.Mode, 'Sweep')
            voltageSets{i} = settings.Start:settings.Step:settings.Stop;
        else
            voltageSets{i} = settings.Start; 
        end
    
        currentSets{i} = settings.Current;
    end
    
    VCSets = reshape([voltageSets; currentSets], 1, []);
    
    gridInputs = [{RFInputPower, frequencies}, VCSets];
    grids = cell(1, numel(gridInputs));
    [grids{:}] = ndgrid(gridInputs{:});
    
    % Reshape into combinations: Frequency, Power, V1, C1, V2, C2, ...
    combinations = [grids{2}(:), grids{1}(:), cell2mat(cellfun(@(g) g(:), grids(3:end), 'UniformOutput', false))];
    
    paramTable = array2table(combinations, 'VariableNames', varNames);
end