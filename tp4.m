clear all
close all
clc


te = 0.0001;
fe = 1/te;
t = 0:te:5-te;
N = length(t);

f1 = 500; f2 = 400; f3 = 50;
x = sin(2*pi*f1*t) + sin(2*pi*f2*t) + sin(2*pi*f3*t);

figure
% subplot(3,1,1)
% plot(t,x)
% title('Signal x(t)')

y = fft(x);
f = (0:N-1)*(fe/N);
fshift =(-N/2:N/2-1)*(fe/N)

plot(fshift,fftshift(abs(y)))
title('Transformée de Fourrier de x(t)avec 0.0001')








