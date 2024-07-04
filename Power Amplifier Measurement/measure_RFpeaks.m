function peakValues = measure_RFpeaks(input_Freq,output_PdBm,Gain,DE,PAE)
    % This function is used with the sweep type measurement, it
    % calculates the peak values of several RF paramters (Gain, DE,
    % PAE, Saturation Power, -1dB and -3dB compression points).
    saturation_PdBm = max(output_PdBm, [], 2);
    peak_Gain = max(Gain, [], 2);
    peak_DE = max(DE, [], 2);
    peak_PAE = max(PAE, [], 2);

    % Calculate -1dB and -3dB compression points
    peak_1dB = zeros(size(input_Freq, 1), 1);
    peak_3dB = zeros(size(input_Freq, 1), 1);

    for i = 1:size(input_Freq, 2)
        % Find the -1dB compression point
        idx_1dB = find(Gain(i, :) <= (peak_Gain(i) - 1), 1, 'first');
        if ~isempty(idx_1dB)
            peak_1dB(i) = output_PdBm(i, idx_1dB);
        else
            peak_1dB(i) = NaN;
        end
        % Find the -3dB compression point
        idx_3dB = find(Gain(i, :) <= (peak_Gain(i) - 3), 1, 'first');
        if ~isempty(idx_3dB)
            peak_3dB(i) = output_PdBm(i, idx_3dB);
        else
            peak_3dB(i) = NaN;
        end
    end

    peakValues = {saturation_PdBm, peak_Gain, peak_DE, peak_PAE, peak_1dB', peak_3dB'};
end