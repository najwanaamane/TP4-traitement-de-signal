# TP4-traitement-de-signal

**Introduction**
Ce TP vise à appliquer des filtres réels pour éliminer les composantes indésirables d'un signal, en utilisant Matlab pour la simulation. Les objectifs sont de comprendre les différences entre le temps continu et le temps discret, d'améliorer la qualité de filtrage en augmentant l'ordre du filtre, et de tracer les figures appropriées. Le TP se concentrera sur l'application de filtres passe-haut pour supprimer la composante à 50 Hz, et sur la suppression de bruits haute fréquence dans un enregistrement sonore.

**Filtrage et diagramme de Bode**
Nous souhaitons appliquer un filtre passe-haut pour supprimer la composante à 50 Hz. 
Soit notre signal d'entrée : x(t) = sin(2.pi.f1.t) + sin(2.pi.f2.t) + sin(2.pi.f3.t) Avec f1 = 500 Hz, f2 = 400 Hz et f3 = 50 Hz 
1.	Définir le signal x(t) sur t = [0 5] avec Te = 0,0001 s.

Note : On pose 5-te pour éliminer la fuite spectrale et obtenir des valeurs exactes
<pre>
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
</pre>
1. Tracer le module de la fonction H(f) avec K=1 et wc = 50 rad/s. 
2. Tracer 20.log(|H(f)|) pour différentes pulsations de coupure wc, qu'observez-vous ? (Afficher avec semilogx)

<pre>


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

</pre>


3.Choisissez différentes fréquences de coupure et appliquez ce filtrage dans l'espace des fréquences. Qu'observez-vous ?
<pre>

fc1 = 500 ; 
fc2 = 400 ;
fc3 = 50;

K = 1 ; 
H1 = (K*1j*f/fc1)./(1+1j*f/fc1) ;
H2 = (K*1j*f/fc2)./(1+1j*f/fc2) ; 
H3 =(K*1j*f/fc3)./(1+1j*f/fc3) ;


G1 = 20*log(abs(H1));
G2 = 20*log(abs(H2));
G3 = 20*log(abs(H3));


phi1 = angle(H1);
phi2 = angle(H2); 
phi3 = angle(H3);

subplot(121)
semilogx(f,G1 , 'g',f,G2,'y' , f,G3)
ylabel('Gain (dB)')
xlabel('Fréquence (rad/s)')
 
title('Diagrame de Bode ')
subplot(122)
semilogx(f,phi1, 'g',f,phi2,'r',f,phi3,'b')
 ylabel('Phase (deg)') 
 xlabel('Fréquence (rad/s)')
 


%%

%
yt1 = tansf.*H1
inver1=ifft(yt1,'symmetric');

yt2 = tansf.*H2
inver2=ifft(yt2,'symmetric');

yt3 = tansf.*H3
inver3=ifft(yt3,'symmetric');

%la représentation du signal dans le domaine fréquenciel aprés le fitrage 
 subplot(131)
 plot(fshift,fftshift(abs(fft(inver1))/N)*2);
 title(' le signal filtré avec fc=500')

 subplot(132)
 plot(fshift,fftshift(abs(fft(inver2))/N)*2);
title(' le signal filtré avec fc=400')

 subplot(133)
 plot(fshift,fftshift(abs(fft(inver3))/N)*2);
title(' le signal filtré avec fc=50')
</pre>

4. Choisissez wc qui vous semble optimal. Le filtre est-il bien choisi ? Pourquoi ?
la fréquence fc=50 est la plus optimale ; car elle permet de filtrer le signal sans perte d’information utile
**Dé-bruitage d'un signal sonore**
Dans son petit studio du CROUS, un mauvais futur ingénieur a enregistré une musique en « .wav » avec un très vieux micro. Le résultat est peu concluant, un bruit strident s'est ajouté à sa musique. Heureusement son voisin, expert en traitement du signal est là pour le secourir : « C'est un bruit très haute fréquence, il suffit de le supprimer. » dit-il sûr de lui. 
1.	Proposer une méthode pour supprimer ce bruit sur le signal

Pour supprimer le bruit sur le signal, on peut utiliser un filtre passe-bas. Il permet de supprimer les fréquences hautes, comme le bruit strident, tout en conservant les fréquences basses, comme la musique

2.	Mettez-la en oeuvre. Quelle influence à le paramètre K du filtre que vous avez utilisé ?
<pre>

clear all
close all
clc

[music, fs] = audioread('test.wav');
music = music';

N = length(music);

f = (0:N-1)*(fs/N);
fshift = (-N/2:N/2-1)*(fs/N);

spectre_music = fft(music);
% plot(fshift,fftshift(abs(spectre_music)));


k = 1;
fc = 4500;
%la transmitance complexe 
h = k./(1+1j*(f/fc).^100);

h_filter = [h(1:floor(N/2)), flip(h(1:floor(N/2)))];

y_filtr = spectre_music(1:end-1).*h_filter;
sig_filtred= ifft(y_filtr,"symmetric");

semilogx(f(1:floor(N/2)),abs( h(1:floor(N/2))),'linewidth',1.5)

plot(fshift(1:end-1),fftshift(abs(fft(sig_filtred))))
</pre>


3.	Quelles remarques pouvez-vous faire notamment sur la sonorité du signal final.

En utilisant un filtre passe-bas, on peut observer une amélioration de la qualité sonore en supprimant le bruit strident. Cependant, il est possible que certaines hautes fréquences importantes pour la musique soient également supprimées, ce qui peut altérer la sonorité du signal final.

** conclusion**

En conclusion, ce TP a permis de mettre en pratique les concepts de filtrage et de dé-bruitage de signal en utilisant les diagrammes de Bode ainsi que des filtres passe haut et passe bas se basant sur la transmittance. Il est important de noter que ces concepts peuvent être appliqués à divers types de signaux, y compris les signaux sonores. Ce TP a donc permis de découvrir les outils et méthodes pour améliorer la qualité de signal.
