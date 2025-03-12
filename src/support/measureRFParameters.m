function [Gain, DE, PAE] = measureRFParameters(inputRFPower, outputRFPower, DCPower)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function calculates the RF Gain, the Drain Efficiency (DE), and 
    % the Power Added Efficiency (PAE) based on the input/output RF power, 
    % and the DC power input.
    %
    % INPUT PARAMETERS
    % inputRFPowerdBm: Input RF power in (dBm).
    % outputRFPower:   Output RF power in (dBm).
    % DCPower:         DC power in (watts).
    %
    % OUTPUT PARAMETERS
    % Gain: RF gain in (dB).
    % DE:   Drain Efficiency as a percentage.
    % PAE:  Power Added Efficiency as a percentage.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Calculate Gain in dB.
    Gain = outputRFPower - inputRFPower;

    % Convert the input and output power from dBm to watts.
    inputRFPowerW = dBm2W(inputRFPower);
    outputRFPowerW = dBm2W(outputRFPower);

    % Calculate the DE and the PAE.
    DE = (outputRFPowerW ./ DCPower) * 100;
    PAE = ((outputRFPowerW - inputRFPowerW) ./ DCPower) * 100;
end

