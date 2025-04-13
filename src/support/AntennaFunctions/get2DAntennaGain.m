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
            
            statusA = writeread(app.EMCenter,"1A:*OPC?");
            statusB = writeread(app.EMCenter,"1B:*OPC?");
            statusA = str2double(strtrim(statusA));
            statusB = str2double(strtrim(statusB));

            while (statusA ~= 1) && (statusB ~= 1)
                drawnow;

                % Check if the user requested the test measurement to stop
                if app.AntennaStopRequested
                    writeline(app.EMCenter, '1A:ST');
                    writeline(app.EMCenter, '1B:ST');
                    pause(1);
                    break;
                end

                statusA = writeread(app.EMCenter,"1A:*OPC?");
                statusB = writeread(app.EMCenter,"1B:*OPC?");
                statusA = str2double(strtrim(statusA));
                statusB = str2double(strtrim(statusB));
            end

            % Exit the outer loop as well if stop was requested
            if app.AntennaStopRequested
                break;
            end

            % Small delay.
            pause(app.AntennaMeasurementDelayValueField.Value / 2);

            % Get S-Parameters and Frequencies from VNA
            [SParameters_dB, SParameters_Phase, VNAFrequencies] = measureSParameters(app.VNA, 2, startFrequency, endFrequency, sweepPoints); 

            if ~isempty(app.ReferenceGainFile)
                Gain_dBi = measureAntennaGain(VNAFrequencies, SParameters_dB{2}, app.setupSpacing, ReferenceGain, ReferenceFreqs);
            else
                Gain_dBi = measureAntennaGain(VNAFrequencies, SParameters_dB{2}, app.setupSpacing);
            end

            app.Theta(dataPts) = parametersTable.("Theta (deg)")(i);
            app.Phi(dataPts) = parametersTable.("Phi (deg)")(i);
            app.Antenna_Frequencies(dataPts) = VNAFrequencies;
            app.S11_Mag_dB(dataPts) = SParameters_dB{1};
            app.S21_Mag_dB(dataPts) = SParameters_dB{2};
            app.S22_Mag_dB(dataPts) = SParameters_dB{3};
            app.S11_Phase_deg(dataPts) = SParameters_Phase{1};
            app.S21_Phase_deg(dataPts) = SParameters_Phase{2};
            app.S22_Phase_deg(dataPts) = SParameters_Phase{3};
            app.AntennaGain_dBi(dataPts) = Gain_dBi;
        end

        % Return turntable to starting position
        writeline(app.EMCenter, sprintf('1A:SK %d', 0));


        return; % Algorithm completed up to this point. Debug load and save data.


        % If the measurement was not stopped 
        if ~app.AntennaStopRequested
            combinedData = [double(app.Theta)',... 
                            double(app.Antenna_Frequencies / 1E6)',...
                            double(app.AntennaGain_dBi)',...
                            double(app.S11)',...
                            double(app.S11_Phase)'
            ];
            combinedNames = {'Azimuth Angles (deg)',... 
                             'Frequency (MHz)',...
                             'Gain (dBi)',...
                             'Return Loss (dB)',...
                             'Return Loss (deg)'
            };
    
            % Save the measurement data
            fullFilename = saveData(combinedData, combinedNames);
            loadData('Antenna', fullFilename);
        end
    catch ME
        app.displayError(ME);
    end
end
