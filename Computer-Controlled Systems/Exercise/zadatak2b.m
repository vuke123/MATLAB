close all

l=0.1;
g=9.81;
m=0.5;
b=10;
RuS=180/pi;

phi_ss=45/RuS;
Mu=sin(phi_ss)*m*g*l/2

sim('kamerazn.mdl', 1);
y=phi.Data;
t=phi.Time;
plot(t,y,'.-'), hold on

si=stepinfo(y,t,'SettlingTimeThreshold',0.9)
tr=si.RiseTime;
tz=si.SettlingTime;
Kp=y(end)/Mu;

s=tf('s');
Ki = Kp/(2*tz)
Kd = (0.5*tz)*Kp
Tv = (0.5*tz)/10

P = Kp 
I = Ki/s
D = Kd*s/(1+Tv*s)

PID = P + D
PI = P + I 

Gf = ((1+Tv*s) / (2*tz*0.5*tz*((1/10)+1)*(s^2) + ((0.5*tz/10)+(2*tz))*s + 1))
