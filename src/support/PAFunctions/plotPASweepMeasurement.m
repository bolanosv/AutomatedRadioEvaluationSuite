function plotPASweepMeasurement(app)
    % This function plots the data from the frequency sweep measurement.

    % Clear existing plots.
    cla(app.GainvsOutputPowerPlot);
    cla(app.PeakGainPlot);
    cla(app.PeakDEPAEPlot);
    cla(app.CompressionPointsPlot);

    % Nnumber of frequencies.
    numFreqs = length(app.PA_Frequencies);

    % Get peak values from RF measurements.
    peakValues = measureRFParametersPeaks(app);
    
    % 1) Gain vs. Output RF Power
    hold(app.GainvsOutputPowerPlot, 'on'); 
    for i = 1:numFreqs
        plot(app.GainvsOutputPowerPlot, app.PA_RFOutputPower(i, :), app.PA_Gain(i, :));
    end
    hold(app.GainvsOutputPowerPlot, 'off');
    title(app.GainvsOutputPowerPlot, 'Gain vs. Output Power');
    xlabel(app.GainvsOutputPowerPlot, 'Output Power (dBm)');
    ylabel(app.GainvsOutputPowerPlot, 'Gain (dB)');
    
    % 2) Peak Gain vs. Frequency
    plot(app.PeakGainPlot, app.PA_Frequencies / 1E9, peakValues{2}, 'b-o');
    title(app.PeakGainPlot, 'Peak Gain');
    xlabel(app.PeakGainPlot, 'Frequency (GHz)');
    ylabel(app.PeakGainPlot, 'Gain (dB)');
    
    % 3) Peak DE & PAE vs. Frequency
    hold(app.PeakDEPAEPlot, 'on');
    h1 = plot(app.PeakDEPAEPlot, app.PA_Frequencies / 1E9, peakValues{3}, 'b-o');
    h2 = plot(app.PeakDEPAEPlot, app.PA_Frequencies / 1E9, peakValues{4}, 'r-o');
    hold(app.PeakDEPAEPlot, 'off');
    title(app.PeakDEPAEPlot, 'Peak DE and PAE');
    xlabel(app.PeakDEPAEPlot, 'Frequency (GHz)');
    ylabel(app.PeakDEPAEPlot, 'Efficiency (%)');
    legend(app.PeakDEPAEPlot, [h1, h2], {'DE', 'PAE'}, 'Location', 'best');

    % 4) Saturation Power & Compression Points
    hold(app.CompressionPointsPlot, 'on');
    plotColors = {'k', 'r', 'b'};
    legendLabels = {'P_{sat}', 'P_{-1dB}', 'P_{-3dB}'};
    plotHandles = [];
    usedLabels = {};
    
    % Plot each metric if it has valid data.
    % Saturation Power
    validIdx = ~isnan(peakValues{1});
    if any(validIdx)
        h1 = plot(app.CompressionPointsPlot, app.PA_Frequencies(validIdx) / 1E9, peakValues{1}(validIdx), [plotColors{1}, '-o']);
        plotHandles = [plotHandles, h1];
        usedLabels{end+1} = legendLabels{1};
    end
    
    % -1dB Compression Point
    validIdx = ~isnan(peakValues{5});
    if any(validIdx)
        h2 = plot(app.CompressionPointsPlot, app.PA_Frequencies(validIdx) / 1E9, peakValues{5}(validIdx), [plotColors{2}, '-o']);
        plotHandles = [plotHandles, h2];
        usedLabels{end+1} = legendLabels{2};
    end
    
    % -3dB Compression Point
    validIdx = ~isnan(peakValues{6});
    if any(validIdx)
        h3 = plot(app.CompressionPointsPlot, app.PA_Frequencies(validIdx) / 1E9, peakValues{6}(validIdx), [plotColors{3}, '-o']);
        plotHandles = [plotHandles, h3];
        usedLabels{end+1} = legendLabels{3};
    end  

    title(app.CompressionPointsPlot, 'Saturation Power and Compression Points');
    xlabel(app.CompressionPointsPlot, 'Frequency (GHz)');
    ylabel(app.CompressionPointsPlot, 'Output Power (dBm)');
    hold(app.CompressionPointsPlot, 'off');
    if ~isempty(plotHandles)
        legend(app.CompressionPointsPlot, plotHandles, usedLabels, 'Location', 'best');
    end
   
    % Improves the appearance of each plot, can adjust the line
    % thickness/width as desired.
    improveAxesAppearance(app.GainvsOutputPowerPlot, 'YYAxis', 'false', 'LineThickness', 1);
    improveAxesAppearance(app.PeakGainPlot, 'YYAxis', 'false', 'LineThickness', 1.5);
    improveAxesAppearance(app.PeakDEPAEPlot, 'YYAxis', 'false', 'LineThickness', 1.5);
    improveAxesAppearance(app.CompressionPointsPlot, 'YYAxis', 'false', 'LineThickness', 1.5);
end
