%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;

%% Variable Declarations
% Power Supply Unit Settings
V_DD = 17;                             % DC voltage supply (V)
P_DC = zeros(size(input_PdBm));        % DC power (W)

% Signal Generator Settings
input_Freq = 2E9;                      % Frequency (Hz)
input_PdBm = -20:2:10;                 % Input power (dBm) 
output_PdBm = zeros(size(input_PdBm)); % Output power (dBm) 

% Signal Analayzer Settings
center_Freq = input_Freq;              % Center frequency (Hz)
span = input_Freq / 2;                 % Span for the trace (Hz)
sweep_pts = 2000;                      % Number of sweep points  
ref_level = 20;                        % Reference level for window (dB)

%% Test Setup
% Adjust each instruments address based on their connection (LAN, GPIB,
% USB, etc.)

% Connect to the E3631A DC Power Supply
Power_Supply_Address = 'GPIB1::5::INSTR';
Power_Supply = visadev(Power_Supply_Address);
Power_Supply.ByteOrder = 'little-endian';

% Connect to the E4433B Signal Generator
Signal_Generator_Address = 'GPIB0::20::INSTR';
Signal_Generator = visadev(Signal_Generator_Address);
Signal_Generator.ByteOrder = 'little-endian';

% Connect to the CXA N9000B Signal Analyzer
Signal_Analyzer_Address = 'TCPIP0::192.168.3.70::hislip0::INSTR';
Signal_Analyzer = visadev(Signal_Analyzer_Address);
Signal_Analyzer.ByteOrder = 'little-endian';

% Reset the power supply and set in remote mode
writeline(Power_Supply, '*RST'); 
writeline(Power_Supply, ':SYSTem:REMote');

% Set the chosen voltage and current limit, then turn on the supply
writeline(Power_Supply, sprintf(':APPLy %s,%g,%s', 'P25V', V_DD, 'MAXimum')); 
writeline(Power_Supply, sprintf(':OUTPut:STATe %d', 1)); 

% Reset the signal analyzer
writeline(Signal_Analyzer, '*RST'); 

% Set the center and span frequencies of the signal analyzer
writeline(Signal_Analyzer, sprintf(':SENSe:FREQuency:CENTer %g', center_Freq));
writeline(Signal_Analyzer, sprintf(':SENSe:FREQuency:SPAN %g', span));

% Set the number of sweep points
writeline(Signal_Analyzer, sprintf(':SENSe:SWEep:POINts %d', sweep_pts));

% Set the reference level of the screen
writeline(Signal_Analyzer, sprintf(':DISPlay:WINDow:TRACe:Y:SCALe:RLEVel %g', ref_level));

% Set the data format to be 64-bit real numbers
writeline(Signal_Analyzer, sprintf(':FORMat:TRACe:DATA %s,%d', 'REAL', 64));
writeline(Signal_Analyzer, sprintf(':FORMat:BORDer %s', 'SWAPped'));

% Reset the signal generator
writeline(Signal_Generator, '*RST');

% Set the frequency of the input signal
writeline(Signal_Generator, sprintf(':SOURce:FREQuency:CW %d', input_Freq));

% Turn on the signal generator 
writeline(Signal_Generator, sprintf(':OUTPut:STATe %d', 1));

%% Sweep Measurements
for i = 1:length(input_PdBm)
    [output_PdBm(i), P_DC(i)] = measure_outputPdBm(Signal_Generator, Signal_Analyzer, Power_Supply, input_PdBm(i));
end

% Turn off the power supply
writeline(Power_Supply, sprintf(':OUTPut:STATe %d', 0));
writeline(Power_Supply, '*RST'); 

% Turn off the signal generator 
writeline(Signal_Generator, sprintf(':OUTPut:STATe %d', 0));
writeline(Signal_Generator, sprintf(':SOURce:POWer:LEVel:IMMediate:AMPLitude %s', 'MIN'));

% Close the connection to the instruments
delete(Power_Supply);
clear Power_Supply;
delete(Signal_Analyzer);
clear Signal_Analyzer;
delete(Signal_Generator);
clear Signal_Generator;

%% Calculations
InputParameters = {input_Freq,input_PdBm,output_PdBm,P_DC};
OutputParameters = measure_RFparameters(InputParameters{2}, InputParameters{3}, InputParameters{4});

% Find the maximum gain, then the -1dB and -3dB compression
% points for a single run.
maxGain = max(OutputParameters{1});
[saturation_power, saturation_idx] = max(InputParameters{3});
idx_1dB = find(OutputParameters{1} <= (maxGain - 1), 1, 'first');
idx_3dB = find(OutputParameters{1} <= (maxGain - 3), 1, 'first');

%% Plotting
% Plot Input Power vs Output Power
figure(1)
plot(InputParameters{2}, InputParameters{3}, 'blue');
xlabel('Input Power (dBm)');
ylabel('Output Power (dBm)');
title('Output Power vs. Input Power');

% Plot Gain on the left y-axis
figure(2)
yyaxis('left');
h1 = plot(InputParameters{3}, OutputParameters{1}, 'black');
hold('on');

% Plot the -1dB and -3dB compression points
if ~isempty(idx_1dB)
    h4 = plot(InputParameters{3}(idx_1dB), OutputParameters{1}(idx_1dB), 'blueo', 'MarkerSize', 10);
end
if ~isempty(idx_3dB)
    h5 = plot(InputParameters{3}(idx_3dB), OutputParameters{1}(idx_3dB), 'redo', 'MarkerSize', 10);
end
if ~isempty(saturation_idx)
    h6 = plot(saturation_power, OutputParameters{1}(saturation_idx), 'greeno', 'MarkerSize', 10);
end
ylabel('Gain (dB)');

% Plot DE and PAE on the right y-axis
yyaxis('right');
h2 = plot(InputParameters{3}, OutputParameters{2}, 'blue-');
h3 = plot(InputParameters{3}, OutputParameters{3}, 'red--');
ylabel('Efficiency (%)');
hold('off');
xlabel('Output Power (dBm)');
title('Gain, DE, and PAE vs. Output Power');

legendEntries = {'Gain', 'DE', 'PAE'};
legendHandles = [h1, h2, h3];
if exist('h4', 'var')
    legendHandles(end+1) = h4; 
    legendEntries{end+1} = 'Gain_{-1dB}'; 
end
if exist('h5', 'var')
    legendHandles(end+1) = h5; 
    legendEntries{end+1} = 'Gain_{-3dB}'; 
end
if exist('h6', 'var')
    legendHandles(end+1) = h6; 
    legendEntries{end+1} = 'Saturation'; 
end
legend(legendHandles, legendEntries, 'Location', 'west');

%% Saving Data To Excel File
Filename = 'testsingle';
saveToFile('single', InputParameters, OutputParameters, Filename);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%