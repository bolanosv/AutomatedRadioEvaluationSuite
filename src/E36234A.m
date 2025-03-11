clc;
clear;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PSUAddress = 'TCPIP0::192.168.2.16::5025::SOCKET';

% Establish Instrument Connection
PSU = visadev(PSUAddress);
PSU.ByteOrder = 'little-endian';

% Get Instrument Identification
idn = writeread(PSU, '*IDN?');
disp(['IDN: ' idn]);

% Reset Instrument and Clear Status Register
writeline(PSU, '*RST');
writeline(PSU, '*CLS');

status = sscanf(writeread(Instrument, '*OPC?'), '%d');

return;

% SET VOLTAGE AND CURRENT TO ONE PORT
channel = 'CH1'; % or CH2
voltage = 'MAXimum'; % MAXimum = 61.8 V, DEFAULT=MINimum = 0 V
current = 'MAXimum'; % MAXimum = 10.3 A, DEFAULT=MINimum = 0 A
writeline(PSU, sprintf(':APPLy %s,%s,%s', channel, voltage, current));
writeline(PSU, sprintf(':APPLy %s,%d,%d', channel, voltage, current)); % if integer

% ENABLE ONE PORT OR TWO PORTS
state = true;
channellist = '@1'; % or @1 or @2 or (@1,2)
writeline(PSU, sprintf(':OUTPut:STATe %d,(%s)', state, channellist));


% ENABLE PARALLEL MODE - doubles the current across CH1 to +60V,+20A.
% pair = 'PARallel';
% writeline(PSU, sprintf(':OUTPut:PAIR %s', pair));

% ENABLE SERIES MODE - doubles the voltage across CH1 to +120V, +10A.
% pair = 'SERies';
% writeline(PSU, sprintf(':OUTPut:PAIR %s', pair));


% MEASURE DC VOLTAGE AND CURRENT OF ONE PORT
channel2 = 'CH1'; % or CH2
DC_V = str2double(writeread(PSU, sprintf(':MEASure:SCALar:VOLTage:DC? %s', channel2)));
DC_I = str2double(writeread(PSU, sprintf(':MEASure:SCALar:CURRent:DC? %s', channel2)));

disp(DC_V);
disp(DC_I);


delete(PSU);
clear PSU;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%