function antennaGain_dBi = measureAntennaGain(Frequency, sParameter_dB, Spacing)
    % This function calculates the gain of an antenna, assuming that both
    % the test antennas are the same. The code uses the Friis transmission 
    % equation to get the gain.

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

    % Calculate gain in dBi
    antennaGain_dBi = 10 * log10(antenna_gain);

    % Ensure the gain data is of type double
    antennaGain_dBi = double(antennaGain_dBi);
end
