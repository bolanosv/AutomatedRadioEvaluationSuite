function [Psat, peakGain, peakDE, peakPAE, compression1dB, compression3dB] = measureRFParametersPeaks(app,idx)
    % This function calculates the peak values of several RF parameters:
    % Saturation Power, Gain, DE, PAE, -1dB, and -3dB compression.

    % Get the max output RF power per frequency.
    Psat = groupsummary(app.PA_DataTable(idx,:),'FrequencyMHz','max','RFOutputPowerdBm');
    Psat.GroupCount = []; % Drop GroupCount column
    Psat.Properties.VariableNames = {'FrequencyMHz','RFOutputPowerdBm'};
    for i = 1:height(Psat)      
        Psat_DataTable = app.PA_DataTable(idx,:);
        idx_Psat = (Psat_DataTable.RFOutputPowerdBm == Psat.RFOutputPowerdBm(i));
        Psat.Gain = Psat_DataTable(idx_Psat,:).Gain;
    end

    % Get the max drain efficiency per frequency.
    peakDE = groupsummary(app.PA_DataTable,'FrequencyMHz','max','DE');
    peakDE.GroupCount = []; % Drop GroupCount column
   
    % Get the max power-added efficiency per frequency.
    peakPAE = groupsummary(app.PA_DataTable,'FrequencyMHz','max','PAE');
    peakPAE.GroupCount = []; % Drop GroupCount column

    peakGain = groupsummary(app.PA_DataTable,'FrequencyMHz','max','Gain');
    peakGain.GroupCount = []; % Drop GroupCount column

    % Get the compression points
    freqs = unique(app.PA_DataTable(idx,"FrequencyMHz")); % Iterate by frequency
    for i = 1:height(freqs)
        % Get temporary subtable for each frequency
        freq_DataTable = app.PA_DataTable(idx,:);
        freq_DataTable = freq_DataTable(freq_DataTable.FrequencyMHz == freqs.FrequencyMHz(i),:);
        
        % Select the peak gain corresponding to this frequency
        peakGain_i = table2array(peakGain(peakGain.FrequencyMHz == freqs.FrequencyMHz(i,:),"max_Gain"));

        % Get the 1 and 
        compression1dB = freq_DataTable(freq_DataTable.Gain <= (peakGain_i - 1),["FrequencyMHz","RFOutputPowerdBm","Gain"]);
        compression3dB = freq_DataTable(freq_DataTable.Gain <= (peakGain_i - 3),["FrequencyMHz","RFOutputPowerdBm","Gain"]);
        if height(compression1dB) > 1
            compression1dB = compression1dB(1,:);
        end
        if height(compression3dB) > 1
            compression3dB = compression3dB(1,:);
        end
    end
end
