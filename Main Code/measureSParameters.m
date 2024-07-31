function [sData,freqValues] = measureSParameters(VNA, numPorts, startFreq, endFreq)
    % This function measures the S-Parameters of a 2-port or 3-port
    % system. The system assumes the antennas are identical so some
    % S-Parameters are not caluclated.

    % 2-Port sParameters = {'S11', 'S21', 'S22'};
    % 2-Port Antenna Gain -> S21
    % 3-Port sParameters = {'S11', 'S22', 'S33', 'S21', 'S31', 'S32'};
    % 3-Port Antenna Gain: Horizontal Polarization -> S21 
    %                      Vertical Polarization   -> S31
    sweepPts = 601;
    
    % Delete all existing measurements
    writeline(VNA, 'CALC:PAR:DEL:ALL');
    
    % Create a window on the PNA
    writeline(VNA, 'DISP:WIND1:STATE ON');

    if numPorts == 2
        sParameters = {'S11', 'S21', 'S22'};
    elseif numPorts == 3
        sParameters = {'S11', 'S22', 'S33', 'S21', 'S31', 'S32'};
    end
    
    % Create and display measurements for S-Parameters
    for i = 1:length(sParameters)
        writeline(VNA, sprintf('CALC1:PAR:DEF:EXT "Meas%d",%s', i, sParameters{i}));
        writeline(VNA, sprintf('DISP:WIND1:TRAC%d:FEED "Meas%d"', i, i));
    end
    
    % Set the frequency range and number of points
    writeline(VNA, sprintf('SENS1:FREQ:START %g', startFreq));
    writeline(VNA, sprintf('SENS1:FREQ:STOP %g', endFreq));
    writeline(VNA, sprintf('SENS1:SWE:POIN %d', sweepPts));
    
    % Set the data format
    writeline(VNA, 'FORM:BORD SWAP');
    writeline(VNA, 'FORM:DATA REAL,64');
    
    % Perform a single continuos sweep
    writeline(VNA, 'SENS1:SWE:MODE CONT');
    writeline(VNA, '*WAI');
    
    % Read S-Parameters
    sData = cell(1, length(sParameters));
    for i = 1:length(sParameters)
        writeline(VNA, sprintf('CALC1:PAR:SEL "Meas%d"', i));
        writeline(VNA, 'CALC1:DATA? SDATA');
        data = readbinblock(VNA, 'double');
        complexData = data(1:2:end) + 1i*data(2:2:end);
        sData{i} = 20 * log10(abs(complexData));
        flush(VNA);
    end
    
    % Read frequency values
    writeline(VNA, ':SENSe:X:VALues?');
    freqValues = readbinblock(VNA, 'double');
end