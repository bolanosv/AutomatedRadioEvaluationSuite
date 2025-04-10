function get2DAntennaGain(app) 

    % Initialize variables from the application.
    startFrequency = app.VNAStartFrequency.Value * 1E6;
    endFrequency = app.VNAEndFrequency.Value * 1E6;
    sweepPoints = app.VNASweepPoints.Value;

    app.AntennaStopRequested = false;

    if ~isempty(app.ReferenceGainFile)
        ReferenceFreqs = app.ReferenceGainFile.FrequencyHz;
        ReferenceGain = app.ReferenceGainFile.GaindBi;
    end
    
    tableSpeed = app.TableSpeedSlider.Value;
    tableAngles = app.TableStartAngle.Value:app.TableStepAngle.Value:app.TableEndAngle.Value;
    arraySize = sweepPoints * length(tableAngles);
    
    app.S11 = zeros(1, arraySize);
    app.S21 = zeros(1, arraySize);
    app.S22 = zeros(1, arraySize); 
    app.AzimuthAngles = zeros(1, arraySize);
    app.Antenna_Frequencies = zeros(1, arraySize);
    app.AntennaGain_dBi = zeros(1, arraySize);
    % 
    % % Prepare variable names and types for the results table.
    % varNames = {'Azimuth Angles (deg)',...
    %             'Frequency (Hz)',...
    %             'Gain (dBi)',...
    %             'Return Loss (dB)'};
    % varTypes = repmat({'double'}, 1, length(varNames));
    % 
    % % Create results table
    % ResultsTable = table('Size', [totalMeasurements, length(varNames)], ...
    %                      'VariableTypes', varTypes, ...
    %                      'VariableNames', varNames);

    try
        % Set speed of the turntable
        writeline(app.EMCenter, sprintf('1A:SPEED %d', tableSpeed));

        for i = 1:length(tableAngles)
            dataPts = (i-1)*sweepPoints + (1:sweepPoints);
            adjustedAzimuthAngle = mod(tableAngles(i), 360);

            % Move table to specified angle
            writeline(app.EMCenter, sprintf('1A:SK %d', adjustedAzimuthAngle));
            status = writeread(app.EMCenter,"1A:*OPC?");
            status = str2double(strtrim(status));
            while status ~= 1
                drawnow;

                % Check if the user requested the test measurement to stop
                if app.AntennaStopRequested
                    writeline(app.EMCenter, '1A:ST');
                    pause(1);
                    break;
                end
                
                status = writeread(app.EMCenter,"1A:*OPC?");
                status = str2double(strtrim(status));
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

            app.AzimuthAngles(dataPts) = tableAngles(i);
            app.Antenna_Frequencies(dataPts) = VNAFrequencies;
            app.S11(dataPts) = SParameters_dB{1};
            app.S21(dataPts) = SParameters_dB{2};
            app.S22(dataPts) = SParameters_dB{3};
            app.S11_Phase(dataPts) = SParameters_Phase{1};
            app.S21_Phase(dataPts) = SParameters_Phase{2};
            app.S22_Phase(dataPts) = SParameters_Phase{3};
            app.AntennaGain_dBi(dataPts) = Gain_dBi;
        end

        % Return turntable to starting position
        writeline(app.EMCenter, sprintf('1A:SK %d', 0));

        % If the measurement was not stopped 
        if ~app.AntennaStopRequested
            combinedData = [double(app.AzimuthAngles)',... 
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
            saveData(combinedData, combinedNames);
        end
    catch ME
        app.displayError(ME);
    end
end
