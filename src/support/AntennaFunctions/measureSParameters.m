function [sParameters_dB, sParameters_Phase, freqValues] = measureSParameters(VNA)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function extracts the 2-port S-Parameters magnitude in (dB)
    % and phase in (degrees) using a VNA laboratory instrument using SCPI. 
    %
    % INSTRUMENTS
    %   Vector Network Analyzer: PNA-L N5232B
    %
    % INPUT PARAMETERS
    %   VNA:         The instrument object representing the vector network 
    %                analyzer, used to measure the S-Parameters.
    %
    % OUTPUT PARAMETERS
    %   sParameters_dB:     Magnitude of S-Parameters in (dB).
    %   sParameters_Phase:  Phase of S-Parameters in (deg).
    %   freqValues:         Frequency values of the sweep.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Clear any pending reads, then clear the status register on the VNA.
    flush(VNA);
    writeline(VNA, '*CLS');

    % Create the 2-Port measurement labels.
    measLabels = {'S11', 'S21', 'S22'};
    
    % Perform a single continuos sweep and wait for the VNA to finish.
    writeline(VNA, 'SENS1:SWE:MODE SING');
    writeline(VNA, '*WAI');
    
    % Read S-Parameters.
    sParameters_dB = cell(1, length(measLabels));
    sParameters_Phase = cell(1, length(measLabels));
    for i = 1:length(measLabels)
        % Request the data from the VNA.
        writeline(VNA, sprintf('CALC1:PAR:SEL "Meas%d"', i));
        writeline(VNA, 'CALC1:DATA? SDATA');

        % Extract and process the data from the VNA.
        data = readbinblock(VNA, 'double');
        complexData = data(1:2:end) + 1i*data(2:2:end);
        sParameters_dB{i} = 20 * log10(abs(complexData));
        sParameters_Phase{i} = rad2deg(angle(complexData));

        % Clean up before the next data read.
        flush(VNA);
    end
    
    % Read frequency values of the sweep.
    writeline(VNA, ':SENSe:X:VALues?');
    freqValues = readbinblock(VNA, 'double');
end