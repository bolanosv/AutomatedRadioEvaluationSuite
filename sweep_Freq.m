%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc, clear

%% Variable Declarations
% Signal Generator 
input_Freq = 2E9:1E9:3E9;             % Frequency 
input_PdBm = -20:2:10;                  % Input power (dBm) array
output_PdBm = zeros(size(input_PdBm)); % Output power (dBm) array

% Power Supply Unit
V_DD = 17;                      % DC voltage supply                     
P_DC = zeros(size(input_PdBm)); % DC Power Array

% Signal Analayzer
sweep_pts = 2000; % Number of sweep points  
ref_level = 20;   % Reference level for trace window

%% Test Setup
% Connect to the E4433B Signal Generator
Signal_Generator = visadev('GPIB0::20::INSTR');
Signal_Generator.ByteOrder = 'little-endian';

% Connect to the CXA N9000B Signal Analyzer
Signal_Analyzer = visadev('TCPIP0::192.168.3.70::hislip0::INSTR');
Signal_Analyzer.ByteOrder = 'little-endian';

% Connect to the E3631A DC Power Supply
Power_Supply = visadev('GPIB1::5::INSTR');
Power_Supply.ByteOrder = 'little-endian';

% Reset the power supply and set in remote mode
writeline(Power_Supply, '*RST'); 
writeline(Power_Supply, ':SYSTem:REMote');

% Set the chosen voltage and current limit, then turn on the supply
writeline(Power_Supply, sprintf(':APPLy %s,%g,%s', 'P25V', V_DD, 'MAXimum')); 
writeline(Power_Supply, sprintf(':OUTPut:STATe %d', 1)); 

% Reset the signal analyzer
writeline(Signal_Analyzer, '*RST'); 

% Set the number of sweep points
writeline(Signal_Analyzer, sprintf(':SENSe:SWEep:POINts %d', sweep_pts));

% Set the reference level of the screen
writeline(Signal_Analyzer, sprintf(':DISPlay:WINDow:TRACe:Y:SCALe:RLEVel %g', ref_level));

% Set the data format to be 64-bit real numbers
writeline(Signal_Analyzer, sprintf(':FORMat:TRACe:DATA %s,%d', 'REAL', 64));
writeline(Signal_Analyzer, sprintf(':FORMat:BORDer %s', 'SWAPped'));

% Reset the signal generator
writeline(Signal_Generator, '*RST');

% Turn on the signal generator 
writeline(Signal_Generator, sprintf(':OUTPut:STATe %d', 1));

%% Sweep Measurements
for i = 1:length(input_Freq)
    % Set center frequency and span for trace
    center_Freq = input_Freq(i);     
    span = input_Freq(i) / 2;    

    % Set the center and span frequencies of the signal generator
    writeline(Signal_Generator, sprintf(':SOURce:FREQuency:CW %d', input_Freq(i)));

    % Set the center and span frequencies of the signal analyzer
    writeline(Signal_Analyzer, sprintf(':SENSe:FREQuency:CENTer %g', center_Freq));
    writeline(Signal_Analyzer, sprintf(':SENSe:FREQuency:SPAN %g', span));

    for j = 1:length(input_PdBm)
        % Performs a power sweep for each frequency
        [output_PdBm(i, j), P_DC(i, j)] = measure_outputPdBm(Signal_Generator, Signal_Analyzer, Power_Supply, input_PdBm(j));
    end
end

% Turn off the power supply
writeline(Power_Supply, sprintf(':OUTPut:STATe %d', 0));
writeline(Power_Supply, '*RST'); 

% Turn off the signal generator 
writeline(Signal_Generator, sprintf(':SOURce:POWer:LEVel:IMMediate:AMPLitude %s', 'MIN'));
writeline(Signal_Generator, sprintf(':OUTPut:STATe %d', 0));
writeline(Signal_Generator, sprintf(':OUTPut:MODulation:STATe %d', 0));

