function fullFilename = saveData(combinedData, csombinedNames)
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Constants
    EXCEL_MAX_ROWS = 1048576;  % Maximum number of rows in Excel
    EXCEL_MAX_COLUMNS = 16384; % Maximum number of columns in Excel

    if nargin < 2
        combinedNames = '';
        passedExcelLimit = true;
    end
    
    if strcmp(class(combinedData), 'table')
        dataTable = combinedData;
    else
        dataTable = array2table(combinedData, 'VariableNames', combinedNames);
    end

    % Raise flag is there is too much data for an .xlsx file
    if height(dataTable) >= EXCEL_MAX_ROWS || width(dataTable) > EXCEL_MAX_COLUMNS
        passedExcelLimit = true;
    else
        passedExcelLimit = false;
    end

    try
        if passedExcelLimit
            % Prompt the user to save the data into a CSV file
            [filename, path] = uiputfile({'*.csv', 'CSV Files (*.csv)';}, 'Save Data As');
        else
            % Prompt the user to save the data into a CSV or Excel file
            [filename, path] = uiputfile({'*.csv', 'CSV Files (*.csv)';'*.xlsx', 'Excel Files (*.xlsx)'}, 'Save Data As');
        end
    catch ME
        error('Data saving was canceled.')
    end

    % Handle the user cancelling the prompt
    if isequal(filename, 0) || isequal(path, 0)
        return;
    end

    fullFilename = fullfile(path, filename);
    writetable(dataTable, fullFilename);
    disp(['Data saved to ', fullFilename]);
end