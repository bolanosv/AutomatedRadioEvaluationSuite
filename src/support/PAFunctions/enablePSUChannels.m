function enablePSUChannels(app, channels, state)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function enables or disables channels on two power supply units 
    % (PSU A and PSU B) based on the provided state. The channels are 
    % grouped by PSU and then enabled or disabled accordingly.
    % 
    % INSTRUMENTS
    %   DC Power Supplies A/B: E36233A / E336234A
    % 
    % INPUT PARAMETERS
    %   app:       The application object containing the power supplies and 
    %            the channel-to-device mapping.
    %   channels:  A cell array of channel names (e.g., {'CH1', 'CH2'}).
    %   state:     Channel state (1 for enable, 0 for disable).
    %
    % OUTPUT PARAMETERS
    %   None
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Group channels by power supply unit.
    psuAChannels = {};
    psuBChannels = {};

    for i = 1:length(channels)
        [deviceChannel, psuName] = strtok(app.ChannelToDeviceMap(channels{i}), ',');
        psuName = psuName(2:end);

        % Map channel name to channel index (CH1 -> @1).
        switch deviceChannel
            case 'CH1'
                channelIndex = '@1';
            case 'CH2'
                channelIndex = '@2';
        end
        
        if strcmp(psuName, 'PSUA')
            psuAChannels{end + 1} = channelIndex;
        else
            psuBChannels{end + 1} = channelIndex;
        end
    end

    % Enable channels on PSU A
    if ~isempty(psuAChannels)
        if isscalar(psuAChannels)
            % Single channel needs to be enabled.
            channelList = psuAChannels{1};
        else
            % Both channels need to be enabled.
            channelList = '@1,2'; 
        end
        writeline(app.PowerSupplyA, sprintf(':OUTPut:STATe %d,(%s)', state, channelList));
    end

    % Enable channels on PSU B
    if ~isempty(psuBChannels)
        if isscalar(psuBChannels)
            % Single channel needs to be enabled.
            channelList = psuBChannels{1}; 
        else
            % Both channels need to be enabled.
            channelList = '@1,2';
        end
        writeline(app.PowerSupplyB, sprintf(':OUTPut:STATe %d,(%s)', state, channelList));
    end
end