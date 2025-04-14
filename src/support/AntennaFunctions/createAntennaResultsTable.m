function ResultsTable = createAntennaResultsTable(totalMeasurements)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function initializes the results table for storing
    % antenna test measurements.
    %
    % INPUT:
    %   totalMeasurements: Number of measurements (rows) to allocate
    %
    % OUTPUT:
    %   ResultsTable: Preallocated table with the following columns:
    %                 - Theta (deg)
    %                 - Phi (deg)
    %                 - Frequency (MHz)
    %                 - Gain (dBi)
    %                 - Return Loss (dB)
    %                 - Return Loss (deg)
    %                 - Return Loss Reference (dB)
    %                 - Return Loss Reference (deg)
    %                 - Path Loss (dB)
    %                 - Path Loss (deg)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Add measurements columns.
    varNames = {'Theta (deg)',...
                'Phi (deg)',...
                'Frequency (MHz)',...
            	'Gain (dBi)',...
                'Return Loss (dB)',...
                'Return Loss (deg)',...
                'Return Loss Reference (dB)',...
                'Return Loss Reference (deg)',...
                'Path Loss (dB)',...
                'Path Loss (deg)'
    };
    
    varTypes = repmat({'double'}, 1, length(varNames));
    
    % Create the Antenna results table.
    ResultsTable = table('Size', [totalMeasurements, length(varNames)], ...
                         'VariableTypes', varTypes, ...
                         'VariableNames', varNames);
end
