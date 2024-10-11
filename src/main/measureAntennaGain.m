function antennaGain_dBi = measureAntennaGain(Frequency, sParameter_dB, Spacing, GainFile)
    % This function calculates the gain of a test antenna in decibels relative 
    % to an isotropic radiator (dBi) based on the input frequency, S-parameters, 
    % and spacing between the antennas. If both antennas are identical the
    % function uses the two antenna method (Friis Transmission Equation),
    % else the DUT antenna gain is caluclated using the provided reference
    % antenna gain.
    %
    % Parameters
    % Frequency:     A scalar or vector of frequency values (in Hz) at
    %                which the antenna gain is measured. 
    % sParameter_dB: S-parameters (in dB) representing the magnitude of the 
    %                power transfer between two antennas.
    % Spacing:       The distance (in meters) between the two antennas used
    %                in the test setup.
    % GainFile:      (Optional) Path to a CSV or Excel file containing 
    %                boresight gain data.
    %
    % Returns
    % antennaGain_dBi: Numerical vector containing the antenna gain (dBi)
    %                  of the test antenna, over all specified frequencies.

    if nargin < 4
        GainFile = [];
    elseif ~isempty(GainFile)
        [~, ~, ext] = fileparts(GainFile);
        if ~ismember(lower(ext), {'.csv', '.xls', '.xlsx'})
            error('GainFile must be a CSV or Excel file.');
        end
    end

    if length(Frequency) ~= length(sParameter_dB)
        error('Frequency and S-Parameter (dB) must have the same length.');
    end

    % Speed of light (m/s)  
    c = 3E8;  

    % Wavelength (m)
    lambda = c ./ Frequency; 

    % Convert S-parameter from dB to linear
    sParameter = 10.^(sParameter_dB / 20);   

    % Calculate the complex exponential factor
    friis_factor = (lambda ./ (4*pi*Spacing)).^2;

    if ~isempty(GainFile) % Non-identical Antennas
        referenceGain = loadData(GainFile);
        antenna_gain = sParameter^2 ./ (referenceGain .* friis_factor);
    else % Identical Antennas
        antenna_gain = sqrt(sParameter ./ friis_factor);  
    end

    % Calculate gain in dBi
    antennaGain_dBi = 10 * log10(antenna_gain);
    % Ensure the gain data is of type double
    antennaGain_dBi = double(antennaGain_dBi);
end
