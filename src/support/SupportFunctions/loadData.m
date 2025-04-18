function combinedData = loadData(app, RFcomponent, FileName)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function loads data in from a CSV or Excel file containing a 
    % single or sweep PA test measurement, or an Antenna test measurement. 
    %
    % PARAMETERS
    %   RFcomponenet: Either 'PA' or 'Antenna' depending on which type of 
    %                 measurement is being loaded.
    %   FileName:     The name of the file that will be loaded into the
    %                 application.
    %
    % RETURNS
    %   combinedData: A struct containing all the data from each column of 
    %                 the loaded file. User can acces specific data by 
    %                 accesing the array's fields.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    combinedData = struct();
    
    if nargin < 3
        [file, path, ~] = uigetfile({'*.csv;*.xls;*.xlsx', 'Data Files (*.csv, *.xls, *.xlsx)'});
        
        % Check if the user cancel the file selection
        if isequal(file, 0) || isequal(path, 0)
            return;
        end

        FileName = fullfile(path, file);
    end 

    % Store the file path in the base workspace, so user can acces it if needed.
    assignin('base', 'loadedFilePath', FileName);

    try
        if strcmp(RFcomponent, 'PA')
            % Turn off annoying warning, save state.
            w = warning('off','MATLAB:table:ModifiedAndSavedVarnames');       
            combinedData = readtable(FileName);

            % Reset warning level.
            warning(w);                                                     
            combinedData.Properties.VariableNames = regexprep(combinedData.Properties.VariableNames, '_', '');

            if ~isempty(combinedData)  
                app.PA_DataTable = combinedData;
                % Find PSU channel numbers
                varNames = app.PA_DataTable.Properties.VariableNames;
                matches = regexp(varNames, '^Channel(\d+)VoltagesV$', 'tokens');
    
                % Flatten the list and convert to numeric
                app.PA_PSU_Channels = cellfun(@(x) str2double(x{1}), matches(~cellfun('isempty', matches)));
    
                % Get the voltages for each PSU
                app.PA_PSU_SelectedVoltages = zeros(numel(app.PA_PSU_Channels),1);
                app.PA_PSU_Voltages = struct();
                for i = 1:numel(app.PA_PSU_Channels)
                    chNum = app.PA_PSU_Channels(i);
                    chName = sprintf('Channel%dVoltagesV', chNum);
                    app.PA_PSU_Voltages.(chName) = unique(app.PA_DataTable.(chName));
                    app.PA_PSU_SelectedVoltages(chNum) = app.PA_PSU_Voltages.(chName)(1);
                end

                % Update dropdown values to match the data.
                updatePAPlotDropdowns(app);
                
                % Plot with updated dropdown values.
                plotPASingleMeasurement(app);
                plotPASweepMeasurement(app);
            end
        elseif strcmp(RFcomponent, 'Antenna')
             % Turn off annoying warning, save state.
             w = warning('off','MATLAB:table:ModifiedAndSavedVarnames');       
             combinedData = readtable(FileName);
 
             % Reset warning level.
             warning(w);                                                    
             combinedData.Properties.VariableNames = regexprep(combinedData.Properties.VariableNames, '_', '');

             % Check if the imported data is empty.
             if ~isempty(combinedData) 
                 app.Antenna_Data = combinedData;

                 % Check each required field and add to the list if missing.
                 expectedVars = {'Thetadeg', 'Phideg', 'FrequencyMHz', 'GaindBi', 'ReturnLossdB', 'ReturnLossdeg'};
                 missingFields = setdiff(expectedVars, app.Antenna_Data.Properties.VariableNames);
 
                 % If any fields are missing, raise an error telling the
                 % user which field is missing. 
                 if ~isempty(missingFields)
                     error(['The antenna gain file is missing the following required field(s): ', strjoin(missingFields, ', ')]);
                 end
             end
        elseif strcmp(RFcomponent, 'AntennaReference')
             % Turn off annoying warning, save state.
             w = warning('off','MATLAB:table:ModifiedAndSavedVarnames');      
             combinedData = readtable(FileName);
        
             % Reset warning level.
             warning(w);                                                  
             combinedData.Properties.VariableNames = regexprep(combinedData.Properties.VariableNames, '_', '');
        
             % Check if the imported data is empty
             if ~isempty(combinedData) 
                 % Extract antenna measurement parameters from the file.
                 idx = (combinedData.Thetadeg==0) & (combinedData.Phideg==0);
        
                 if ~any(idx)
                     error('Boresight Gain is not available in the file (Theta=0 and Phi=0)')
                 else
                     combinedData = combinedData(idx,:);
                     app.ReferenceGainFile = combinedData;
                     app.ReferenceGainFilePath = FileName;
                     
                     % Check each required field and add to the list if missing.
                     expectedVars = {'Thetadeg', 'Phideg', 'FrequencyMHz', 'GaindBi', 'ReturnLossdB', 'ReturnLossdeg'};
                     missingFields = setdiff(expectedVars, app.ReferenceGainFile.Properties.VariableNames);
        
                     % If any fields are missing, raise an error telling the
                     % user which field is missing. 
                     if ~isempty(missingFields)
                         error(['The antenna gain file is missing the following required field(s): ', strjoin(missingFields, ', ')]);
                     end
                 end
             end
        end
     catch ME
         app.displayError(ME);
    end
end