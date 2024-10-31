function combinedData = loadData(RFcomponent)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function loads data in from a CSV or Excel file containing a 
    % single or sweep PA test measurement, or an Antenna test measurement. 
    %
    % PARAMETERS
    % RFcomponenet: Either 'PA' or 'Antenna' depending on which type of 
    %               measurement is being loaded.
    %
    % RETURNS
    % combinedData: A struct containing all the data from each column of 
    %               the loaded file. User can acces specific data by 
    %               accesing the array's fields.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    combinedData = struct();
    
    [file, path, ~] = uigetfile({'*.csv;*.xls;*.xlsx', 'Data Files (*.csv, *.xls, *.xlsx)'});
    
    % Check if the user cancel the file selection
    if isequal(file, 0) || isequal(path, 0)
        return;
    end

    FileName = fullfile(path, file);
    FileData = importdata(FileName);

    % Check if the imported data is empty
    if isempty(FileData) 
        return;
    end

    % Store the file path in the base workspace, so user can acces it if
    % needed.
    assignin('base', 'loadedFilePath', FileName);

    if strcmp(RFcomponent, 'PA')
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
    elseif strcmp(RFcomponent, 'Antenna')
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