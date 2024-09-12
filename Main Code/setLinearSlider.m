function setLinearSlider(speed_preset, target_position)
    % Speed Preset: Takes integer [1,8] with 8 max speed and 1 min speed.
    % Target Position: Position to move linear slider to.

    % Connect to the device. 
    LinearSlider = tcpclient('192.168.0.100', 1206);
    LinearSlider.ByteOrder = 'little-endian';

    % Get identification from device.
    writeline(LinearSlider, '*IDN?');
    response = readline(LinearSlider);
    disp(response);

    % Get the upper and lower mechanical limits.
    LowerLimit = str2double(writeread(LinearSlider, 'AXIS1:LL?'));
    UpperLimit = str2double(writeread(LinearSlider, 'AXIS1:UL?'));

    % Get the current position of the device.
    currentPosition = str2double(writeread(LinearSlider, 'AXIS1:CP?'));

    % Set the speed of the device.
    writeline(LinearSlider, sprintf('AXIS1:S%d', speed_preset));

    % Go to the target position.
    if (target_position < LowerLimit) || (target_position > UpperLimit)
        fprintf('Target Position Outside of Device Bounds.')
    elseif (target_position == currentPosition)
        fprintf('Linear Slider Already at Target Position.')
    else
        writeline(LinearSlider, sprintf('AXIS1:SK %d', target_position));
        motion = writeread(LinearSlider, 'AXIS1:DIR?');
        while strcmp(motion, '+1') || strcmp(motion, '-1')
            motion = writeread(LinearSlider, 'AXIS1:DIR?');
        end
        fprintf('Linear Slider Moved to Target Position.')
    end

    % Delete and clear the connection to the device.
    delete(LinearSlider);
    clear LinearSlider;
end

% To manually stop the linear slider use the following
% writeline(LinearSlider, 'AXIS1:ST')


