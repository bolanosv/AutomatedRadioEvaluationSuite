function plotReferenceAntenna(app)
%PLOTREFERENCEGAIN Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    app
end

arguments (Output)
end
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