function measureBoresightGain(app)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function measures the boresight gain of an antenna using a VNA 
    % over a specified frequency range. It computes the antenna gain and 
    % return loss, then saves the results to a file.
    %
    % INSTRUMENTS
    % Vector Network Analyzer: N5232B
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

    % Initialize variables from the application.
    startFrequency = app.VNAStartFrequency.Value * 1E6;
    endFrequency = app.VNAEndFrequency.Value * 1E6;
    sweepPoints = app.VNASweepPoints.Value;

    % Measure the S-parameters using the VNA over the specified 
    % frequency range with 2-port configuration.
    [SParameters_dB, SParameters_Phase, VNAFreqs] = measureSParameters(app.VNA, 2, startFrequency, endFrequency, sweepPoints);

    % Compute the antenna boresight gain using the measured S21 and 
    % the setup spacing.
    BoresightGain_dBi = measureAntennaGain(VNAFreqs, SParameters_dB{2}, app.setupSpacing);

    % Prepare the data for file saving.
    combinedData = [double(VNAFreqs / 1E6)',...
                    double(BoresightGain_dBi)',...
                    double(SParameters_dB{1})',...
                    double(SParameters_Phase{1})'
    ];
    combinedNames = {'Frequency (MHz)',... 
                     'Gain (dBi)',... 
                     'Return Loss (dB)',...
                     'Return Loss (deg)'
    };
    
    % Save the data to a file using the saveData function.
    saveData(combinedData, combinedNames);
end