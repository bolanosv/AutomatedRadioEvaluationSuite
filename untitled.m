% try 
%     if isempty(LinearSlider)
%         LinearSlider = tcpclient('192.168.0.100', 1206);
%         LinearSlider.ByteOrder = 'little-endian';
%         LinearSliderCurrentPosition.Value = str2double(writeread(LinearSlider, 'AXIS1:CP?'));
%         AntennaCurrentSpacing.Value = 2 + offsetSpacing - LinearSliderCurrentPosition.Value/100;
%         AntennaCurrentSpacing.Enable = 'on';
%         LinearSliderCurrentPosition.Enable = 'on';
%         SpeedPresetDropDown.Enable = 'on';
%         MovetoPositionButton.Enable = 'on';
%         LinearSliderNewPosition.Enable = 'on';
%     end
% catch ME
%     % Display the error message and identifier
%     sprintf('Failed to connect to linear slider. Error: %s', ME.message, 'Error', 'Icon', 'warning');
%     fprintf('Error: %s\n', ME.message);
%     fprintf('Type of Error: %s\n', ME.identifier);
%     for k = 1:length(ME.stack)
%         fprintf('In file: %s\nFunction: %s\nLine: %d\n', ...
%             ME.stack(k).file, ME.stack(k).name, ME.stack(k).line);
%     end
% end

azimuthAngle = -90;
tableAngle = mod(azimuthAngle + 360, 360);
disp(tableAngle);