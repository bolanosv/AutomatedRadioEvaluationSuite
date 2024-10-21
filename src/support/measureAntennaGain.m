function antennaGain_dBi = measureAntennaGain(Frequency, sParameter_dB, Spacing, RefGain, RefFreq)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function calculates the gain of a test antenna in decibels 
    % relative to an isotropic radiator (dBi) based on the input frequency,
    % S-parameters, and spacing between the antennas. If both antennas are
    % identical the function uses the two antenna method (Friis 
    % Transmission Equation), else the DUT antenna gain is calculated using
    % the provided reference antenna gain.
    %
    % PARAMETERS
    % Frequency:     A scalar or vector of frequency values (in Hz) at
    %                which the antenna gain is measured. 
    % sParameter_dB: S21 (dB) representing the magnitude of the 
    %                power transfer between two antennas.
    % Spacing:       The distance (m) between the two antennas used
    %                in the test setup.
    % RefGain:       Refernce Antenna Gain
    % RefFreq:       Reference Antenna Frequency Range 
    %
    % OUTPUTS
    % antennaGain_dBi: Numerical vector containing the antenna gain (dBi)
    %                  of the test antenna, over all specified frequencies.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if nargin < 4
        RefGain = [];
        RefFreq = [];
    end

    % Speed of light (m/s)  
    c = 3E8;  

    % Wavelength (m)
    lambda = c ./ Frequency; 

    % Free Space Path Loss (dB)
    FSPL_dB = 20*log10(lambda/(4*pi*Spacing));

    if ~isempty(RefGain)  % Non-identical Antenna Gain (dBi)
        %interpolatedRefGain = interp1(RefFreq, RefGain, Frequency, 'linear', 'extrap'); 
        %interpolatedRefGain = interp1(RefFreq, RefGain, Frequency, 'spline', 'extrap');
        interpolatedRefGain = interp1(RefFreq, RefGain, Frequency, 'pchip', 'extrap');
        antennaGain_dBi = sParameter_dB - FSPL_dB - interpolatedRefGain;
    else                  % Identical Antennas Gain (dBi)
        antennaGain_dBi = (sParameter_dB-FSPL_dB)/2;
    end

    antennaGain_dBi = double(antennaGain_dBi);
end
