clear all;
signal = 1;
tmass_ss;

Ts = 0.01;
Tsim = 2*pi/0.1; 
Am = 1; 
sim('tromaseni_model.mdl')

fdata = fft(data.signals.values);
signals1 = fdata(:,1);
avg_signals1 = sum(abs(signals1))/length(signals1);
Am = avg_signals1 / 188;
sim("tromaseni_model.mdl")

time = data.time;

chirp_signal = data.signals.values(:, 4);

odziv_modela = data.signals.values(:, 1);

idealni_odziv = data.signals.values(:, 5);


chirp_signal = detrend(data.signals.values(:, 4));
odziv_modela = detrend(data.signals.values(:, 1));
idealni_odziv = detrend(data.signals.values(:, 5));

figure;

subplot(3, 1, 1);
plot(time, chirp_signal);
title('Chirp signal');
xlabel('Vrijeme [s]');
ylabel('Amplituda');

subplot(3, 1, 2);
plot(time, odziv_modela);
title('Odziv modela (pomak prve mase) sa šumom');
xlabel('Vrijeme [s]');
ylabel('Pomak [m]');

subplot(3, 1, 3);
plot(time, idealni_odziv);
title('Idealni odziv');
xlabel('Vrijeme [s]');
ylabel('Pomak [m]');

sgtitle('Analiza Chirp Signala i Odziva Modela'); 


auto_corr = xcorr(data.signals.values(:,4)); %chirp
inter_corr = xcorr(data.signals.values(:,4),data.signals.values(:,1));
%sa šumom
figure;
hold on;
subplot(2,1,1)
plot(auto_corr)
title('Autokorelacijska funkcija')
subplot(2,1,2)
plot(inter_corr)
title('Međukorelacija funkcija')

vector = linspace(0.1, Tsim, length(chirp_signal));

H1 = 200;
H2 = 1500;
H3 = 3000;
figure;

%Spektralna analiza i Bode plot za prvi slučaj (H1)
subplot(3, 1, 1);
sA1 = spektralnaAnaliza(odziv_modela, data.signals.values(:, 4), H1, vector, Ts);
hold on;
bodeplot(tf(num, den), 'r');
bodeplot(sA1, 'b');
xlim([0.1 1000]);
grid on;
title(['H = ', num2str(H1)]);
legend('Idealno', 'Estimirano');

% Spektralna analiza i Bode plot za drugi slučaj (H2)
subplot(3, 1, 2);
sA2 = spektralnaAnaliza(odziv_modela, data.signals.values(:, 4), H2, vector, Ts);
hold on;
bodeplot(tf(num, den), 'r');
bodeplot(sA2, 'b');
xlim([0.1 1000]);
grid on;
title(['H = ', num2str(H2)]);
legend('Idealno', 'Estimirano');

% Spektralna analiza i Bode plot za treći slučaj (H3)
subplot(3, 1, 3);
sA3 = spektralnaAnaliza(odziv_modela, data.signals.values(:, 4), H3, vector, Ts);
hold on;
bodeplot(tf(num, den), 'r');
bodeplot(sA3, 'b');
xlim([0.1 1000]);
grid on;
title(['H = ', num2str(H3)]);
legend('Idealno', 'Estimirano');

G= fft(odziv_modela)./fft(chirp_signal);
start_freq = 0.01 * 2 * pi;   % Početna frekvencija u radijanima po sekundi
end_freq = 10 * 2 * pi;       % Krajnja frekvencija u radijanima po sekundi (primjerice 10 Hz)
num_points = length(chirp_signal);  % Broj frekvencijskih točaka

% Kreiranje vektora frekvencija pomoću linspace
frequencies = linspace(start_freq, end_freq, num_points);

% Kreiranje idfrd objekta
G = idfrd(G, frequencies, Ts);%idfrd - kreiranje objekta koji predstavlja frekvencijski odziv modela 
%dodatne informacije o frekvencijama, periodu uzorkovanja i drugi metapodaci.
figure(16)
hold on
bodeplot(G,tf(num,den))
title('Frekvencijska karakteristika idealnog modela i estimiranog modela pomoću DFT-a')
legend('DTF', 'Idealno')
grid on

