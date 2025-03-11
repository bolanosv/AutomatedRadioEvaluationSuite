function [Gain, DE, PAE] = measureRFParameters(inputRFPowerdBm, outputRFPowerdBm, DCPowerW)
    % Calculate Gain in dB
    Gain = outputRFPowerdBm - inputRFPowerdBm;

    % Convert the input and output power from dBm to watts
    inputRFPowerW = dBm2W(inputRFPowerdBm);
    outputRFPowerW = dBm2W(outputRFPowerdBm);

    % Calculate the DE and PAE
    DE = (outputRFPowerW ./ DCPowerW) * 100;
    PAE = ((outputRFPowerW - inputRFPowerW) ./ DCPowerW) * 100;
end

