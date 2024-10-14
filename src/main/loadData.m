function combinedData = loadData(component)
    % This function loads data in from a CSV or Excel file containing a 
    % single or sweep PA test measurement, or an Antenna test measurement. 
    %
    % Parameters
    % componenet: Either 'PA' or 'Antenna' depending on which type of 
    %             measurement is being loaded.
    
    [file, path, ~] = uigetfile({'*.csv;*.xls;*.xlsx', 'Data Files (*.csv, *.xls, *.xlsx)'});
    FileName = fullfile(path, file);
    FileData = importdata(FileName);

    assignin('base', 'loadedFilePath', FileName);

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
                baseName = regexp(header, '(^[A-Z][0-9]+)', 'match', 'once');
    
                if isempty(baseName)
                    baseName = regexp(header, '^[^\d_]+', 'match', 'once');
                end
                
                validBaseName = matlab.lang.makeValidName(baseName, 'ReplacementStyle', 'delete');
        
                if isfield(combinedData, validBaseName)
                    combinedData.(validBaseName) = [combinedData.(validBaseName), headerValues{i, 2}];
                else
                    combinedData.(validBaseName) = headerValues{i, 2};
                end
            end
        end
    end
end