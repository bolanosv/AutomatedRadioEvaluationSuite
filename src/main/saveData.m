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
    
    switch ext
        case '.csv'
            writetable(dataTable, filename);
            disp(['Data saved to ', filename]);
        case {'.xls', '.xlsx'}
            writetable(dataTable, filename);
            disp(['Data saved to ', filename]);
        otherwise
            error('Unsupported file type.');
    end
end