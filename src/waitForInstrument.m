function waitForInstrument(Instrument)
    % This function communicates with an external lab instrument to check 
    % if it is ready for the next command. The function continuously 
    % queries the instrument's status until either the instrument indicates
    % it is ready, or a timeout occurs.
    %
    % Parameters
    % Instrument:   Handle representing the instrument object. The 
    %               instrument must support SCPI.
    
    timeout = 5; % Adjust the timeout duration as needed (seconds)
    tic; 
    while true
        % Query the instrument for its operation status
        status = sscanf(writeread(Instrument, '*OPC?'), '%d');
        % Check if the instrument is ready (status == 1) or if the timeout has been exceeded
        if (status == 1 || toc > timeout)
            break; 
        end 
        pause(1); % Pause for 1 second before checking again
    end
end
