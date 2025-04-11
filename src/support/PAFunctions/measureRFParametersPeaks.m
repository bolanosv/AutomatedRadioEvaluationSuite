function peakValues = measureRFParametersPeaks(app)
    % This function calculates the peak values of several RF 
    % parameters (Gain, DE, PAE, Saturation Power, -1dB and -3dB 
    % compression points).
    numFreqs = length(app.PA_Frequencies);
    peakGain = zeros(numFreqs, 1);
    peak1dB  = zeros(numFreqs, 1);
    peak3dB  = zeros(numFreqs, 1);

    for i = 1:numFreqs
        % Get the peak Gain.
        peakGain(i) = max(app.PA_Gain(i, :));

        % Get the -1dB compression point.
        idx_1dB = find(app.PA_Gain(i, :) <= (peakGain(i) - 1), 1, 'first');
        if ~isempty(idx_1dB)
            peak1dB(i) = app.PA_RFOutputPower(i, idx_1dB);
        else
            peak1dB(i) = NaN;
        end

        % Get the -3dB compression point.
        idx_3dB = find(app.PA_Gain(i, :) <= (peakGain(i) - 3), 1, 'first');
        if ~isempty(idx_3dB)
            peak3dB(i) = app.PA_RFOutputPower(i, idx_3dB);
        else
            peak3dB(i) = NaN;
        end
    end    

    % Get the max output RF power per frequency.
    saturationPower = max(app.PA_RFOutputPower, [], 2);
    % Get the max drain efficiency per frequency.
    peakDE  = max(app.PA_DE, [], 2);
    % Get the max power-added efficiency per frequency.
    peakPAE = max(app.PA_PAE, [], 2);

    peakValues = {saturationPower, peakGain, peakDE, peakPAE, peak1dB', peak3dB'};
end
