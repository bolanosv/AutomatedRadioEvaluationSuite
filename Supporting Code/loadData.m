function combinedData = loadData(component)
    % This function loads data from a file containing either a single or,
    % sweep PA measurement. 
    [file, path, ~] = uigetfile({'*.csv;*.xls;*.xlsx', 'Data Files (*.csv, *.xls, *.xlsx)'});
    filename = fullfile(path, file);
    [~, ~, ext] = fileparts(file);
    FileData = importdata(filename);

    if strcmp(component, 'PA')
        if isfield(FileData, 'textdata') && isfield(FileData, 'data')
            % Extract headers from the first row of textdata, including the first column
            headers = FileData.textdata(1, :);
        
            % Initialize a cell array to hold the values for each header
            numColumns = size(FileData.data, 2);
            numHeaders = min(length(headers), numColumns); 
            headerValues = cell(numHeaders, 2);
        
            % Loop through each header and extract the corresponding column
            for i = 1:numHeaders
                header = headers{i};
                headerValues{i, 1} = header;
                headerValues{i, 2} = FileData.data(:, i);
            end
        
            % Combine data for headers with similar names (e.g., Power Added Efficiency)
            combinedData = struct();
        
            for i = 1:numHeaders
                header = headers{i};
                % Extract base name without _1, _2, etc.
                baseName = regexp(header, '^[^\d_]+', 'match', 'once');
                % Make base name a valid field name
                validBaseName = matlab.lang.makeValidName(baseName);
                %validBaseName = matlab.lang.makeValidName(baseName, 'ReplacementStyle', 'delete');
        
                if isfield(combinedData, validBaseName)
                    % Concatenate the data for the same base name
                    combinedData.(validBaseName) = [combinedData.(validBaseName), headerValues{i, 2}];
                else
                    % Initialize with the first data
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
        
        % Extract headers
        headers = FileData.Properties.VariableNames;
        
        % Initialize a struct to hold the values for each header
        combinedData = struct();
        
        % Loop through each header and extract the corresponding column
        for i = 1:length(headers)
            header = headers{i};
            % Use the original header name as the field name
            validFieldName = matlab.lang.makeValidName(header, 'ReplacementStyle', 'delete');
            
            % Handle the case where the header might have been modified
            if isfield(combinedData, validFieldName)
                validFieldName = strcat(validFieldName, '_', num2str(i));
            end
            
            combinedData.(validFieldName) = FileData{:, i};
        end
    end

end