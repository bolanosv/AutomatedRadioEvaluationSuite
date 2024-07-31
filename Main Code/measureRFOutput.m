function [output_PdBm,P_DC] = measureRFOutput(SignalGenerator,SpectrumAnalyzer,PowerSupply,input_PdBm)
    % This function measures the output RF power (dBm) and the DC 
    % power (W) of the power supply.

    % A 30 dB attenuator was used in the test setup, adjust as
    % needed
    attenuation = 30; 

    % Set the amplitude of the signal generator
    writeline(SignalGenerator, sprintf(':SOURce:POWer:LEVel:IMMediate:AMPLitude %g', input_PdBm));
    %pause(0.5);
    waitForInstrument(SignalGenerator);

    % Initiate the measurement process
    writeline(SpectrumAnalyzer, sprintf(':INITiate:CONTinuous %d', 0));
    writeline(SpectrumAnalyzer, ':INITiate:IMMediate');
    
    % Wait until the signal analyzer is ready
    writeline(SpectrumAnalyzer, '*WAI');

    % Fetch the trace data
    writeline(SpectrumAnalyzer, sprintf(':TRACe:DATA? %s', 'TRACe1'));
    %pause(0.5);
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