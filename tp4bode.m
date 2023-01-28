clear all
close all
clc
 
w = logspace(-2,2,100)*pi; % création d'un vecteur des pulsations 
wc = [10 50 100]; % création d'un vecteur des pulsations de coupure
figure;
for i = 1:length(wc)
    H = (1*1j*w./(w+wc(i)*1j));  % calcul de la fonction de transfert
    subplot(3,1,i);
    bode(20*log10(abs(H)),w);  % tracer le diagramme de bode de 20.log(|H(f)|)
    title(sprintf('20log(|H(f)|) avec wc=%d rad/s',wc(i)));
    grid on;
end
