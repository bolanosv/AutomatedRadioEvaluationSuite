function improveTableAppearance(tableObj)
    % Improve the appearance of a table in MATLAB App Designer
    % tableObj: The UITable object

    % Get the current data
    data = tableObj.Data;

    % Get the size of the data
    [~, cols] = size(data);

    % Process column headers
    columnHeaders = tableObj.ColumnName;
    for i = 1:length(columnHeaders)
        columnHeaders{i} = justifyContent(columnHeaders{i});
    end
    tableObj.ColumnName = columnHeaders;

    % Calculate the width of each column based on content
    columnWidth = cell(1, cols);
    for col = 1:cols
        if iscell(data)
            columnContent = data(:, col);
        elseif istable(data)
            columnContent = table2cell(data(:, col));
        else
            columnContent = num2cell(data(:, col));
        end
        
        % Trim whitespace and justify content
        columnContent = cellfun(@(x) justifyContent(x), columnContent, 'UniformOutput', false);
        
        columnHeader = columnHeaders{col};
        contentWidth = max(cellfun(@(x) length(char(x)), columnContent));
        headerWidth = length(columnHeader);
        estimatedWidth = max(contentWidth, headerWidth) + 2; % Add padding
        columnWidth{col} = sprintf('%dx', estimatedWidth); % Use 'x' format
    end

    % Set column widths
    tableObj.ColumnWidth = columnWidth;

    % Set other properties for better appearance
    tableObj.RowName = 'numbered';
    tableObj.ColumnSortable = true;
    tableObj.FontName = 'Arial';
    tableObj.FontSize = 12;

    % Enable row striping for better readability
    tableObj.RowStriping = 'on';

    % Adjust selection highlighting
    tableObj.SelectionType = 'row';

    % Manually format numeric columns
    for col = 1:cols
        if iscell(data) && isnumeric(data{1, col})
            data(:, col) = cellfun(@(x) num2str(x, '%.2f'), data(:, col), 'UniformOutput', false);
        elseif istable(data) && isnumeric(data{:, col}(1))
            data.(col) = arrayfun(@(x) num2str(x, '%.2f'), data.(col), 'UniformOutput', false);
        elseif isnumeric(data) && ~isempty(data)
            data(:, col) = arrayfun(@(x) num2str(x, '%.2f'), data(:, col), 'UniformOutput', false);
        end
    end

    % Update table data
    tableObj.Data = data;
end

function justifiedContent = justifyContent(content)
    % Justify content by trimming whitespace and padding if necessary
    if ischar(content) || isstring(content)
        content = strtrim(char(content)); % Trim whitespace
        maxWidth = 20; % Set a maximum width for the content
        if length(content) < maxWidth
            padding = repmat(' ', 1, maxWidth - length(content));
            justifiedContent = [content, padding]; % Right-justify
        else
            justifiedContent = content(1:maxWidth); % Truncate if too long
        end
    else
        justifiedContent = content; % Return as-is if not a string
    end
end