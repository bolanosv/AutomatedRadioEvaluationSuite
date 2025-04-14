function paramTable = createAntennaParametersTable(Theta,Phi)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function creates a parameter sweep table for antenna testing,
    % generating all possible combinations of Theta and Phi.
    %
    % INPUT PARAMETERS:
    %   Theta:  Vector of theta angles (in degrees).
    %   Phi:    Vector of phi angles (in degrees).
    %
    % OUTPUT PARAMETERS:
    %   paramTable - A table containing all combinations of Theta in (deg)
    %                and Phi in (deg).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create combinations of Theta and Phi.
    varNames = {"Theta (deg)","Phi (deg)"};
    varNames = horzcat(varNames{:});

    % Set the column names for the table.
    paramTable = combinations(Theta,Phi);
    paramTable.Properties.VariableNames = varNames;
end