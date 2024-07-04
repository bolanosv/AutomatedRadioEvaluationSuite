function label = formatFreq(Frequency)
    % This function takes in a frequency value and returns it in scientific
    % notation for plotting purposes.
    if Frequency >= 1e9
        label = sprintf('%.2f GHz', Frequency / 1e9);
    elseif Frequency >= 1e6
        label = sprintf('%.2f MHz', Frequency / 1e6);
    elseif Frequency >= 1e3
        label = sprintf('%.2f kHz', Frequency / 1e3);
    else
        label = sprintf('%.2f Hz', Frequency);
    end     
end