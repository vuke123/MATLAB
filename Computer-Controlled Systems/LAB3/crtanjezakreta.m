close all
t0=0;
l=0.1;
g=9.81;
m=0.5;
b=10;
RuS=180/pi;

%radna tocka
Mu0=0;
phi0=asin(Mu0*2/m/l/g);

%izracun Mu za 60 stupnjeva
phi_ss=pi/4;
Mu=sin(phi_ss)*m*g*l/2
sim('zakretkamere.mdl',1)

figure, hold on
fi=phi.Data(:,1)/RuS;
x=sin(fi)*l/2;
y=-cos(fi)*l/2;
footprint=[-l/4 -l/2;l/4 -l/2; l/4 l/2; -l/4 l/2; -l/4 -l/2];
kut=linspace(0,2*pi,100);
fill(l/4*cos(kut),l/4*sin(kut),'b')
fill(l/8*cos(kut),l/8*sin(kut),'r')
for i=1:2:length(x)
    plot(x(i)+cos(fi(i))*footprint(:,1)-sin(fi(i))*footprint(:,2),y(i)+sin(fi(i))*footprint(:,1)+cos(fi(i))*footprint(:,2))
    axis equal
    pause(0.1)
end