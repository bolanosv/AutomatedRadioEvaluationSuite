function measureBoresightGain(app, startFrequency, endFrequency, sweepPoints)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function measures the boresight gain of an antenna using a VNA 
    % over a specified frequency range. It computes the antenna gain and 
    % return loss, then saves the results to a file.
    %
    % INPUT PARAMETERS
    % app:             The application object containing VNA and test 
    %                  setup configuration.
    % startFrequency:  Start frequency of the sweep in (Hz).
    % endFrequency:    End frequency of the sweep in (Hz).
    % sweepPoints:     Number of sweep points between start and end 
    %                  frequency.
    %
    % OUTPUT PARAMETERS
    % None 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Measure the S-parameters using the VNA over the specified 
    % frequency range with 2-port configuration.
    [SParameters, VNAFreqs] = measureSParameters(app.VNA, 2, startFrequency, endFrequency, sweepPoints);

    % Compute the antenna boresight gain using the measured S21 and 
    % the setup spacing.
    BoresightGain_dBi = measureAntennaGain(VNAFreqs, SParameters{2}, app.setupSpacing);

    % Prepare the data for file saving.
    combinedData = [double(VNAFreqs)',...
                    double(BoresightGain_dBi)',...
                    double(SParameters{1})'];
    combinedNames = {'Frequency (Hz)',... 
                     'Gain (dBi)',... 
                     'Return Loss (dB)'};

    % Save the data to a file using the saveData function.
    saveData(combinedData, combinedNames, false);
end