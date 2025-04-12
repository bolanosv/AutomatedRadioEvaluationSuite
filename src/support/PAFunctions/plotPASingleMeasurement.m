function plotPASingleMeasurement(app)
    % This function plots the data from the single frequency measurement.
    cla(app.SingleFrequencyPAPlot);
    
    peakValues = measureRFParametersPeaks(app);
    %peakValues{1} is saturation power
    %peakValues{5} is the -1db compression point
    %peakValues{6} is the -3db compression point

    % Plot Gain on the left y-axis
    yyaxis(app.SingleFrequencyPAPlot, 'left');
    h1 = plot(app.SingleFrequencyPAPlot, app.PA_RFOutputPower, app.PA_Gain, 'k-');
    hold(app.SingleFrequencyPAPlot, 'on');
    grid(app.SingleFrequencyPAPlot, 'on');
    ylabel(app.SingleFrequencyPAPlot, 'Gain (dB)', 'FontWeight', 'bold');
    %set(app.SingleFrequencyPAPlot, 'YColor', 'k'); changes color of y axis

    % Plot DE and PAE on the right y-axis.
    yyaxis(app.SingleFrequencyPAPlot, 'right');
    h2 = plot(app.SingleFrequencyPAPlot, app.PA_RFOutputPower, app.PA_DE, 'b-');
    h3 = plot(app.SingleFrequencyPAPlot, app.PA_RFOutputPower, app.PA_PAE, 'r--');

    ylabel(app.SingleFrequencyPAPlot, 'Efficiency (%)', 'FontWeight', 'bold');
    %set(app.SingleFrequencyPAPlot, 'YColor', [0.3, 0.3, 0.3]);

    hold(app.SingleFrequencyPAPlot, 'off');
    xlabel(app.SingleFrequencyPAPlot, 'Output Power (dBm)', 'FontWeight', 'bold');
    title(app.SingleFrequencyPAPlot, 'PA Performance Metrics', 'FontWeight', 'bold');

    legendEntries = {'Gain', 'DE', 'PAE'};
    legendHandles = [h1, h2, h3];

    % Plot the compresssion points.
    if ~isnan(peakValues{1}) % saturation
        h4 = plot(app.SingleFrequencyPAPlot, app.PA_RFOutputPower, interp1(app.PA_RFOutputPower, app.PA_Gain, peakValues{1}), ...
          'go', 'MarkerSize', 8, 'LineWidth', 2); % Green circle marker
        legendHandles(end+1) = h4;
        legendEntries{end+1} = 'P_{sat}';
    end
    if ~isnan(peakValues{5}) % -1db compression
        h5 = plot(app.SingleFrequencyPAPlot, app.PA_RFOutputPower, interp1(app.PA_RFOutputPower, app.PA_Gain, peakValues{5}), ...
          'mo', 'MarkerSize', 8, 'LineWidth', 2); % Magenta circle marker
        legendHandles(end+1) = h5; 
        legendEntries{end+1} = 'P_{1dB}';
    end
    if ~isnan(peakValues{6}) % -3db compression
        h6 = plot(app.SingleFrequencyPAPlot, app.PA_RFOutputPower, interp1(app.PA_RFOutputPower, app.PA_Gain, peakValues{6}), ...
          'co', 'MarkerSize', 8, 'LineWidth', 2); % Cyan circle marker
        legendHandles(end+1) = h6; 
        legendEntries{end+1} = 'P_{3dB}';
    end

    if numel(legendHandles) == numel(legendEntries)
        lgd = legend(app.SingleFrequencyPAPlot, legendHandles, legendEntries, 'Location', 'best');
        lgd.Box = 'on';
        lgd.FontSize = 9;
    else
        error('Mismatch between legend handles and entries.');
    end

    return;

    % Plot the compression points
    % if ~isempty(idx_1dB)
    %     h4 = plot(app.SingleFrequencyPAPlot, app.RFOutputPdBm(idx_1dB), app.PAGain(idx_1dB), ...
    %         'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'blue', 'MarkerFaceColor', 'blue');
    % end
    % if ~isempty(idx_3dB)
    %     h5 = plot(app.SingleFrequencyPAPlot, app.RFOutputPdBm(idx_3dB), app.PAGain(idx_3dB), ...
    %         'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red'); 
    % end
    % if ~isempty(saturation_idx)
    %     h6 = plot(app.SingleFrequencyPAPlot, saturation_power, app.PAGain(saturation_idx), ...
    %         'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'green', 'MarkerFaceColor', 'green');
    % end
end
