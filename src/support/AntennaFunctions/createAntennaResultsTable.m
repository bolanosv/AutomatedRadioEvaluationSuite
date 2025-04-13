function ResultsTable = createAntennaResultsTable(totalMeasurements)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Add measurements column.
    varNames = {'Theta (deg)', 'Phi (deg)', 'Frequency (MHz)',...
            	'Gain (dBi)', 'Return Loss (dB)', 'Return Loss (deg)',...
                'Return Loss Reference (dB)', 'Return Loss Reference (deg)', ...
                'Path Loss (dB)', 'Path Loss (deg)'
    };
    
    varTypes = repmat({'double'}, 1, length(varNames));
    
    % Create the Antenna results table.
    ResultsTable = table('Size', [totalMeasurements, length(varNames)], ...
                         'VariableTypes', varTypes, ...
                         'VariableNames', varNames);
end
