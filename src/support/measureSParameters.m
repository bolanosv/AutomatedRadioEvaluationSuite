function [sParameters,freqValues] = measureSParameters(VNA, numPorts, startFreq, endFreq, sweepPts)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function extracts the 2-port or 3-port S-Parameters in (dB) of 
    % a VNA laboratory instrument using SCPI. 
    %
    % INSTRUMENTS
    % Vector Network Analyzer: 
    %
    % INPUT PARAMETERS
    % VNA:       The instrument object representing the vector network 
    %            analyzer, used to measure the S-Parameters.
    % numPorts:  The number of ports (2 or 3) of the VNA to be used.
    % startFreq: Start frequency of the measurement range in (Hz).
    % endFreq:   End frequency of the measurement range in (Hz).
    % sweepPts:  Number of points for the VNA frequency sweep.
    %
    % OUTPUT PARAMETERS
    % sParameters: Measured S-Parameters in (dB).
    % freqValues:  Frequency values of the sweep.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Clear the error status register on the VNA.
    writeline(VNA, '*CLS');
    
    % Delete any existing measurements on the VNA.
    writeline(VNA, 'CALC:PAR:DEL:ALL');
    
    % Create a window on the VNA
    writeline(VNA, 'DISP:WIND1:STATE ON');

    if numPorts == 2
        sParameters = {'S11', 'S21', 'S22'};
    elseif numPorts == 3
        sParameters = {'S11', 'S22', 'S33', 'S21', 'S31', 'S32'};
    end
    
    % Create and display measurements for each S-Parameter.
    for i = 1:length(sParameters)
        writeline(VNA, sprintf('CALC1:PAR:DEF:EXT "Meas%d",%s', i, sParameters{i}));
        writeline(VNA, sprintf('DISP:WIND1:TRAC%d:FEED "Meas%d"', i, i));
    end
    
    % Set the start and stop frequencies, and the number of sweep points.
    writeline(VNA, sprintf('SENS1:FREQ:START %g', startFreq));
    writeline(VNA, sprintf('SENS1:FREQ:STOP %g', endFreq));
    writeline(VNA, sprintf('SENS1:SWE:POIN %d', sweepPts));
    
    % Set the data format for data collection.
    writeline(VNA, 'FORM:BORD SWAP');
    writeline(VNA, 'FORM:DATA REAL,64');
    
    % Perform a single continuos sweep and wait for the VNA to finish.
    writeline(VNA, 'SENS1:SWE:MODE CONT');
    writeline(VNA, '*WAI');
    
    % Read S-Parameters
    sParameters = cell(1, length(sParameters));
    for i = 1:length(sParameters)
        writeline(VNA, sprintf('CALC1:PAR:SEL "Meas%d"', i));
        writeline(VNA, 'CALC1:DATA? SDATA');
        data = readbinblock(VNA, 'double');
        complexData = data(1:2:end) + 1i*data(2:2:end);
        sParameters{i} = 20 * log10(abs(complexData));
        flush(VNA);
    end
    
    % Read frequency values of the sweep.
    writeline(VNA, ':SENSe:X:VALues?');
    freqValues = readbinblock(VNA, 'double');
end