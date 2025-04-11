function setLinearSlider(speedPreset, targetPosition)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function sets the speed preset of the linear slider, and moves
    % it to the target position specified by the user.
    %
    % INPUT PARAMETERS
    % speedPreset:    Takes integers [1,8] with 8 the maximum speed and 1 
    %                 the minimum speed
    % targetPosition: Position to move linear slider into.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Add button to home slider following commands:
    % if writeread(LinearSlider, 'AXIS1:ZERO?') == 0 % Query if axis has been homed 
    %   writeread(LinearSlider, 'AXIS1:HOME') % Seek slider home sensor
    %   writeread(LinearSlider, 'AXIS1:SCAN') % Toggle Scan Mode - move axis up and down between the soft limits
    % end

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
    writeline(LinearSlider, sprintf('AXIS1:S%d', speedPreset));

    % Go to the target position.
    if (targetPosition < LowerLimit) || (targetPosition > UpperLimit)
        fprintf('Target Position Outside of Device Bounds.')
    elseif (targetPosition == currentPosition)
        fprintf('Linear Slider Already at Target Position.')
    else
        writeline(LinearSlider, sprintf('AXIS1:SK %d', targetPosition));
        motion = writeread(LinearSlider, 'AXIS1:DIR?');
        while strcmp(motion, '+1') || strcmp(motion, '-1')
            motion = writeread(LinearSlider, 'AXIS1:DIR?');
            cp = str2double(writeread(LinearSlider, 'AXIS1:CP?'));
            disp(cp);
        end
        fprintf('Linear Slider Moved to Target Position.')
    end

    % To manually stop the linear slider use the following
    % writeline(LinearSlider, 'AXIS1:STOP')

    % Delete and clear the connection to the device.
    delete(LinearSlider);
    clear LinearSlider;
end


