function saveData(combinedData, combinedNames)
    [file, path, ~] = uiputfile({'*.csv', 'CSV file (*.csv)'; '*.xlsx', 'Excel file (*.xlsx)'}, 'Save as');
    filename = fullfile(path, file);
    [~, ~, ext] = fileparts(filename);
    
    dataTable = array2table(combinedData, 'VariableNames', combinedNames);
    
    switch ext
        case '.csv'
            % Save as CSV
            writetable(dataTable, filename);
            disp(['Data saved to ', filename]);
        case {'.xls', '.xlsx'}
            % Save as Excel
            writetable(dataTable, filename);
            disp(['Data saved to ', filename]);
        otherwise
            error('Unsupported file type.');
    end
end