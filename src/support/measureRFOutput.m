function [output_PdBm,P_DC] = measureRFOutput(SignalGenerator,SpectrumAnalyzer,PowerSupply,input_PdBm)
    % This function controls a power supply, a signal generator, and a 
    % spectrum analyzer. It measures the RF output power in dBm and the DC 
    % power in watts from the PSU. The function manually accounts for any
    % attenuation in the setup. All the instruments must support SCPI.
    %
    % Parameters
    % SignalGenerator:  The instrument object representing the signal 
    %                   generator, used to produce the RF signal.
    % SpectrumAnalyzer: The instrument object representing the spectrum 
    %                   analyzer, used to measure the RF output power.
    % PowerSupply:      The instrument object representing the power 
    %                   supply, used to measure the DC power.
    % input_PdBm:       A numerical value specifying the input RF power (dBm) 
    %                   for the signal generator.
    %
    % Returns
    % output_PdBm:      A numerical value representing the measured output 
    %                   RF power (dBm), accounting for attenuation.
    % P_DC:             A numerical value representing the measured DC 
    %                   power (W) from the power supply.
    %
    % Note
    % This function assumes a fixed attenuation of 30 dB in the measurement 
    % setup. Adjust the attenuation value if a different value is used.
    attenuation = 30; 

    % Set the amplitude of the signal generator
    writeline(SignalGenerator, sprintf(':SOURce:POWer:LEVel:IMMediate:AMPLitude %g', input_PdBm));
    waitForInstrument(SignalGenerator);

    % Initiate the measurement process
    writeline(SpectrumAnalyzer, sprintf(':INITiate:CONTinuous %d', 0));
    writeline(SpectrumAnalyzer, ':INITiate:IMMediate');
    
    % Wait until the signal analyzer is ready
    writeline(SpectrumAnalyzer, '*WAI');

    % Fetch the trace data
    writeline(SpectrumAnalyzer, sprintf(':TRACe:DATA? %s', 'TRACe1'));
    trace_data = readbinblock(SpectrumAnalyzer, 'double');

    % Measure the maximum output power and account for attenuator 
    output_PdBm = max(trace_data) + attenuation;

    % Measure the voltage and current at the DC power supply
    V_DC = str2double(writeread(PowerSupply, sprintf(':MEASure:VOLTage:DC? %s', 'P25V'))); 
    I_DC = str2double(writeread(PowerSupply, sprintf(':MEASure:CURRent:DC? %s', 'P25V'))); 
    P_DC = V_DC * I_DC;

    % Clear the status register of the spectrum analyzer
    writeline(SpectrumAnalyzer, '*CLS');          
end