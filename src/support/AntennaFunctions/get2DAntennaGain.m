function get2DAntennaGain(app) 

    % Initialize variables from the application.
    startFrequency = app.VNAStartFrequency.Value * 1E6;
    endFrequency = app.VNAEndFrequency.Value * 1E6;
    sweepPoints = app.VNASweepPoints.Value;
    frequencies = linspace(startFrequency,endFrequency,sweepPoints);

    app.AntennaStopRequested = false;

    if ~isempty(app.ReferenceGainFile)
        ReferenceFreqs = app.ReferenceGainFile.FrequencyMHz;
        ReferenceGain = app.ReferenceGainFile.GaindBi;
    end
    
    % Get table speed and theta angles
    tableSpeed = app.TableSpeedSlider.Value;
    if strcmp(app.ThetaSingleSweepSwitch.Value,'Sweep')
        tableAngles = app.TableStartAngle.Value:app.TableStepAngle.Value:app.TableEndAngle.Value;
    else
        tableAngles = app.TableStartAngle;
    end
    % Get tower speed and phi angles
    towerSpeed = app.TowerSpeedSlider.Value;
    if strcmp(app.PhiSingleSweepSwitch.Value,'Sweep')
        towerAngles = app.TowerStartAngle.Value:app.TowerStepAngle.Value:app.TowerEndAngle.Value;
    else
        towerAngles = app.TowerStartAngle.Value;
    end
    
    parametersTable = createAntParameters(tableAngles,towerAngles);
    totalMeasurements = height(parametersTable) * sweepPoints;
    resultsTable = createAntennaResultsTable(totalMeasurements);

    try
        app.AntennaStopRequested = false;

        % Set speed of the turntable
        writeline(app.EMCenter, sprintf('1A:SPEED %d', tableSpeed));
        writeline(app.EMCenter, sprintf('1B:SPEED %d', towerSpeed));

        for i = 1:height(parametersTable)
            dataPts = (i-1)*sweepPoints + (1:sweepPoints);
            % Get measurement corrected angles for (0,360) range
            adjustedTheta = table2array(mod(parametersTable(i, "Theta (deg)"), 360));
            adjustedPhi = table2array(mod(parametersTable(i, "Phi (deg)"), 360));
            
            % Move the table and tower to specified position
            writeline(app.EMCenter, sprintf('1A:SK %d', adjustedTheta));
            writeline(app.EMCenter, sprintf('1B:SK %d', adjustedPhi));
            moving = 0;
            while ~moving
                drawnow;
                pause(app.AntennaMeasurementDelayValueField.Value);
                % Check if the user requested the test measurement to stop
                if app.AntennaStopRequested
                    writeline(app.EMCenter, '1A:ST');
                    writeline(app.EMCenter, '1B:ST');
                    break;
                end

                statusA = str2double(writeread(app.EMCenter,"1A:*OPC?"));
                statusB = str2double(writeread(app.EMCenter,"1B:*OPC?"));
                moving = (statusA == 1) & (statusB == 1);
            end

            % Exit the outer loop as well if stop was requested
            if app.AntennaStopRequested
                break;
            end

            % Small delay.
            pause(app.AntennaMeasurementDelayValueField.Value);

            % Get S-Parameters and Frequencies from VNA
            [SParameters_dB, SParameters_Phase, VNAFrequencies] = measureSParameters(app.VNA, 2, startFrequency, endFrequency, sweepPoints); 

            if ~isempty(app.ReferenceGainFile)
                Gain_dBi = measureAntennaGain(VNAFrequencies, SParameters_dB{2}, app.setupSpacing, ReferenceGain, ReferenceFreqs);
            else
                Gain_dBi = measureAntennaGain(VNAFrequencies, SParameters_dB{2}, app.setupSpacing);
            end

            resultsTable(dataPts,"Theta (deg)") = array2table(parametersTable.("Theta (deg)")(i)*ones(numel(dataPts),1));
            resultsTable(dataPts,"Phi (deg)") = array2table(parametersTable.("Phi (deg)")(i)*ones(numel(dataPts),1));
            resultsTable(dataPts,"Frequency (MHz)") = array2table(VNAFrequencies'/1E6);
            resultsTable(dataPts,"Gain (dBi)") = array2table(Gain_dBi');
            resultsTable(dataPts,"Return Loss (dB)") = array2table(SParameters_dB{3}');
            resultsTable(dataPts,"Return Loss (deg)") = array2table(SParameters_Phase{3}');
            resultsTable(dataPts,"Return Loss Reference (dB)") = array2table(SParameters_dB{1}');
            resultsTable(dataPts,"Return Loss Reference (deg)") = array2table(SParameters_Phase{1}');
            resultsTable(dataPts,"Path Loss (dB)") = array2table(SParameters_dB{2}');
            resultsTable(dataPts,"Path Loss (deg)") = array2table(SParameters_dB{2}');
        end

        % Return turntable to starting position
        writeline(app.EMCenter, sprintf('1A:SK %d', 0));
        writeline(app.EMCenter, sprintf('1B:SK %d', 0));

        % If the measurement was not stopped 
        if ~app.AntennaStopRequested  
            % Save the measurement data
            fullFilename = saveData(resultsTable);
            loadData(app,'Antenna', fullFilename);
            plotAntenna2DMeasurement(app);
        end
    catch ME
        app.displayError(ME);
    end
end
