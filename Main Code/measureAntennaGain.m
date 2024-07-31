function antennaGain_dB = measureAntennaGain(Frequency, sParameter_dB, Spacing)
    % Speed of light (m/s)
    c = 3E8;                 
    % Wavelength (m)
    lambda = c ./ Frequency; 

    % Convert S-parameter from dB to linear
    sParameter = 10.^(sParameter_dB / 20);    
    % Calculate the complex exponential factor
    friis_factor = (lambda ./ (4*pi*Spacing)).^2;
    % Calculate gain in linear 
    antenna_gain = sqrt(sParameter ./ friis_factor);    
    % Calculate gain in dB
    antennaGain_dB = 10 * log10(antenna_gain);   
    % Ensure the gain data is of type double
    antennaGain_dB = double(antennaGain_dB);
end
