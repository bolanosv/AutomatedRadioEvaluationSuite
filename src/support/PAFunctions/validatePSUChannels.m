function isValid = validatePSUChannels(app)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function validates the configuration of power supply unit (PSU) 
    % channels based on the selected supply mode and the connected devices. 
    %
    % It checks for the following conditions:
    %   - Whether power supplies are connected.
    %   - Whether the selected supply mode is compatible with the number
    %     of connected power supplies.
    %   - Whether enough channels are configured for the selected mode.
    %   - Whether the number of configured channels exceeds the allowed 
    %     number for the selected mode.
    %
    % If any of these conditions fail, the function will display 
    % appropriate messages and prompt the user to correct the 
    % configuration.
    %
    % INSTRUMENTS
    % DC Power Supplies A/B: E36233A / E336234A
    %
    % INPUT PARAMETERS
    % app:       The application object containing the power supply 
    %            configurations, the current mode, and the list of filled 
    %            channels.
    %
    % OUTPUT PARAMETERS
    % isValid:   A boolean value indicating whether the PSU configuration 
    %            is valid (true) or not (false).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initialize variables.
    filledChannels = app.FilledPSUChannels;
    numfilledChannels = length(filledChannels);
    currentMode = app.PSUMode;

    % Standardize mode format so no MATLAB dropdown menu errors
    % occur with the current mode variable type.
    if isnumeric(currentMode)
        modes = {'Single Supply', 'Dual Supply', 'Quad Supply'};
        currentMode = modes{currentMode};
    end

    %% Validation Checks
    % Check if no power supplies are connected.
    if isempty(app.PowerSupplyA) && isempty(app.PowerSupplyB)
        uialert(app.UIFigure, 'No power supplies connected. Please connect at least one power supply before proceeding.', 'No Devices Connected');
        isValid = false;
        return;
    end

    % Check if quad supply mode is selected but less than two power 
    % supplies are connected.
    if strcmp(currentMode, 'Quad Supply') && (isempty(app.PowerSupplyA) || isempty(app.PowerSupplyB))
        uialert(app.UIFigure, 'Quad Supply mode requires both PSUA and PSUB to be connected.', 'Invalid Configuration');
        isValid = false;
        return;
    end

    % Check if no channels are configured, and prompt for the minimum 
    % channels required based on the selected mode.
    if isempty(filledChannels)
        switch currentMode
            case 'Single Supply'
                message = sprintf('Please configure voltage values for at least one channel before proceeding.');     
            case 'Dual Supply'
                message = sprintf('Please configure voltage values for at least two channels before proceeding.');      
            case 'Quad Supply'
                message = sprintf('Please configure voltage values for at least four channels before proceeding.');      
        end
        uialert(app.UIFigure, message, 'Insufficient Channels Configured');
        isValid = false;
        return;
    end

    % Determine the allowed number of channels for the selected mode.
    switch currentMode
        case 'Single Supply'
            maxChannels = 1;
        case 'Dual Supply'
            maxChannels = 2;
        case 'Quad Supply'
            maxChannels = 4;
        otherwise
            maxChannels = 0;
    end

    % Check if too many channels are selected for the chosen mode.
    if numfilledChannels > maxChannels
        message = sprintf(['Current mode %s allows %d channel(s).\n\n' ...
            'Configured channels: %s\n\n' ...
            'Would you like to:\n' ...
            '1. Clear all channel values\n' ...
            '2. Change PSU mode'], ...
            currentMode, maxChannels, strjoin(filledChannels, ', '));
        choice = uiconfirm(app.UIFigure, message, 'Channel Configuration', ...
            'Options', {'Clear All Channels', 'Change Mode', 'Cancel'});

        switch choice
            case 'Clear All Channels'
                % Reset all channel values.
                resetPSUChannels(app);
                isValid = false;
                return;
            case 'Change Mode'
                % Show menu with available modes based on the
                % number of filled channels.
                modes = {'Single Supply', 'Dual Supply', 'Quad Supply'};
                validModes = modes(numfilledChannels <= [1 2 4]);
                [idx, tf] = listdlg('ListString', validModes, ...
                    'SelectionMode', 'single', ...
                    'PromptString', 'Select new PSU mode:', ...
                    'ListSize', [200, 100]);
                if tf
                    app.PowerSupplyModeDropDown.Value = validModes{idx};
                    app.PSUChangeModeHandle(); 
                end
                isValid = false;
                return;
            otherwise % Cancel option.
                isValid = false;
                return;
        end
    end

    % All validation checks passed.
    isValid = true;
end
