function combinedData = loadData(component)
    % This function loads data from a file containing a single or sweep PA 
    % measurement, or an Antenna measurement. 
    [file, path, ~] = uigetfile({'*.csv;*.xls;*.xlsx', 'Data Files (*.csv, *.xls, *.xlsx)'});
    filename = fullfile(path, file);
    [~, ~, ext] = fileparts(file);
    FileData = importdata(filename);

    if strcmp(component, 'PA')
        if isfield(FileData, 'textdata') && isfield(FileData, 'data')
            headers = FileData.textdata(1, :);
        
            numColumns = size(FileData.data, 2);
            numHeaders = min(length(headers), numColumns); 
            headerValues = cell(numHeaders, 2);
        
            for i = 1:numHeaders
                header = headers{i};
                headerValues{i, 1} = header;
                headerValues{i, 2} = FileData.data(:, i);
            end
        
            combinedData = struct();
        
            for i = 1:numHeaders
                header = headers{i};
                baseName = regexp(header, '^[^\d_]+', 'match', 'once');
                validBaseName = matlab.lang.makeValidName(baseName, 'ReplacementStyle', 'delete');
        
                if isfield(combinedData, validBaseName)
                    combinedData.(validBaseName) = [combinedData.(validBaseName), headerValues{i, 2}];
                else
                    combinedData.(validBaseName) = headerValues{i, 2};
                end
            end
        end
    elseif strcmp(component, 'Antenna')
        switch ext
            case '.csv'
                FileData = readtable(filename, 'PreserveVariableNames', true);
            case {'.xls', '.xlsx'}
                FileData = readtable(filename, 'PreserveVariableNames', true);
            otherwise
                error('Unsupported file type: %s', ext);
        end
        
        headers = FileData.Properties.VariableNames;
        
        combinedData = struct();
        
        for i = 1:length(headers)
            header = headers{i};
            validFieldName = matlab.lang.makeValidName(header, 'ReplacementStyle', 'delete');
            
            if isfield(combinedData, validFieldName)
                validFieldName = strcat(validFieldName, '_', num2str(i));
            end
            
            combinedData.(validFieldName) = FileData{:, i};
        end
    end

end