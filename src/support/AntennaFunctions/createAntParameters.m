function paramTable = createAntParameters(Theta,Phi)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function creates a parameter sweep table for antenna testing,
    % generating all possible combinations of angles.
    %
    % INPUT PARAMETERS
    % app:  The application object containing theta and phi angles
    %
    % OUTPUT PARAMETERS
    % paramTable:  The antenna test paramaters table containing all 
    %              combinations of theta (deg) and phi (deg).
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    arguments (Input)
        Theta
        Phi
    end
    
    arguments (Output)
        paramTable
    end

    varNames = {"Theta (deg)","Phi (deg)"};
    varNames = horzcat(varNames{:});

    paramTable = array2table(combinations(Theta,Phi),'VariableNames',varNames);
end