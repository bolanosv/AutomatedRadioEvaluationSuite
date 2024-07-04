function RFParameters = measure_RFparameters(input_PdBm,output_PdBm,P_DC)
    % This function uses RF input power (dBm), RF output power 
    % (dBm), and DC power (W) to calculate gain (dB), drain 
    % efficiency (%), and power added efficiency (%).
    Gain = zeros(size(output_PdBm, 1, 2));

    % Calculate the Gain in dB
    for i = 1:size(output_PdBm, 1)
        for j = 1:size(output_PdBm, 2)
            Gain(i, j) = output_PdBm(i, j) - input_PdBm(j);
        end
    end

    % Convert the input and output power from dBm to W
    input_PW = dBm2W(input_PdBm);
    output_PW = dBm2W(output_PdBm);

    % Calculate the DE and PAE in %
    DE = (output_PW ./ P_DC) * 100;
    PAE = ((output_PW - input_PW) ./ P_DC) * 100;

    RFParameters = {Gain, DE, PAE};
end