m1=1.5;
m2=1;
m3=1.5;
c1=500;
c2=800;
c3=500;
d1=1;
d2=1;
d3=1;

A=[           0       1      0       0      0         0;
  (1/m1)*[-(c1+c2)  -d1     c2       0      0         0];
              0       0      0       1      0         0;
  (1/m2)*[   c2       0  -(c2+c3)  -d2     c3         0]; 
              0       0      0       0      0         1;
  (1/m3)*[    0       0     c3       0    -c3       -d3]];

B=[0 1/m1 0 0 0 0]';
C=[1 0 0 0 0 0;
   0 0 1 0 0 0;
   0 0 0 0 1 0];
D=[0;0;0];

%% den - polinom prijenosna funkcija preko koje djeluje šum, koristi se u modelu
C_pom=[1 0 0 0 0 0];
D_pom=[0];
[num,den]=ss2tf(A,B,C_pom,D_pom,1); %brojnik i nazivnik prijelazne funkcije
%state space 2 transfer func