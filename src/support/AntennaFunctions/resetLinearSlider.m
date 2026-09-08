clc; clear; close all;
% TODO: Convert script into function and call from the app to reset the
% slider. Use the InstrumentFactory.


% NOTE: Cycle the power on the device for a minute with the power disconnected
% before running the script.

% Connect to the device.
LinearSlider = tcpclient('192.168.0.100', 1206);
LinearSlider.ByteOrder = 'little-endian';

% Get identification from device.
response = writeread(LinearSlider, '*IDN?')

% Get the upper and lower mechanical limits.
LowerLimit = str2double(writeread(LinearSlider, 'AXIS1:LL?'))
UpperLimit = str2double(writeread(LinearSlider, 'AXIS1:UL?'))

% TODO: Check the limits in the slider match the settings in the app


% Restart and move back from the front limit
writeline(LinearSlider, 'AXIS1:CR'); % Turn CR mode on to disable soft limits
writeline(LinearSlider, 'AXIS1:S1') % Set the speed
writeline(LinearSlider, 'AXIS1:DN'); % Move backwards (down)
while str2double(writeread(LinearSlider, 'AXIS1:DIR?')) ~= 0
    pause(0.5);
    disp(str2double(writeread(LinearSlider, 'AXIS1:CP?')))
    
    error = str2double(writeread(LinearSlider, 'AXIS:ERR?'));
    if error > 0
        disp("error")
        disp(error) % TODO: Print error description from EMSlider object
    end
end
writeline(LinearSlider, 'AXIS1:ST'); % STOP 
writeline(LinearSlider, 'AXIS1:NCR'); % Turn NCR mode on to enable soft limits
writeline(LinearSlider, 'AXIS1:HOME')
while str2double(writeread(LinearSlider, 'AXIS1:HOME?')) ~= 1
    pause(0.5);
end
writeline(LinearSlider, 'AXIS1:S3') % Set the speed

% Delete and clear the connection to the device.
delete(LinearSlider);
clear LinearSlider;
