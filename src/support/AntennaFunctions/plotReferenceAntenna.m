function plotReferenceAntenna(app)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function plots the gain and return loss characteristics of 
    % the reference antenna over frequency. Used as a baseline for 
    % comparison with DUT measurements.
    %
    % INPUT PARAMETERS:
    %   app:  Application object containing the reference antenna data and 
    %         plot handles.
    %
    % The function performs the following actions:
    %   - Clears the existing Gain vs Frequency and Return Loss plots
    %   - Plots the reference antenna gain in (dBi) over frequency in (MHz)
    %   - Plots the return loss in (dB) over frequency in (MHz)
    %   - Enhances plot appearance using a standardized format
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Clear current plots.
    cla(app.GainvsFrequencyBoresightGain);
    cla(app.ReturnLossBoresightGain);

    % Plot the parameters onto the plots.
    plot(app.GainvsFrequencyBoresightGain, app.ReferenceGainFile.FrequencyMHz, app.ReferenceGainFile.GaindBi);
    plot(app.ReturnLossBoresightGain, app.ReferenceGainFile.FrequencyMHz, app.ReferenceGainFile.ReturnLossdB);

    % Improves the plot appeareance, line thickness can be modified.
    improveAxesAppearance(app.GainvsFrequencyBoresightGain, 'LineThickness', 2);
    improveAxesAppearance(app.ReturnLossBoresightGain, 'LineThickness', 2);
end