function antennaGain_dBi = measureAntennaGain(Frequency, sParameter_dB, Spacing, RefGain, RefFreq)
    % This function calculates the gain of a test antenna in decibels relative 
    % to an isotropic radiator (dBi) based on the input frequency, S-parameters, 
    % and spacing between the antennas. If both antennas are identical the
    % function uses the two antenna method (Friis Transmission Equation),
    % else the DUT antenna gain is caluclated using the provided reference
    % antenna gain.
    %
    % Parameters
    %
    % Frequency:     A scalar or vector of frequency values (in Hz) at
    %                which the antenna gain is measured. 
    % sParameter_dB: S-parameters (in dB) representing the magnitude of the 
    %                power transfer between two antennas.
    % Spacing:       The distance (in meters) between the two antennas used
    %                in the test setup.
    % RefGain:       Refernce Antenna Gain
    % RefFreq:       Reference Antenna Frequency Range 
    %
    % Returns
    % antennaGain_dBi: Numerical vector containing the antenna gain (dBi)
    %                  of the test antenna, over all specified frequencies.

    if nargin < 4
        RefGain = [];
        RefFreq = [];
    end

    Frequency = Frequency(:);
    sParameter_dB = sParameter_dB(:);

    % Speed of light (m/s)  
    c = 3E8;  

    % Wavelength (m)
    lambda = c ./ Frequency; 

    % Calculate the Free Space Path Loss in (dB)
    FSPL_dB = 20*log10(lambda/(4*pi*Spacing));

    if ~isempty(RefGain)  % Non-identical Antenna Gain (dBi)
        RefFreq = RefFreq(:);
        RefGain = RefGain(:);
        interpolatedRefGain = interp1(RefFreq, RefGain, Frequency, 'linear', 'extrap');
        antennaGain_dBi = sParameter_dB - FSPL_dB - interpolatedRefGain;
    else                  % Identical Antennas Gain (dBi)
        antennaGain_dBi = (sParameter_dB-FSPL_dB)/2;
    end

    % Ensure the gain data is of type double
    antennaGain_dBi = double(antennaGain_dBi);
end
