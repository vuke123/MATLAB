close all

l=0.1;
g=9.81;
m=0.5;
b=10;
RuS=180/pi;
G_s=tf([3/m/l^2*RuS],[1 3/4*b/m 3/2*g/l])
figure, step(G_s)
figure, pzmap(G_s), title('kontinuirani proces')

%radna tocka
Mu0=0;
phi0=asin(Mu0*2/m/l/g);
disp(phi0*RuS)

%izracun Mu za 60 stupnjeva 10, 20, 40, 90, koji je najveci?
phi_ss=pi/3;
Mu=sin(phi_ss)*m*g*l/2

%trenutak djelovanja stepa
t0=5;

%druga radna tocka
% phi0=55/RuS; %45, 55
% Mu0=sin(phi0)*m*g*l/2


%odziv na impuls:
% Mu=0.5; %1.05;
