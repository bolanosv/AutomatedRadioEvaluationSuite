function [output_PdBm,P_DC] = measure_RFoutput(Signal_Generator,Spectrum_Analyzer,Power_Supply,input_PdBm)
    % This function measures the output RF power (dBm) and the DC 
    % power (W) of the power supply.

    % A 30 dB attenuator was used as part of the test setup
    attenuation = 30; 

    % Set the amplitude of the signal generator
    writeline(Signal_Generator, sprintf(':SOURce:POWer:LEVel:IMMediate:AMPLitude %g', input_PdBm));

    % Wait until the signal generator is ready
    waitForInstrument(Signal_Generator);

    % Initiate the measurement process
    writeline(Spectrum_Analyzer, sprintf(':INITiate:CONTinuous %d', 0));
    writeline(Spectrum_Analyzer, ':INITiate:IMMediate');
    
    % Wait until the signal analyzer is ready
    waitForInstrument(Spectrum_Analyzer);

    % Fetch the trace data
    writeline(Spectrum_Analyzer, sprintf(':TRACe:DATA? %s', 'TRACe1'));
    trace_data = readbinblock(Spectrum_Analyzer, 'double');

    % Measure the maximum output power and account for attenuator 
    output_PdBm = max(trace_data) + attenuation;

    % Measure the voltage and current at the DC power supply
    V_DC = str2double(writeread(Power_Supply, sprintf(':MEASure:VOLTage:DC? %s', 'P25V'))); 
    I_DC = str2double(writeread(Power_Supply, sprintf(':MEASure:CURRent:DC? %s', 'P25V'))); 
    P_DC = V_DC * I_DC;

    % Clear the status register of the spectrum analyzer
    writeline(Spectrum_Analyzer, '*CLS');          
end