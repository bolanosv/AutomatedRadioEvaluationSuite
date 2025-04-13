function plotPASweepMeasurement(app)
    % This function plots the data from the frequency sweep measurement.

    % Clear existing plots.
    cla(app.GainvsOutputPowerPlot,"reset");
    cla(app.PeakGainPlot,"reset");
    cla(app.PeakDEPAEPlot,"reset");
    cla(app.CompressionPointsPlot,"reset");
    clear legendEntries legendHandles;


    % Index the plot for the selected supply voltages
    idx = true(height(app.PA_DataTable), 1);
    for i = 1:length(app.PA_PSU_SelectedVoltages)
        idx_i = app.PA_DataTable.(sprintf('Channel%dVoltagesV', app.PA_PSU_Channels(i))) == app.PA_PSU_SelectedVoltages(i);
        idx = idx & idx_i;
    end

    % 1) Plot Gain vs. Pout
    % Frequencies to iterate over.
    freqs = unique(app.PA_DataTable(idx,"FrequencyMHz")); % Iterate by frequency
    hold(app.GainvsOutputPowerPlot, 'on'); 
    for i = 1:height(freqs)
        % Get temporary subtable for each frequency
        freq_DataTable = app.PA_DataTable(idx,:);
        freq_DataTable = freq_DataTable(freq_DataTable.FrequencyMHz == freqs.FrequencyMHz(i),:);
        
        % Plot Gain vs. Pout
        plot(app.GainvsOutputPowerPlot, freq_DataTable.RFOutputPowerdBm, freq_DataTable.Gain);
    end
    % Labels for Gain vs. Pout plot
    hold(app.GainvsOutputPowerPlot, 'off');
    title(app.GainvsOutputPowerPlot, 'Gain vs. Output Power');
    xlabel(app.GainvsOutputPowerPlot, 'Output Power (dBm)');
    ylabel(app.GainvsOutputPowerPlot, 'Gain (dB)');
    
    % Getting the peak values
    [Psat, peakGain, peakDE, peakPAE, compression1dB, compression3dB] = measureRFParametersPeaks(app,idx);

    % 2) Peak Gain vs. Frequency
    plot(app.PeakGainPlot, peakGain.FrequencyMHz, peakGain.max_Gain, 'b-o');
    title(app.PeakGainPlot, 'Peak Gain');
    xlabel(app.PeakGainPlot, 'Frequency (MHz)');
    ylabel(app.PeakGainPlot, 'Gain (dB)');

    % 3) Peak DE & PAE vs. Frequency
    hold(app.PeakDEPAEPlot, 'on');
    h1 = plot(app.PeakDEPAEPlot, peakDE.FrequencyMHz, peakDE.max_DE, 'b-o');
    h2 = plot(app.PeakDEPAEPlot, peakPAE.FrequencyMHz, peakPAE.max_PAE, 'r-o');
    hold(app.PeakDEPAEPlot, 'off');
    title(app.PeakDEPAEPlot, 'Peak DE and PAE');
    xlabel(app.PeakDEPAEPlot, 'Frequency (MHz)');
    ylabel(app.PeakDEPAEPlot, 'Efficiency (%)');
    legend(app.PeakDEPAEPlot, [h1, h2], {'DE', 'PAE'}, 'Location', 'best');
    
    % 4) Saturation Power & Compression Points
    hold(app.CompressionPointsPlot, 'on');
    legendLabels = {};
    plotHandles = [];
    
    % Plot each metric if it has valid data.
    % Saturation Power
    if height(Psat)>0
        h1 = plot(app.CompressionPointsPlot, Psat.FrequencyMHz, Psat.RFOutputPowerdBm, '-o', 'Color', 'k');
        plotHandles = [plotHandles, h1];
        legendLabels{end+1} = {'P_{sat}'};
    end
    
    % -1dB Compression Point
    if height(compression1dB) > 0
        h2 = plot(app.CompressionPointsPlot, compression1dB.FrequencyMHz, compression1dB.RFOutputPowerdBm, '-o', 'Color', 'r');
        plotHandles = [plotHandles, h2];
        legendLabels{end+1} = {'P_{-1dB}'};
    end
    
    % -3dB Compression Point
    if height(compression3dB) > 0
        h3 = plot(app.CompressionPointsPlot, compression3dB.FrequencyMHz, compression3dB.RFOutputPowerdBm, '-o', 'Color', 'b');
        plotHandles = [plotHandles, h3];
        legendLabels{end+1} = {'P_{-3dB}'};
    end  

    title(app.CompressionPointsPlot, 'Saturation Power and Compression Points');
    xlabel(app.CompressionPointsPlot, 'Frequency (MHz)');
    ylabel(app.CompressionPointsPlot, 'Output Power (dBm)');
    hold(app.CompressionPointsPlot, 'off');
    if ~isempty(plotHandles)
        legend(app.CompressionPointsPlot, plotHandles, string(legendLabels), 'Location', 'best');
    end
    
    % Improves the appearance of each plot, can adjust the line
    % thickness/width as desired.
    improveAxesAppearance(app.GainvsOutputPowerPlot, 'YYAxis', 'false', 'LineThickness', 1);
    improveAxesAppearance(app.PeakGainPlot, 'YYAxis', 'false', 'LineThickness', 1.5);
    improveAxesAppearance(app.PeakDEPAEPlot, 'YYAxis', 'false', 'LineThickness', 1.5);
    improveAxesAppearance(app.CompressionPointsPlot, 'YYAxis', 'false', 'LineThickness', 1.5);
end
