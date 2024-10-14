
data = loadData('Antenna');
VNAFreqs = data.FrequencyHz(1:601)';
s21 = data.S21(1:601)';
s22 = data.S22(1:601)';
setupSpacing = 0.838;



BoresightGain_dBi = measureAntennaGain(VNAFreqs, s21, setupSpacing);   

combinedData = [double(VNAFreqs)', double(BoresightGain_dBi)', double(s21)', double(s22)'];
            combinedNames = {'Frequency (Hz)', 'Boresight Gain (dBi)', 'S21 (dB)', 'Return Loss (dB)'};

numRows = size(combinedData, 1);
disp(['Number of rows in combinedData: ', num2str(numRows)]);

saveData(combinedData, combinedNames);
