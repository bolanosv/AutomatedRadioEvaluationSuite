function populatePSUChannels(app)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function checks the modes and configurations of power supply 
    % channels and determines which channels are "filled," meaning their 
    % user-defined parameters are complete and ready for use. The filled 
    % channels are stored in the app object for later processing or 
    % interaction with the power supply units.
    % 
    % INSTRUMENTS
    %   DC Power Supplies A/B: E36233A / E336234A
    % 
    % INPUT PARAMETERS
    %   app:       The application object containing the channel 
    %            configurations and the channel-to-device mapping.
    %
    % OUTPUT PARAMETERS
    %   None
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    filledChannels = {};
    channelNames = fieldnames(app.ChannelNames); 

    for channelName = channelNames'
        channel = app.ChannelNames.(channelName{1});
        
        % Based on the channel mode single/sweep determine if the
        % values entered by the user make it complete.
        if strcmp(channel.Mode, 'Single') && all([channel.Current, channel.Start] ~= 0)
            filledChannels{end + 1} = channelName{1};
        elseif strcmp(channel.Mode, 'Sweep') && all([channel.Current, channel.Start, channel.Stop, channel.Step] ~= 0)
            filledChannels{end + 1} = channelName{1};
        end
    end

    % Update the app's list of filled channels which holds the
    % channels that should be passed on to the PSU object.
    app.FilledPSUChannels = filledChannels;
end