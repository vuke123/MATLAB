function G = spektralnaAnaliza(y, u, H, W, Ts)

% Funkcija za identifikaciju SISO sustava spektralnom analizom.
% ULAZI:
% y - izlazni signal modela,
% u - ulazni signal,
% H - broj razmatranih uzoraka signala,
% W - vektor frekvencija za DFT,
% Ts - vrijeme uzorkovanja.

% IZLAZ:
% G - identificirani neparametarski model procesa.
window=hann(2*H+1);

% autokorelacijska funkcija Ruu
[Ruu,lags_u] = xcorr(u, H, 'biased'); %H predstavlja maksimalno dozvoljeno kašnjenje u odnosu na trenutni vr korak

% meðukorelacijska funkcija Ruy pomoæu xcorr funkcije
[Ruy,lags_y] = xcorr(y, u, H, 'biased');

% Ruu*prozor:
RuW=Ruu.*window;
RyW=Ruy.*window;

Suu=zeros(1,length(W));
Suy=zeros(1,length(W));
taus = (-H:H);
%------------------------
for i=1:length(W)
     Suu(i)= sum(RuW.*exp(-1i*W(i)*taus'));
     Suy(i)= sum(RyW.*exp(-1i*W(i)*taus'));
end
%-------------------------

%%% neparametarski model procesa: G = Suy/Suu
G = idfrd(Suy./Suu, W', Ts);

end