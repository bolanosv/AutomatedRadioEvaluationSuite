
data = loadData('Antenna');
VNAFreqs = data.FrequencyHz(1:601)';
s21 = data.S21(1:601)';
setupSpacing = 0.838;



BoresightGain_dBi = measureAntennaGain(VNAFreqs, s21, setupSpacing, );   

combinedData = [double(VNAFreqs/1E9)', double(BoresightGain_dBi)'];
combinedNames = {'Frequency (GHz)', 'Boresight Gain (dBi)'};

numRows = size(combinedData, 1);
disp(['Number of rows in combinedData: ', num2str(numRows)]);

saveData(combinedData, combinedNames);
