function saveData(combinedData, combinedNames)
    % This function saves data from the application into either a CSV or
    % Excel file. The user passes in the combined test data and combined 
    % test variable names, the function saves and organizes the data.
    %
    % Parameters
    % combinedData:  Cell array containing the data for all measurement
    %                variables. Example: {testFreq, testGain, ...}
    % combinedNames: Cell array containing the titles of the measurement
    %                variables. Example: {'Frequency Hz', 'Gain dB', ...}

    dataTable = array2table(combinedData, 'VariableNames', combinedNames);

    % Prompt the user to save the data into either CSV or Excel file
    [filename, path] = uiputfile({'*.csv', 'CSV Files (*.csv)'; ...
                                   '*.xlsx', 'Excel Files (*.xlsx)'}, ...
                                   'Save Data As');

    % Hadle the user cancelling the prompt
    if isequal(filename, 0) || isequal(path, 0)
        return;
    end

    fullFilename = fullfile(path, filename);
    writetable(dataTable, fullFilename);
    disp(['Data saved to ', fullFilename]);
end