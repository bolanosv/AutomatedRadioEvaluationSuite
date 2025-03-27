function saveData(combinedData, combinedNames, passedExcelLimit)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function saves data from the application into either a CSV or
    % Excel file. The user passes in the combined test data and combined 
    % test variable names, the function saves and organizes the data.
    %
    % PARAMETERS
    % combinedData:  Cell array containing the data for all measurement
    %                variables. Example: {testFrequency, testGain, ...}
    % combinedNames: Cell array containing the titles of the measurement
    %                variables. Example: {'Frequency Hz', 'Gain dB', ...}
    % ExcelLimit:    Boolean flag, signaling if the data to be stored is
    %                bigger than what Excel can handle for a column.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    dataTable = array2table(combinedData, 'VariableNames', combinedNames);

    if passedExcelLimit
        % Prompt the user to save the data into a CSV file
        [filename, path] = uiputfile({'*.csv', 'CSV Files (*.csv)';}, 'Save Data As');
    else
        % Prompt the user to save the data into a CSV or Excel file
        [filename, path] = uiputfile({'*.csv', 'CSV Files (*.csv)';'*.xlsx', 'Excel Files (*.xlsx)'}, 'Save Data As');
    end

    % Handle the user cancelling the prompt
    if isequal(filename, 0) || isequal(path, 0)
        return;
    end

    fullFilename = fullfile(path, filename);
    writetable(dataTable, fullFilename);
    disp(['Data saved to ', fullFilename]);
end