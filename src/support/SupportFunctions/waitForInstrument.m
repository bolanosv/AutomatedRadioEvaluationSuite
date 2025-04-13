function waitForInstrument(app, Instrument)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function waits for an instrument to complete its operation 
    % before proceeding. It continuously queries the instrument's operation
    % status and checks if it is ready, or if a specified timeout duration
    % has passed. If the instrument is not ready within the timeout 
    % period, the function will exit.
    %
    % INPUT PARAMETERS
    % app:         The application object, which contains settings like 
    %              the measurement delay value.
    % Instrument:  The instrument object to query for its operation status.
    %
    % OUTPUT PARAMETERS
    % None
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Adjust the timeout duration as needed (seconds).
    timeout = 15; 
    tic; 
    while true
        % Query the instrument for its operation status.
        status = sscanf(writeread(Instrument, '*OPC?'), '%d');
        % Check if the instrument is ready (status == 1) or if the 
        % timeout has been exceeded.
        if (status == 1 || toc > timeout)
            break; 
        end 
        % Pause the execution of the function for a duration specified by 
        % timeout value stored in the application (default 0.1 seconds).
        pause(app.MeasurementDelayValueField.Value); 
    end
end