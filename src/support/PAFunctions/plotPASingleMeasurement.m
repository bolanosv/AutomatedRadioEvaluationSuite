function plotPASingleMeasurement(app)
    % This function plots the data from the single frequency measurement.
    cla(app.SingleFrequencyPAPlot,"reset");
    clear legendEntries legendHandles;
    
    % Index the plot for the selected supply voltages
    idx = true(height(app.PA_DataTable), 1);
    for i = 1:length(app.PA_PSU_SelectedVoltages)
        idx_i = app.PA_DataTable.(sprintf('Channel%dVoltagesV', app.PA_PSU_Channels(i))) == app.PA_PSU_SelectedVoltages(i);
        idx = idx & idx_i;
    end

    % Plot Gain on the left y-axis
    yyaxis(app.SingleFrequencyPAPlot, 'left');
    h1 = plot(app.SingleFrequencyPAPlot, app.PA_DataTable(idx,:).RFOutputPowerdBm, app.PA_DataTable(idx,:).Gain, 'k-');
    hold(app.SingleFrequencyPAPlot, 'on');
    grid(app.SingleFrequencyPAPlot, 'on');
    ylabel(app.SingleFrequencyPAPlot, 'Gain (dB)', 'FontWeight', 'bold');
    
    % Plot DE and PAE on the right y-axis.
    yyaxis(app.SingleFrequencyPAPlot, 'right');
    h2 = plot(app.SingleFrequencyPAPlot, app.PA_DataTable(idx,:).RFOutputPowerdBm, app.PA_DataTable(idx,:).DE, 'b-');
    h3 = plot(app.SingleFrequencyPAPlot, app.PA_DataTable(idx,:).RFOutputPowerdBm, app.PA_DataTable(idx,:).PAE, 'r--');
    ylabel(app.SingleFrequencyPAPlot, 'Efficiency (%)', 'FontWeight', 'bold');

    xlabel(app.SingleFrequencyPAPlot, 'Output Power (dBm)', 'FontWeight', 'bold');
    title(app.SingleFrequencyPAPlot, 'PA Performance Metrics', 'FontWeight', 'bold');

    legendEntries = {'Gain', 'DE', 'PAE'};
    legendHandles = [h1, h2, h3];


    % Plot Gain on the left y-axis
    yyaxis(app.SingleFrequencyPAPlot, 'left');
    
    % Getting the peak values
    [Psat, peakGain, peakDE, peakPAE, compression1dB, compression3dB] = measureRFParametersPeaks(app,idx);

    % Plot Psat and compression points
    for i = 1:height(Psat)      
        h4 = plot(app.SingleFrequencyPAPlot, Psat(i,:).RFOutputPowerdBm, Psat(i,:).Gain, ...
          'gx', 'MarkerSize', 8, 'LineWidth', 2); % Green circle marker
        legendHandles(end+1) = h4;
        legendEntries{end+1} = 'P_{sat}';
    end
    for i = 1:height(compression1dB)           
        h5 = plot(app.SingleFrequencyPAPlot, compression1dB(i,:).RFOutputPowerdBm,  compression1dB(i,:).Gain, ...
          'rx', 'MarkerSize', 8, 'LineWidth', 2); % Green circle marker
        legendHandles(end+1) = h5;
        legendEntries{end+1} = 'P_{-1 dB}';
    end
    for i = 1:height(compression3dB)           
        h6 = plot(app.SingleFrequencyPAPlot, compression3dB(i,:).RFOutputPowerdBm,  compression3dB(i,:).Gain, ...
          'rx', 'MarkerSize', 8, 'LineWidth', 2); % Green circle marker
        legendHandles(end+1) = h6;
        legendEntries{end+1} = 'P_{-3 dB}';
    end

    axis(app.SingleFrequencyPAPlot,'tight')

    if numel(legendHandles) == numel(legendEntries)
        lgd = legend(app.SingleFrequencyPAPlot, legendHandles, legendEntries, 'Location', 'west');
        lgd.Box = 'on';
        lgd.FontSize = 12;
    else
        error('Mismatch between legend handles and entries.');
    end


    % Plotting the compression points is not filtered by supply voltages yet. Use the PA_DataTable instead of individual variables
    % Plot the compresssion points.
    % if ~isnan(peakValues{1}) % saturation
    %     h4 = plot(app.SingleFrequencyPAPlot, app.PA_DataTable.RFOutputPowerdBm(idxAll), interp1(app.PA_DataTable.RFOutputPowerdBm(idxAll), app.PA_DataTable.Gain(idxAll), peakValues{1}), ...
    %       'go', 'MarkerSize', 8, 'LineWidth', 2); % Green circle marker
    %     legendHandles(end+1) = h4;
    %     legendEntries{end+1} = 'P_{sat}';
    % end
    % if ~isnan(peakValues{5}) % -1db compression
    %     h5 = plot(app.SingleFrequencyPAPlot, app.PA_DataTable.RFOutputPowerdBm(idxAll), interp1(app.PA_DataTable.RFOutputPowerdBm(idxAll), app.PA_DataTable.Gain(idxAll), peakValues{5}), ...
    %       'mo', 'MarkerSize', 8, 'LineWidth', 2); % Magenta circle marker
    %     legendHandles(end+1) = h5; 
    %     legendEntries{end+1} = 'P_{1dB}';
    % end
    % if ~isnan(peakValues{6}) % -3db compression
    %     h6 = plot(app.SingleFrequencyPAPlot, app.PA_DataTable.RFOutputPowerdBm(idxAll), interp1(app.PA_DataTable.RFOutputPowerdBm(idxAll), app.PA_DataTable.Gain(idxAll), peakValues{6}), ...
    %       'co', 'MarkerSize', 8, 'LineWidth', 2); % Cyan circle marker
    %     legendHandles(end+1) = h6; 
    %     legendEntries{end+1} = 'P_{3dB}';
    % end
    % 
end
