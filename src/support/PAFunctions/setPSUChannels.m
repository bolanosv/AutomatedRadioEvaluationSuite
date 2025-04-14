function setPSUChannels(app, deviceChannel, voltage, current)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function sets the voltage and current for a specified channel 
    % on a power supply unit (PSU). It selects the appropriate PSU based 
    % on the provided channel, and then applies the given voltage and 
    % current values to that channel.
    %
    % INSTRUMENTS
    % DC Power Supplies A/B: E36233A / E336234A
    %
    % INPUT PARAMETERS
    % app:           The application object containing the power supply 
    %                configurations and channel-to-device mapping.
    % deviceChannel: The name of the channel (e.g., 'CH1', 'CH2').
    % voltage:       The voltage to set for the specified channel, given 
    %                as a numeric value or a string.
    % current:       The current to set for the specified channel, given 
    %                as a numeric value or a string.
    %
    % OUTPUT PARAMETERS
    % None
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Get the correct PSU object and channel number.
    [physicalChannel, psuName] = strtok(app.ChannelToDeviceMap(deviceChannel), ',');
    psuName = psuName(2:end);  

    % Select the correct PSU object
    if strcmp(psuName, 'PSUA')
        PSU = app.PowerSupplyA;
    else
        PSU = app.PowerSupplyB;
    end

    % Handle string or numeric values for parameters.
    if isnumeric(voltage)
        voltageStr = num2str(voltage);
    else
        voltageStr = voltage;
    end
    if isnumeric(current)
        currentStr = num2str(current);
    else
        currentStr = current;
    end
    
    % Apply voltage and current values to the PSU channel.
    writeline(PSU, sprintf(':APPLy %s,%s,%s', physicalChannel, voltageStr, currentStr));
end