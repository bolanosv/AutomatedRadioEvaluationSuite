function improveAxesAppearance(axesObj, varargin)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Improve the appearance of axes in MATLAB App Designer, handles plots
    % containing two graphs one on the left y axis and the other on the
    % right y axis, sharing the same x axis.
    %
    % INPUT PARAMETERS
    % axesObj:       Handle to the UIAxes object.
    % varargin:      Optional name-value pairs for 'YYAxis', 'LineWidth'.
    % YYAxis:        Boolean flag, to handle plots with graphs on the left 
    %                and right y axis, sharing the same x axis.
    % LineThickness: Positive numeric scalar, to handle the thickness.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    defaultYYAxis = 'false';
    defaultLineThickness = 1.5;

    p = inputParser;
    addRequired(p, 'axesObj');
    addParameter(p, 'YYAxis', defaultYYAxis, @(x) ischar(x) || isstring(x));
    addParameter(p, 'LineThickness', defaultLineThickness, @(x) isnumeric(x) && isscalar(x) && (x > 0));

    parse(p, axesObj, varargin{:});

    YYAxis = p.Results.YYAxis;
    LineThickness = p.Results.LineThickness;
    
    % Set font sizes
    axesObj.FontSize = 12;
    axesObj.TitleFontSizeMultiplier = 1.2;
    axesObj.LabelFontSizeMultiplier = 1.1;
    
    % Enhance grid appearance
    axesObj.GridLineStyle = ':';
    axesObj.GridAlpha = 0.3;
    axesObj.GridColor = [0.5 0.5 0.5];
    
    % Adjust box and axis line properties
    axesObj.Box = 'on';
    axesObj.LineWidth = 1.5; % Box Edge Width

    % Modify linewidth properties for the left and right yyaxis
    if strcmp(YYAxis, 'true')
        yyaxis(axesObj, 'left');  % Switch to left axis
        modifyLineThickness(axesObj, LineThickness);    
        yyaxis(axesObj, 'right'); % Switch to right axis
        modifyLineThickness(axesObj, LineThickness);
    else
        modifyLineThickness(axesObj, LineThickness);
    end
    
    % Enhance legend appearance (if present)
    if ~isempty(axesObj.Legend)
        axesObj.Legend.FontSize = 10;
        axesObj.Legend.Location = 'best';
        axesObj.Legend.Box = 'on';
    end
    
    % Set axis labels to bold
    axesObj.XLabel.FontWeight = 'bold';
    axesObj.YLabel.FontWeight = 'bold';
    end

function modifyLineThickness(axesObj, LineThickness)
    % Helper function to adjust line properties
    if ~isempty(axesObj.Children)
        for i = 1:length(axesObj.Children)
            if isprop(axesObj.Children(i), 'LineWidth')
                axesObj.Children(i).LineWidth = LineThickness;
            end
        end
    end
end