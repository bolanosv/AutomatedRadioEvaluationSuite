% TODO: Convert script into function and call from the app to reset the
% slider. Use the InstrumentFactory.


% NOTE: Cycle the power on the device for a minute with the power disconnected
% before running the script.

SLIDER_IP   = "192.168.0.100";
SLIDER_PORT = 1206;
POS_TOL     = 0.1;   % cm — treat positions within this tolerance as "already at target"


try
    % The constructor connects and caches the mechanical limits. onCleanup
    % guarantees the socket is released on any exit path, including an error
    % thrown from inside moveTo().
    slider = EmCenterSlider(SLIDER_IP, SLIDER_PORT, 1, ...
        "PositionTolerance_cm", POS_TOL, "Verbose", true);
    cleanupObj = onCleanup(@() delete(slider));
    
    fprintf('Connected to: %s\n', strtrim(slider.idn()));
    
    % Soft limits
    slider.Transport.writeLine('AXIS1:NCR'); % Turn NCR mode on to enable soft limits
    fprintf('Lower Limit [cm]: %.2f\n', slider.LowerLimit_cm);
    fprintf('Upper Limit [cm]: %.2f\n', slider.UpperLimit_cm);
    if slider.LowerLimit_cm~=0 || slider.UpperLimit_cm()~=200 
        fprintf("\nIncorrect soft limits, resetting...\n")
        slider.setLimits(0,200);
        fprintf('Lower Limit [cm]: %.2f\n', slider.LowerLimit_cm);
        fprintf('Upper Limit [cm]: %.2f\n', slider.UpperLimit_cm);
    end
    
    
    % Restart and move back from the front limit
    slider.Transport.writeLine('AXIS1:CR'); % Turn CR mode on to disable soft limits
    slider.Transport.writeLine('AXIS1:S2') % Set the speed
    slider.Transport.writeLine('AXIS1:UP'); % Move backwards (down,CCW) or forward (up,CW)
    while str2double(slider.Transport.writeRead('AXIS1:DIR?')) ~= 0
        pause(0.5);
        fprintf('Current position: %.2f\n',slider.Transport.writeRead('AXIS1:CP?'));

        error = str2double(slider.Transport.writeRead('AXIS:ERR?'));
        if error > 0
            disp("error")
            disp(error) % TODO: Print error description from EMSlider object
        end
    end

    slider.Transport.writeLine('AXIS1:ST'); % STOP 

    sprintf("Homing...\n");
    slider.Transport.writeLine('AXIS1:NCR'); % Turn NCR mode on to enable soft limits
    slider.home()
catch
    slider.Transport.writeLine('AXIS1:ST'); % STOP 
    writeline(slider, 'AXIS1:NCR'); % Turn NCR mode on to enable soft limits
    slider.Transport.writeLine('AXIS1:S5') % Set the speed
end