function prepareResultsForPlotting(app)
    % This function processes the measurement results table to prepare the data
    % for plotting with plotPASweepMeasurement
    
    % Check if results table exists
    if isempty(app.PAMeasurementsTable)
        warning('No measurement results available.');
        return;
    end
    
    % Extract data from the results table
    resultsTable = app.PAMeasurementsTable;
    
    % Get unique frequencies (in Hz)
    app.PA_Frequencies = unique(resultsTable.("Frequency (MHz)")) * 1E6;
    numFreqs = length(app.PA_Frequencies);
    
    % Get unique input power levels
    inputPowers = unique(resultsTable.("RF Input Power (dBm)"));
    numPowers = length(inputPowers);
    
    % Initialize arrays to store data for each frequency and power
    app.PA_RFOutputPower = zeros(numFreqs, numPowers);
    app.PA_Gain = zeros(numFreqs, numPowers);
    app.PA_DE = zeros(numFreqs, numPowers);
    app.PA_PAE = zeros(numFreqs, numPowers);
    
    % Populate the arrays
    for i = 1:numFreqs
        % Get rows for this frequency
        freqRows = resultsTable.("Frequency (MHz)") == app.PA_Frequencies(i)/1E6;
        
        % For each power level
        for j = 1:numPowers
            % Get row for this frequency and power
            idx = freqRows & resultsTable.("RF Input Power (dBm)") == inputPowers(j);
            
            if any(idx)
                % In case of multiple matches (e.g., voltage sweep), take the first one or average
                app.PA_RFOutputPower(i, j) = mean(resultsTable.("RF Output Power (dBm)")(idx));
                app.PA_Gain(i, j) = mean(resultsTable.("Gain")(idx));
                app.PA_DE(i, j) = mean(resultsTable.("DE (%)")(idx));
                app.PA_PAE(i, j) = mean(resultsTable.("PAE (%)")(idx));
            end
        end
    end
    
    % Sort data by input power for each frequency
    for i = 1:numFreqs
        % Get rows for this frequency
        freqRows = resultsTable.("Frequency (MHz)") == app.PA_Frequencies(i)/1E6;
        freqData = resultsTable(freqRows, :);
        
        % Sort by input power
        [~, sortIdx] = sort(freqData.("RF Input Power (dBm)"));
        sortedData = freqData(sortIdx, :);
        
        % Store in the app properties
        app.PA_RFOutputPower(i, :) = sortedData.("RF Output Power (dBm)")';
        app.PA_Gain(i, :) = sortedData.("Gain")';
        app.PA_DE(i, :) = sortedData.("DE (%)")';
        app.PA_PAE(i, :) = sortedData.("PAE (%)")';
    end
end
