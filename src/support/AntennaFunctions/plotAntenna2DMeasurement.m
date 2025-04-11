function plotAntenna2DMeasurement(app, sweepPoints)            
    cla(app.GainvsFrequency2D);
    cla(app.ReturnLoss2D);
    cla(app.GainvsAngle2D);
    cla(app.RadiationPlot2D);

    % Specified Angle Plotting  
    angleIndices = (app.angleRange*sweepPoints+1):((app.angleRange+1)*sweepPoints);
    angleGain = app.AntennaGain_dBi(angleIndices);
    angleReturnLoss = app.S11_Mag_dB(angleIndices);

    % Specified Frequency Plotting
    frequencyIndices = app.frequencyRange:sweepPoints:length(app.AntennaGain_dBi);
    frequencyGain = app.AntennaGain_dBi(frequencyIndices);

    % Antenna Gain vs. Frequency, at specified angle
    plot(app.GainvsFrequency2D, app.Antenna_Frequencies / 1E3, angleGain);
    title(app.GainvsFrequency2D, sprintf('Gain vs. Frequency at %1.0f^{\\circ}', str2double(app.selectedAngle)));
    xlabel(app.GainvsFrequency2D, 'Frequency (GHz)');
    ylabel(app.GainvsFrequency2D, 'Gain (dBi)');
    axis(app.GainvsFrequency2D, 'tight');

    % Antenna Gains vs. Angles, at specified frequency.
    plot(app.GainvsAngle2D, app.Theta, frequencyGain);
    title(app.GainvsAngle2D, sprintf('Gain vs. Angle at %1.3f GHz', str2double(app.selectedFrequency)));
    xlabel(app.GainvsAngle2D, 'Angle (degrees)');
    ylabel(app.GainvsAngle2D, 'Gain (dBi)');
    axis(app.GainvsAngle2D, 'tight');

    % Return Loss (dB) Plot
    plot(app.ReturnLoss2D, app.Antenna_Frequencies / 1E3, angleReturnLoss);
    title(app.ReturnLoss2D, sprintf('Return Loss at %1.0f^{\\circ}', str2double(app.selectedAngle)));
    xlabel(app.ReturnLoss2D, 'Frequency (GHz)');
    ylabel(app.ReturnLoss2D, 'RL (dB)');
    axis(app.ReturnLoss2D, 'tight');

    % 2D Radiation Pattern Plot
    polarplot(app.RadiationPlot2D, deg2rad(app.Theta), frequencyGain);
    title(app.RadiationPlot2D, sprintf('Radiation Pattern at %1.3f GHz', str2double(app.selectedFrequency)));
    axis(app.RadiationPlot2D, 'tight');

    improveAxesAppearance(app.GainvsFrequency2D, 'LineThickness', 2);
    improveAxesAppearance(app.ReturnLoss2D, 'LineThickness', 2);
    improveAxesAppearance(app.GainvsAngle2D, 'LineThickness', 2);
    h = findobj(app.RadiationPlot2D, 'Type', 'line');
    h.LineWidth = 2;
end
