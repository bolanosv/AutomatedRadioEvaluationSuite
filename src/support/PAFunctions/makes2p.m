% s2p file format
% !Freq S11(dB)  S11(ang)   S21(dB) S21(ang) S12(dB) S12(ang) S22(dB) S22(ang) 

freqs = [4e9, 6e9];

insertionLoss_dB = [-6, -6];

S21_mag = 10.^(-insertionLoss_dB / 20);

% ALL 0s for now
S11_mag = [0, 0]; S12_mag = [0, 0]; S22_mag = [0, 0];
S11_ang = [0, 0]; S12_ang = [0, 0]; S21_ang = [0, 0]; S22_ang = [0, 0];


filename = "test_data.s2p";
fid = fopen(filename, 'w');

fprintf(fid, "# Hz S MA R 50\n");

for i = 1:length(freqs)
    fprintf(fid, "%.0f %.5f %.2f %.5f %.2f %.5f %.2f %.5f %.2f\n", ...
        freqs(i), S11_mag(i), S11_ang(i), S21_mag(i), S21_ang(i), ...
        S12_mag(i), S12_ang(i), S22_mag(i), S22_ang(i));
end

fclose(fid);