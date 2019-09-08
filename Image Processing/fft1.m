function [] = fft1()
Fs = 1000;                    % Sampling frequency, 1000 time per second
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t);  % 50 periods of sin height 0.7, and 120 periods of sin height 1
y = x + 2*randn(size(t));     % Sinusoids plus noise
plot(Fs*t(1:100),y(1:100))
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')

Y=fft(y)/L;

f = 0:Fs/2;
figure;plot(f,2*abs(Y(1:L/2+1)))
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

%x1=ifft(Y*L);
%figure;plot(Fs*t(1:50),x1(1:50))
%title('Signal Corrupted with Zero-Mean Random Noise')
%xlabel('time (milliseconds)')

abs(Y(1))