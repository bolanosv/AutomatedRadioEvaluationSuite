function plotAntenna2DMeasurement(app, sweepPoints)            
    cla(app.GainvsFrequency2D);
    cla(app.ReturnLoss2D);
    cla(app.GainvsAngle2D);
    cla(app.RadiationPlot2D);

    % Specified Angle Plotting  
    angleIndices = (app.angleRange*sweepPoints+1):((app.angleRange+1)*sweepPoints);
    angleGain = app.antennaGain(angleIndices);
    angleReturnLoss = app.antennaRL(angleIndices);

    % Specified Frequency Plotting
    frequencyIndices = app.frequencyRange:sweepPoints:length(app.antennaGain);
    frequencyGain = app.antennaGain(frequencyIndices);

    %disp(size(angleGain))
    %disp(size(app.AzimuthAngles))
    %disp(size(frequencyGain))

    % Antenna Gain vs. Frequency, at specified angle
    plot(app.GainvsFrequency2D, app.sweepFrequencies/1E9, angleGain);
    title(app.GainvsFrequency2D, sprintf('Gain vs. Frequency at %1.0f^{\\circ}', str2double(app.selectedAngle)));
    xlabel(app.GainvsFrequency2D, 'Frequency (GHz)');
    ylabel(app.GainvsFrequency2D, 'Gain (dBi)');
    app.setAxisLimits(app.GainvsFrequency2D, angleGain);

    % Antenna Gains vs. Angles, at specified frequency.
    plot(app.GainvsAngle2D, app.azimuthAngles, frequencyGain);
    title(app.GainvsAngle2D, 'Gain vs. Angle');
    xlabel(app.GainvsAngle2D, 'Angle (degrees)');
    ylabel(app.GainvsAngle2D, 'Gain (dBi)');
    xlim(app.GainvsAngle2D, [-180 180]);
    app.setAxisLimits(app.GainvsAngle2D, frequencyGain);

    % Return Loss (dB) Plot
    plot(app.ReturnLoss2D, app.sweepFrequencies/1E9, angleReturnLoss);
    title(app.ReturnLoss2D, sprintf('Return Loss at %1.0f^{\\circ}', str2double(app.selectedAngle)));
    xlabel(app.ReturnLoss2D, 'Frequency (GHz)');
    ylabel(app.ReturnLoss2D, 'RL (dB)');

    % 2D Radiation Pattern Plot
    polarplot(app.RadiationPlot2D, deg2rad(app.azimuthAngles), frequencyGain);
    title(app.RadiationPlot2D, sprintf('Radiation Pattern at %1.3f GHz', str2double(app.selectedFrequency)));
    thetalim(app.RadiationPlot2D, [0 360]);
    app.setAxisLimits(app.RadiationPlot2D, frequencyGain);

    improveAxesAppearance(app.GainvsFrequency2D, 'LineThickness', 2);
    improveAxesAppearance(app.ReturnLoss2D, 'LineThickness', 2);
    improveAxesAppearance(app.GainvsAngle2D, 'LineThickness', 2);
    %improveAxesAppearance(app.RadiationPlot2D);
end