% Close the connection to the instruments
delete(Power_Supply);
clear Power_Supply;
delete(Signal_Analyzer);
clear Signal_Analyzer;
delete(Signal_Generator);
clear Signal_Generator;

%% Calculations
[Gain_dB, DE, PAE] = data_processing(input_PdBm, output_PdBm, P_DC);

% Calculate saturation output power
sat_PdBm = max(output_PdBm, [], 2);

% Calculate peak values
peak_Gain = max(Gain_dB, [], 2);
peak_DE = max(DE, [], 2);
peak_PAE = max(PAE, [], 2);

peak_1dB = zeros(length(input_Freq), 1);
peak_3dB = zeros(length(input_Freq), 1);

for i = 1:length(input_Freq)
    % Find the -1dB compression point
    idx_1dB = find(Gain_dB(i, :) <= (peak_Gain(i) - 1), 1);
    % Check if the -1dB point exists
    if isempty(idx_1dB)
        continue
    else
        peak_1dB(i) = output_PdBm(idx_1dB);
    end
    % Find the -3dB compression point
    idx_3dB = find(Gain_dB(i, :) <= (peak_Gain(i) - 3), 1);
    % Check if the -1dB point exists
    if isempty(idx_3dB)
        continue
    else
        peak_3dB(i) = output_PdBm(idx_3dB); 
    end 
end

%% Save to CSV file
% Save data of frequency sweep
input_Freq_rep = repmat(input_Freq, size(input_PdBm, 2), 1);
data = table(input_Freq_rep, input_PdBm', output_PdBm', Gain_dB', P_DC', DE', PAE', ...
    'VariableNames', {'Frequency (Hz)', 'Input Power (dBm)', 'Output Power (dBm)', 'DC Power (W)', 'Gain (dB)', 'Drain Efficiency', 'Power Added Efficiency'});

writetable(data, 'sweep_data.xlsx', 'Sheet', 1);

% Save peak values of frequency sweep
peak_data = table(input_Freq', peak_Gain, peak_DE, peak_PAE, peak_1dB, peak_3dB, sat_PdBm, ...
                   'VariableNames', {'Frequency (Hz)', 'Peak_Gain (dB)', 'Peak_DE', 'Peak_PAE', 'Peak_1dB (dBm)', 'Peak_3dB (dBm)', 'Saturation_Power (dBm)'});
writetable(peak_data, 'sweep_data.xlsx', 'Sheet', 2);

%% Plotting
figure(1) % Output power versus input power
plot(input_PdBm, output_PdBm, '-o');
xlabel('Input Power (dBm)');
ylabel('Output Power (dBm)');
title('Output Power vs. Input Power');

figure(2) % Gain versus output power over the frequency sweep
for i = 1:size(output_PdBm, 1)
    plot(output_PdBm(i, :), Gain_dB(i, :), '-o'); 
    hold on
end
hold off
title('Gain vs. Output Power for each frequency');
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')

figure(3) % Peak Gain over the frequency sweep
plot(input_Freq, peak_Gain)
title('Peak Gain')
ylabel('Gain (dB)')
xlabel('Frequency (Hz)')

figure(4) % Peak PAE over the frequency sweep
plot(input_Freq, peak_DE)
title('Peak DE')
ylabel('DE')
xlabel('Frequency (Hz)')

figure(5) % Peak PAE over the frequency sweep
plot(input_Freq, peak_PAE)
title('Peak PAE')
ylabel('PAE')
xlabel('Frequency (Hz)')

figure(6) % Compression points and saturation power over the frequency sweep
plot(input_Freq, sat_PdBm, 'k')
hold on
plot(input_Freq, peak_1dB)
plot(input_Freq, peak_3dB)
ylabel('Input Power (dBm)')
xlabel('Frequency (Hz)')
title('-1dB and -3dB Compression Points')
legend('P_{-1dB}', 'P_{-3dB}', 'P_{sat}')

save('sweep_Freq_workspace.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%