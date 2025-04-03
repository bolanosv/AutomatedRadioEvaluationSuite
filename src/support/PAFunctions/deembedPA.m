function [inCal,outCal] = deembedPA(app, testfreq, RFInputPower)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function de-embeds PA measurements by removing the effects of 
    % passive and active devices. It generates calibration factors in dB 
    % to correct the PA input and output RF power.
    %
    % INPUT PARAMETERS
    % app:          The application object containing calibration settings 
    %               and attenuation values.
    % freq:         Measurement frequency [Hz].
    % RFInputPower: RF input power [dBm].
    %
    % OUTPUT PARAMETERS
    % inCal:    Input attenuation calibration factor [dB].
    %           Subtract this from the input RF power to obtain the 
    %           corrected PA input power.
    % outCal:   Output attenuation calibration factor [dB].
    %           Add this to the measured output power to get the PA 
    %           output power.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    calMode = app.CalibrationMode;

    switch calMode
        case 'None'
            % Calibration factors are 0

            inCal = 0;
            outCal = 0;
        case 'Fixed Attenuation'
            % Calibration factors are the fixed attenuation in dB

            inCal = app.InputAttenuationValueField.Value;
            outCal = app.OutputAttenuationValueField.Value;
        case 'Small Signal'
            % Calibration factors add the fixed attenuation and the
            % interpolated S parameters from the given filename
            
            % Load S parameters for input and output deembeding
            SnP_in = sparameters(app.InputSpFile);
            SnP_out = sparameters(app.OutputSpFile);
            
            % Interpolate the attenuation at the measurement frequency
            Att_in = -interp1(SnP_in.Frequencies, A2dB(squeeze(abs(SnP_in.Parameters(2,1,:)))), testfreq, 'spline');
            Att_out = -interp1(SnP_out.Frequencies, A2dB(squeeze(abs(SnP_out.Parameters(2,1,:)))), testfreq, 'spline');
    
            % Add the attenuations
            inCal = app.InputAttenuationValueField.Value + Att_in;
            outCal = app.OutputAttenuationValueField.Value + Att_out;
        case 'Small + Large Signal'
            % Adds the fixed attenuation, S parameters, and driver response

            % Load S parameters for input and output deembeding
            SnP_in = sparameters(app.InputSpFile);
            SnP_out = sparameters(app.OutputSpFile);
    
            % Interpolate the attenuation at the measurement frequency
            Att_in = -interp1(SnP_in.Frequencies, A2dB(squeeze(abs(SnP_in.Parameters(2,1,:)))), testfreq, 'spline');
            Att_out = -interp1(SnP_out.Frequencies, A2dB(squeeze(abs(SnP_out.Parameters(2,1,:)))), testfreq, 'spline');
    
            % Add the attenuations
            inCal = app.InputAttenuationValueField.Value + Att_in;
            outCal = app.OutputAttenuationValueField.Value + Att_out;
    
            % Get the driver output power for the current input power
            driver = readtable(app.DriverFile, 'VariableNamingRule', 'preserve');
    
            % Get measured driver frequencies and input powers
            driverFreq = unique(driver.('Frequency (MHz)')) * 1E6;
            %driverPower = unique(driver.('RF Input Power (dBm)'));
            driverPower = unique(driver.('RF Input Power (dBm)'));
            
            % Interpolate the measurement frequency with driver data
            driverFreq = interp1(driverFreq, driverFreq, testfreq, 'nearest', 'extrap');
            disp(driverFreq);
    
            % Interpolate 
            driverPower = interp1(driverPower, driverPower, RFInputPower - inCal, 'nearest', 'extrap');

            x = driver.('Frequency (MHz)');
            y = driver.('RF Input Power (dBm)');

            save('myVars.mat');  % Saves everything in the current workspace

    
            % Obtain the driver large signal gain for given measurement
            driverGain = driver(driver.('Frequency (MHz)') == driverFreq && driver.('RF Input Power (dBm)') == driverPower);

            driverGain = table2array(driverGain.Gain); driverGain = driverGain(1); % Convert to number
            
            % Recalculate inCal to include driver gain
            inCal = app.InputAttenuationValueField.Value + Att_in - driverGain;
    end
end