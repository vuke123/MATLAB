% y = out.y.Data;
% t = out.y.Time;
% 
% si=stepinfo(y,t,'SettlingTimeThreshold',0.9);
% tz=si.RiseTime;
% ta=si.SettlingTime;
% 
% U_s = 3;
% 
% Kp = y(end)/ U_s;

s=tf('s');
KR = (1*ta)/(Kp*tz);
TI = 3.33*tz;
TD = 0.5*tz; 
v = 20;
TD_real = TD * (s/(1+(TD/v)*s));
GPID = KR*(1+1/(TI*s)+TD_real*s);
T = 0.1;
GPID_D =  c2d(GPID, T, 'tustin');

num = GPID_D.Numerator;
den = GPID_D.Denominator;

num_c = GPID.Numerator;
den_c = GPID.Denominator;



