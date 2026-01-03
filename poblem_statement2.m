clc;
clear;
close all;
fs = 16000;                  % Sampling frequency
t = (0:1/fs:3)';             % 3 seconds duration
source1 = sin(2*pi*300*t);
source2 = sin(2*pi*3000*t);
x = source1 + source2;
window = hamming(1024);
noverlap = 512;
nfft = 1024;

[S, F, T] = stft(x, fs, ...
    'Window', window, ...
    'OverlapLength', noverlap, ...
    'FFTLength', nfft);

magnitude = abs(S);
mask_low = F < 1000;     % Low-frequency mask
mask_high = F >= 1000;   % High-frequency mask

mask1 = mask_low .* ones(1, size(S,2));
mask2 = mask_high .* ones(1, size(S,2));

S1 = S .* mask1;         % Source 1 STFT
S2 = S .* mask2;         % Source 2 STFT

y1 = istft(S1, fs, ...
    'Window', window, ...
    'OverlapLength', noverlap, ...
    'FFTLength', nfft);

y2 = istft(S2, fs, ...
    'Window', window, ...
    'OverlapLength', noverlap, ...
    'FFTLength', nfft);

figure;
subplot(3,1,1);
spectrogram(x, window, noverlap, nfft, fs, 'yaxis');
title('Spectrogram of Mixed Signal');

subplot(3,1,2);
spectrogram(y1, window, noverlap, nfft, fs, 'yaxis');
title('Separated Source 1 (Low Frequency)');

subplot(3,1,3);
spectrogram(y2, window, noverlap, nfft, fs, 'yaxis');
title('Separated Source 2 (High Frequency)');

error1 = source1(1:length(y1)) - y1;
error2 = source2(1:length(y2)) - y2;

SDR1 = 10*log10(sum(source1.^2)/sum(error1.^2));
SDR2 = 10*log10(sum(source2.^2)/sum(error2.^2));

disp('--- Performance Metrics ---');
fprintf('SDR Source 1 (Low freq): %.2f dB\n', SDR1);
fprintf('SDR Source 2 (High freq): %.2f dB\n', SDR2);

