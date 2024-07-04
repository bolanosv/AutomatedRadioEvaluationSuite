function saveToFile(measurementType,InputParameters,OutputParameters,Filename)
    % This function saves the acquired data into an Excel file. If
    % the measurement type was sweep, then also save the peak
    % values of each run into the second sheet

    % Remove existing extension, if any, and add .xlsx extension.
    % Save to 'Results' folder, within current workspace.
    [~, name, ~] = fileparts(Filename);
    folderName = 'Results';
    if ~exist(folderName, 'dir')
        mkdir(folderName);
    end
    Filename = fullfile(folderName, [name, '.xlsx']);

    measurementTypeColumn = repmat({measurementType}, size(InputParameters{2}, 2), 1);
    input_Freq_rep = repmat(InputParameters{1}, size(InputParameters{2}, 2), 1);
    data = table(measurementTypeColumn, input_Freq_rep, InputParameters{2}', InputParameters{3}', OutputParameters{1}', InputParameters{4}', OutputParameters{2}', OutputParameters{3}', ...
        'VariableNames', {'Measurement Type', 'Frequency (Hz)', 'Input Power (dBm)', 'Output Power (dBm)', 'Gain (dB)', 'DC Power (W)', 'Drain Efficiency', 'Power Added Efficiency'});
    writetable(data, Filename, 'Sheet', 1);
    
    if strcmp(measurementType, 'sweep')
        peakValues = measure_RFpeaks(InputParameters{1},InputParameters{3},OutputParameters{1},OutputParameters{2},OutputParameters{3});
        peak_data = table(InputParameters{1}', peakValues{1}, peakValues{2}, peakValues{3}, peakValues{4}, peakValues{5}, peakValues{6}, ...
             'VariableNames', {'Frequency (Hz)','Saturation_Power (dBm)', 'Peak_Gain (dB)', 'Peak_DE', 'Peak_PAE', 'Peak_1dB (dBm)', 'Peak_3dB (dBm)'});
        writetable(peak_data, Filename, 'Sheet', 2);
    end
end  