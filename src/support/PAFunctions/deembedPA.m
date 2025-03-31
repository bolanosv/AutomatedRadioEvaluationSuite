function [inCal,outCal] = deembedPA(app, freq, RFInputPower)
    %   deembedPA: De-embed PA measurement
    %   Outputs: inCal (input attenuation), outCal (output attenuation)
    %   - Subtract the inCal factor [dB] to the input RF power to obtain the correted PA input power.
    %   + Add outCal factor from the measured output power to get the PA output power.
    %   
    %   Inputs: mode (calibration mode), freq (measurement frequency [Hz]),
    %   RFInputPower (RF input power [dBm]),  {inFixedAtt, outFixedAtt}
    %   (fixed attenuations [dB]), {inSpFile, outSpFile} (filenames for
    %   S parameters), driverFile (filename for deembedded driver measurement).
    %   
    %   Removes the effects of passive and active devices to deembed the
    %   measurement and generates calibration factors in dB to correct the
    %   PA input and output RF power.
    
    if strcmp(app.CalibrationMode, "None")
        % Calibration factors are 0

        inCal = 0;
        outCal = 0;
    elseif strcmp(app.CalibrationMode, "Fixed Attenuation")
        % Calibration factors are the fixed attenuation in dB

        inCal = app.InputAttenuationValueField.Value;
        outCal = app.OutputAttenuationValueField.Value;
    elseif strcmp(app.CalibrationMode, "Small Signal")
        % Calibration factors add the fixed attenuation and the
        % interpolated S parameters from the given filename
        
        % Load S parameters for input and output deembeding
        SnP_in = sparameters(app.InputSpFile);
        SnP_out = sparameters(app.OutputSpFile);
        
        % Interpolate the attenuation at the measurement frequency
        Att_in = -interp1(SnP_in.Frequencies, A2dB(squeeze(abs(SnP_in.Parameters(2,1,:)))), freq, 'spline');
        Att_out = -interp1(SnP_out.Frequencies, A2dB(squeeze(abs(SnP_out.Parameters(2,1,:)))), freq, 'spline');

        % Add the attenuations
        inCal = app.InputAttenuationValueField.Value + Att_in;
        outCal = app.OutputAttenuationValueField.Value + Att_out;
    elseif strcmp(app.CalibrationMode, "Small + Large Signal")
        % Adds the fixed attenuation, S parameters, and driver response

        % Load S parameters for input and output deembeding
        SnP_in = sparameters(app.InputSpFile);
        SnP_out = sparameters(app.OutputSpFile);

        % Interpolate the attenuation at the measurement frequency
        Att_in = -interp1(SnP_in.Frequencies,A2dB(squeeze(abs(SnP_in.Parameters(2,1,:)))),freq,'spline');
        Att_out = -interp1(SnP_out.Frequencies,A2dB(squeeze(abs(SnP_out.Parameters(2,1,:)))),freq,'spline');

        % Add the attenuations
        inCal = app.InputAttenuationValueField.Value + Att_in;
        outCal = app.OutputAttenuationValueField.Value + Att_out;

        % Get the driver output power for the current input power
        driver = readtable(app.DriverFile);

        % Get measured driver frequencies and input powers
        driverFreq = unique(driver.Frequency)*1E6;
        driverPower = unique(driver.RFInputPower);
        
        % Interpolate the measurement frequency with driver data
        driverFreq = interp1(driverFreq,driverFreq,freq,'nearest');

        % Interpolate 
        driverPower = interp1(driverPower,driverPower,RFInputPower-inCal,'nearest');

        % Obtain the driver large signal gain for given measurement
        driverGain = driver(driver.Frequency==driverFreq && driver.RFInputPower==driverPower);
        driverGain = table2array(driverGain.Gain); driverGain = driverGain(1); % Convert to number
        
        % Recalculate inCal to include driver gain
        inCal = app.InputAttenuationValueField.Value + Att_in - driverGain;
    end
end