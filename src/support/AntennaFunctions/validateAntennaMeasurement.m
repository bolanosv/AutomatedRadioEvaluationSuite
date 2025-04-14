function isValid = validateAntennaMeasurement(app)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function validates the configuration of antenna test setup 
    % settings based on the user's inputs.
    %
    % It checks for the following conditions:
    %   - Whether the start and end frequencies are set and different.
    %   - Whether the number of sweep points is set.
    %   - Whether the antenna physical size is specified.
    %   - Whether the turntable settings (speed, start angle, step angle, 
    %     end angle) are configured.
    %
    % If any of these conditions fail, the function will display 
    % appropriate messages and prompt the user to correct the 
    % configuration.
    %
    % INSTRUMENTS
    % EMCenter
    %
    % INPUT PARAMETERS
    %   app:       The application object containing the antenna setup 
    %              configuration and associated parameters.
    %
    % OUTPUT PARAMETERS
    %   isValid:   A boolean value indicating whether the antenna setup 
    %              configuration is valid (true) or not (false).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initialize variables.
    startFrequency = app.VNAStartFrequency.Value;
    endFrequency = app.VNAEndFrequency.Value;
    sweepPoints = app.VNASweepPoints.Value;
    antennaSize = app.AntennaPhysicalSize.Value;
    tableSpeed = app.TableSpeedSlider.Value;
    tableStartAngle = app.TableStartAngle.Value;
    tableStepAngle = app.TableStepAngle.Value;
    tableEndAngle = app.TableEndAngle.Value;

    %% Validation Checks
    % Check if start and end frequencies are set and different.
    if isempty(startFrequency) || isempty(endFrequency) || (startFrequency == endFrequency)
        uialert(app.UIFigure, 'Invalid frequency values. Start and end frequencies must be set and different.', 'Invalid Frequency Settings');
        isValid = false;
        return;
    end

    % Check if the number of sweep points is set.
    if isempty(sweepPoints)
        uialert(app.UIFigure, 'Number of sweep points is not set.', 'Invalid Sweep Points');
        isValid = false;
        return;
    end

    % Check if the antenna physical size is specified.
    if isempty(antennaSize)
        uialert(app.UIFigure, 'Antenna physical size is not set.', 'Invalid Antenna Size');
        isValid = false;
        return;
    end

    % Check if turntable settings are properly configured.
    if isempty(tableSpeed)
        uialert(app.UIFigure, 'Table speed cannot be empty.', 'Invalid Table Speed');
        isValid = false;
        return;
    elseif isempty(tableStartAngle)
        uialert(app.UIFigure, 'Table start angle cannot be empty.', 'Invalid Table Start Angle');
        isValid = false;
        return;
    elseif isempty(tableStepAngle)
        uialert(app.UIFigure, 'Table step angle cannot be empty.', 'Invalid Table Step Angle');
        isValid = false;
        return;
    elseif isempty(tableEndAngle)
        uialert(app.UIFigure, 'Table end angle cannot be empty.', 'Invalid Table End Angle');
        isValid = false;
        return;
    end

    % All validation checks passed.
    isValid = true;
end