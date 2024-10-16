function [Gain,DE,PAE] = measureRFParameters(input_PdBm,output_PdBm,P_DC)
    % This function computes the gain (in dB), drain efficiency (DE), and 
    % power-added efficiency (PAE) based on the RF input power, RF output 
    % power, and DC power supplied to the RF device.
    %
    % Parameters
    %   input_PdBm:  A numeric vector or matrix containing the RF input 
    %                power values (in dBm) for each measurement.
    %   output_PdBm: A numeric vector or matrix containing the RF output
    %                power values (in dBm) for each measurement.
    %   P_DC:        A numeric value representing the DC power (W) supplied 
    %                to the amplifier.
    %
    % Returns:
    %   Gain: A numeric matrix containing the calculated gain (in dB) for 
    %         each measurement point.
    %   DE:   A numeric matrix containing the calculated drain efficiency 
    %         (in percentage) for each measurement point.
    %   PAE:  A numeric matrix containing the calculated power-added efficiency 
    %         (in percentage) for each measurement point.

    Gain = zeros(size(output_PdBm, 1, 2));
    for i = 1:size(output_PdBm, 1)
        for j = 1:size(output_PdBm, 2)
            Gain(i, j) = output_PdBm(i, j) - input_PdBm(j);
        end
    end

    % Convert the input and output power from dBm to W
    input_PW = dBm2W(input_PdBm);
    output_PW = dBm2W(output_PdBm);

    % Calculate the DE and PAE
    DE = (output_PW ./ P_DC) * 100;
    PAE = ((output_PW - input_PW) ./ P_DC) * 100;
end
