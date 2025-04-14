function plotAntenna2DRadiationPattern(app)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function plots the 2D antenna measurement data:
    %   - Gain vs. Frequency at a fixed theta/phi angle
    %   - Gain vs. Angle at a fixed frequency
    %   - Return Loss vs. Frequency
    %   - 2D polar radiation pattern (θ and φ cuts)
    %
    % INPUT PARAMETERS:
    %   app:  Application object containing antenna data and plot handles.
    %
    % This function:
    %   - Extracts data based on selected θ, φ, and frequency values
    %   - Updates four subplots with corresponding gain and return loss
    %   - Enhances plot visuals using helper formatting functions
    %   - Catches and displays errors using the app's error handler
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    try
        % Clear current plots.
        cla(app.GainvsFrequency2D);
        cla(app.ReturnLoss2D);
        cla(app.GainvsAngle2D);
        cla(app.RadiationPlot2D);
    
        % Specified angle and frequency plotting index
        idx_theta = (app.Antenna_Data.Thetadeg==str2double(app.PlotThetaDropDown.Value));
        idx_phi = (app.Antenna_Data.Phideg==str2double(app.PlotPhiDropDown.Value));
        idx_freq = (app.Antenna_Data.FrequencyMHz==str2double(app.PlotFrequencyMHzDropDown.Value));
        idx_angle = idx_theta & idx_phi; 
     
        % 1) Antenna Gain vs. Frequency, at specified angle
        plot(app.GainvsFrequency2D, app.Antenna_Data(idx_angle,:).FrequencyMHz, app.Antenna_Data(idx_angle,:).GaindBi);
        title(app.GainvsFrequency2D, sprintf('Gain vs. Frequency at \\Phi = %s^{\\circ} and \\theta = %s^{\\circ}', app.PlotPhiDropDown.Value,app.PlotThetaDropDown.Value));
        xlabel(app.GainvsFrequency2D, 'Frequency (MHz)');
        ylabel(app.GainvsFrequency2D, 'Gain (dBi)');
        axis(app.GainvsFrequency2D, 'tight');
    
        % 2) Antenna Gains vs. Angles, at specified frequency.
        h_phi = plot(app.GainvsAngle2D, app.Antenna_Data(idx_phi & idx_freq,:).Thetadeg, app.Antenna_Data(idx_phi & idx_freq,:).GaindBi);
        hold(app.GainvsAngle2D,'on');
        h_theta = plot(app.GainvsAngle2D, app.Antenna_Data(idx_theta & idx_freq,:).Phideg, app.Antenna_Data(idx_theta & idx_freq,:).GaindBi);
        hold(app.GainvsAngle2D,'off');
        title(app.GainvsAngle2D, sprintf('Gain vs. Angle at %s MHz', app.PlotFrequencyMHzDropDown.Value));
        xlabel(app.GainvsAngle2D, 'Angle (degrees)');
        ylabel(app.GainvsAngle2D, 'Gain (dBi)');
        lgd = legend(app.GainvsAngle2D, [h_phi,h_theta], {"\Phi Cut", "\theta Cut"}, 'Location', 'best');
        axis(app.GainvsAngle2D, 'tight');
        clear h_phi h_theta;
    
        % 3) Return Loss (dB) Plot
        plot(app.ReturnLoss2D, app.Antenna_Data(idx_angle,:).FrequencyMHz, app.Antenna_Data(idx_angle,:).ReturnLossdB);
        title(app.ReturnLoss2D, sprintf('Return Loss at \\Phi = %s^{\\circ} and \\theta = %s^{\\circ}', app.PlotPhiDropDown.Value,app.PlotThetaDropDown.Value));
        xlabel(app.ReturnLoss2D, 'Frequency (MHz)');
        ylabel(app.ReturnLoss2D, 'RL (dB)');
        axis(app.ReturnLoss2D, 'tight');
    
        % 4) 2D Radiation Pattern Plot
        h_phi = polarplot(app.RadiationPlot2D, deg2rad(app.Antenna_Data(idx_phi & idx_freq,:).Thetadeg), app.Antenna_Data(idx_phi & idx_freq,:).GaindBi);
        hold(app.RadiationPlot2D,'on');
        h_theta = polarplot(app.RadiationPlot2D, deg2rad(app.Antenna_Data(idx_theta & idx_freq,:).Phideg), app.Antenna_Data(idx_theta & idx_freq,:).GaindBi);
        hold(app.RadiationPlot2D,'off');
        title(app.RadiationPlot2D, sprintf('Radiation Pattern at %s MHz', app.PlotFrequencyMHzDropDown.Value));
        axis(app.RadiationPlot2D, 'tight');
        lgd = legend(app.RadiationPlot2D, [h_phi,h_theta], {"\Phi Cut", "\theta Cut"}, 'Location', 'best');
    
        improveAxesAppearance(app.GainvsFrequency2D, 'LineThickness', 2);
        improveAxesAppearance(app.ReturnLoss2D, 'LineThickness', 2);
        improveAxesAppearance(app.GainvsAngle2D, 'LineThickness', 2);
        h = findobj(app.RadiationPlot2D, 'Type', 'line');
        
        for i = 1:numel(h)
            h(i).LineWidth = 2;
        end
    catch ME
        app.displayError(ME);
    end
end
