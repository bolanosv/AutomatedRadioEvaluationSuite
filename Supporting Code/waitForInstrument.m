function waitForInstrument(Instrument)
    % This function waits until the specified instrument is ready
    % to continue operations.
    timeout = 5; % Adjust the timeout duration as needed (s)
    tic;
    while true
        status = sscanf(writeread(Instrument, '*OPC?'), '%d');
        if (status == 1 || toc > timeout)
            break;
        end
        pause(1); % Adjust the pause duration as needed (s)
    end
end