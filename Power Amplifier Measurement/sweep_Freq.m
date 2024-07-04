%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;

%% Variable Declarations
% Power Supply Unit Settings
V_DD = 17;                              % DC voltage supply                     
P_DC = zeros(size(input_PdBm));         % DC Power Array

% Signal Generator Settings
input_Freq = 2E9:1E9:3E9;               % Frequency range
input_PdBm = -20:2:10;                  % Input power (dBm) range
output_PdBm = zeros(size(input_PdBm));  % Output power (dBm)

% Signal Analayzer Settings
sweep_pts = 2000;                       % Number of sweep points  
ref_level = 20;                         % Reference level for trace window

%% Test Setup
% Adjust each instruments address based on their connection (LAN, GPIB,
% USB, etc.)

% Connect to the E4433B Signal Generator
Signal_Generator_Address = 'GPIB0::20::INSTR';
Signal_Generator = visadev(Signal_Generator_Address);
Signal_Generator.ByteOrder = 'little-endian';

% Connect to the CXA N9000B Signal Analyzer
Signal_Analyzer_Address = 'TCPIP0::192.168.3.70::hislip0::INSTR';
Signal_Analyzer = visadev(Signal_Analyzer_Address);
Signal_Analyzer.ByteOrder = 'little-endian';

% Connect to the E3631A DC Power Supply
Power_Supply_Address = 'GPIB1::5::INSTR';
Power_Supply = visadev(Power_Supply_Address);
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
InputParameters = {input_Freq,input_PdBm,output_PdBm,P_DC};
OutputParameters = measure_RFparameters(InputParameters{2}, InputParameters{3}, InputParameters{4});
peakValues = measure_RFpeaks(InputParameters{1},InputParameters{3},OutputParameters{1},OutputParameters{2},OutputParameters{3});

%% Plotting
% Plot Gain versus output power over the frequency sweep
figure(1)
hold('on'); 
for i = 1:size(output_PdBm, 1)
    plot(InputParameters{3}(i, :), OutputParameters{1}(i, :), 'DisplayName', formatFreq(input_Freq(i)));
end
hold('off');
title('Gain vs. Output Power for each frequency');
xlabel('Output Power (dBm)');
ylabel('Gain (dB)');
legend('show', 'Location', 'best');

% Plot peak Gain over the frequency sweep
figure(2)
plot(input_Freq, peakValues{2}, 'blue');
title('Peak Gain');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');

% Plot peak DE and peak PAE over the frequency sweep
figure(3)
hold('on');
plot(input_Freq, peakValues{3}, 'blue');
plot(input_Freq, peakValues{4}, 'red');
hold('off');
title('Peak DE and PAE');
xlabel('Frequency (Hz)');
ylabel('Efficiency (%)');
legend('DE', 'PAE', 'Location', 'best')

% Plot saturation power and compression points over the frequency sweep, if
% a compression point was not found, nothing is plotted.
figure(6)
plotHandles = {};
plotColors = {'black', 'red', 'blue'};
xData = {[], [], []};
yData = {[], [], []};
legendLabels = {'P_{sat}', 'P_{-1dB}', 'P_{-3dB}'};

hold('on');         
% Loop through data and collect non-zero points
for i = 1:size(output_PdBm, 1)
    if peakValues{1}(i) ~= 0
        xData{1} = [xData{1}, input_Freq(i)];
        yData{1} = [yData{1}, peakValues{1}(i)];
    end
    if peakValues{5}(i) ~= 0
        xData{2} = [xData{2}, input_Freq(i)];
        yData{2} = [yData{2}, peakValues{5}(i)];
    end
    if peakValues{6}(i) ~= 0
        xData{3} = [xData{3}, input_Freq(i)];
        yData{3} = [yData{3}, peakValues{6}(i)];
    end   
end

% Plot the data points and lines, store handles for the legend
for idx = 1:3
    if ~isempty(xData{idx})
        plotHandles{end+1} = plot(xData{idx}, yData{idx}, [plotColors{idx}, '-']);
        plot(xData{idx}, yData{idx}, plotColors{idx});
    end
end

ylabel('Output Power (dBm)');
xlabel('Frequency (Hz)');
title('Saturation Power and Compression Points');

if ~isempty(plotHandles)
    legend([plotHandles{:}], legendLabels(1:length(plotHandles)), 'Location', 'best');
end

hold('off');

%% Saving Data To Excel File
Filename = 'test';
saveToFile('sweep', InputParameters, OutputParameters, Filename);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%