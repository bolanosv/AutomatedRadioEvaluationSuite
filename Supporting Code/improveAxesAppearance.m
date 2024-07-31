function improveAxesAppearance(axesObj)
    % Improve the appearance of axes in MATLAB App Designer and optionally save the figure
    % axesObj: handle to the UIAxes object
    
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
    axesObj.LineWidth = 1.5;
    
    % Enhance legend appearance (if present)
    if ~isempty(axesObj.Legend)
        axesObj.Legend.FontSize = 10;
        axesObj.Legend.Location = 'southwest';
        axesObj.Legend.Box = 'on';
    end
    
    % Set axis labels to bold
    axesObj.XLabel.FontWeight = 'bold';
    axesObj.YLabel.FontWeight = 'bold';
    
    % Adjust axis limits to ensure all data is visible (if there are any children)
    if ~isempty(axesObj.Children)
        xData = [];
        yData = [];
        for i = 1:length(axesObj.Children)
            if isprop(axesObj.Children(i), 'XData') && isprop(axesObj.Children(i), 'YData')
                xData = [xData, axesObj.Children(i).XData];
                yData = [yData, axesObj.Children(i).YData];
            end
        end
        if ~isempty(xData) && ~isempty(yData)
            axesObj.XLim = [min(xData), max(xData)];
            axesObj.YLim = [min(yData), max(yData)];
        end
    end
end