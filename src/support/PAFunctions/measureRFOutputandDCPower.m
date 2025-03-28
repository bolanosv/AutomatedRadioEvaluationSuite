function [OutputRFPower, DCDrainPower, DCGatePower] = measureRFOutputandDCPower(app ,inputRFPower)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function measures the output RF power, the DC drain power, and 
    % the DC gate power. Currently the function also accounts for any 
    % attenuation used in the test setup.
    % 
    % INSTRUMENTS
    % Spectrum Analyzer: N9000B
    % Signal Generator:  SMW200A
    % DC Power Supply:   E36233A / E336234A
    %
    % INPUT PARAMETERS
    % app:           The application object containing the instruments and 
    %                the settings.
    % inputRFPower:  The input RF power to the signal generator (in dB).
    %
    % OUTPUT PARAMETERS
    % OutputRFPower: The maximum output RF power after accounting for 
    %                the attenuation in (dB).
    % DCDrainPower:  The DC power delivered to the drain in (watts).
    % DCGatePower:   The DC power delivered to the gate in (watts).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % If an attenuator is used, the function will deal with that.
    attenuation = app.InputAttenuationValueField.Value;

    % Set the power of the signal generator.
    writeline(app.SignalGenerator, sprintf(':SOURce1:POWer:LEVel:IMMediate:AMPLitude %g', inputRFPower));
    waitForInstrument(app, app.SignalGenerator);

    % Turn on the signal generator.
    writeline(app.SignalGenerator, sprintf(':OUTPut1:STATe %d', 1));

    % Initiate the measurement process in the spectrum analyzer.
    writeline(app.SpectrumAnalyzer, sprintf(':INITiate:CONTinuous %d', 0));
    writeline(app.SpectrumAnalyzer, ':INITiate:IMMediate');

    % Wait until the spectrum analyzer is ready.
    writeline(app.SpectrumAnalyzer, '*WAI');
    waitForInstrument(app, app.SpectrumAnalyzer); 

    % Fetch the trace data.
    writeline(app.SpectrumAnalyzer, sprintf(':TRACe:DATA? %s', 'TRACe1'));
    trace_data = readbinblock(app.SpectrumAnalyzer, 'double');

    % Measure the maximum output power and account for attenuation.
    OutputRFPower = max(trace_data) + attenuation;

    % Clear the status register of the spectrum analyzer.
    writeline(app.SpectrumAnalyzer, '*CLS');

    % Measure DC Power and intialize outputs.
    DCDrainPower = zeros(1, length(app.FilledPSUChannels)); 
    DCGatePower = zeros(1, length(app.FilledPSUChannels));   

    drainIndex = 1;
    gateIndex = 1;

    % Read voltage and current from all active channels.
    for i = 1:length(app.FilledPSUChannels)
        channel = app.FilledPSUChannels{i};
        [deviceChannel, psuName] = strtok(app.ChannelToDeviceMap(channel), ',');
        psuName = psuName(2:end);
        
        % Select PSU
        if strcmp(psuName, 'PSUA')
            psu = app.PowerSupplyA;
        else
            psu = app.PowerSupplyB;
        end

        % Read Voltage from PSU
        DCVoltage = str2double(writeread(psu, sprintf(':MEASure:SCALar:VOLTage:DC? %s', deviceChannel)));
        % Read Current from PSU
        DCCurrent = str2double(writeread(psu, sprintf(':MEASure:SCALar:CURRent:DC? %s', deviceChannel)));

        % Calculate DC Power
        channelPower = DCVoltage * DCCurrent;

        % Store the power based on channel designation.
        if ismember(channel, app.DrainChannels)
            DCDrainPower(drainIndex) = channelPower;
            drainIndex = drainIndex + 1;
        elseif ismember(channel, app.GateChannels)
            DCGatePower(gateIndex) = channelPower;
            gateIndex = gateIndex + 1;
        end
    end
end