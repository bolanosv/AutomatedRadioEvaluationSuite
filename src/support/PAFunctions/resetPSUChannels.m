function resetPSUChannels(app)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function resets all power supply unit (PSU) channels to their
    % default state, which includes setting current and voltage to 0 and 
    % configuring each channel to 'Single' mode. It restores the default 
    % settings for all channels and refreshes the GUI elements to reflect 
    % these changes, ensuring the application returns to its initial 
    % configuration.
    %
    % INSTRUMENTS
    % DC Power Supplies A/B: E36233A / E336234A
    %
    % INPUT PARAMETERS
    % None
    %
    % OUTPUT PARAMETERS
    % None
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Loop through all the channel and set the default values.
    channels = fieldnames(app.ChannelNames);
    for i = 1:length(channels)
        app.ChannelNames.(channels{i}) = struct('Current', 0, 'Start', 0, 'Stop', 0, 'Step', 0, 'Mode', 'Single');
    end

    % To invalidate the channel once its reset.
    populatePSUChannels(app); 

    % Set all remaining GUI values and elements to their default 
    % state.
    app.SupplyCurrentValueField.Value = 0;
    app.SupplyVoltageStartValueField.Value = 0;
    app.SupplyVoltageStopValueField.Value = 0;
    app.SupplyVoltageStepValueField.Value = 0;
    app.SingleSweepSwitch.Value = 'Single';
    app.SupplyVoltageStopValueField.Visible = 'off';
    app.SupplyVoltageStepValueField.Visible = 'off';
end