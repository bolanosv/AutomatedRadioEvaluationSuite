function antennaGain = measureAntennaGain(TestFreq, sParameter, Spacing, RefGain, RefFreq)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function calculates the gain of a test antenna in decibels 
    % relative to an isotropic radiator (dBi) based on the input frequency,
    % S-parameters, and spacing between the antennas. The function offers 
    % two ways of caluclating antenna gain. If both test antennas are 
    % identical the function uses the Two-Antenna method (Friss Equation), 
    % else the Comparison Antenna Method is used, using the provided
    % reference gain and frequency.
    %
    % PARAMETERS
    % TestFreq:    A scalar or vector of frequency values (in Hz) at which
    %              the antenna gain is measured. 
    % sParameter:  A scalar or vector of S21 (dB) values representing the 
    %              magnitude of power transfer between two antennas.
    % Spacing:     A scalar, the distance (m) between the two antennas 
    %              being tested.
    % RefGain:     A scalar or vector containing the refernce antenna gain
    % RefFreq:     A scalar or vector containing the reference frequencies 
    %
    % RETURNS
    % antennaGain: Vector containing the antenna gain in (dBi) of the test 
    %              antenna.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if nargin < 4
        RefGain = [];
        RefFreq = [];
    end

    % Speed of light (m/s)  
    c = 3E8;  

    % Wavelength (m)
    lambda = c ./ TestFreq; 

    % Free Space Path Loss (dB)
    FSPL_dB = 20*log10(lambda/(4*pi*Spacing));

    if ~isempty(RefGain)  % Non-identical Antenna Gain (dBi) 
        interpolatedRefGain = interp1(RefFreq, RefGain, TestFreq, 'spline');
        antennaGain = sParameter - FSPL_dB - interpolatedRefGain;
    else                  % Identical Antennas Gain (dBi)
        antennaGain = (sParameter-FSPL_dB)/2;
    end

    antennaGain = double(antennaGain);
end
