function [xhat, P, RadErrMean, RadErrStd] = Satelit(filter)

% Pracenje satelita u Zemljinoj orbiti
%
% Ulazi su:
%   filter = tip koristenog Kalmanovog filtra (KF) u estimaciji putanje
%          'LKF' - diskretni linearizirani KF
%          'EKF' - diskretni prosireni KF
%          'IEKF' - diskretni iterativni prosireni KF

% Izlazi su:
%   Estimirano stanje xhat = [r;, rdot;, theta; thetadot]
%   Kovarijanca greske estimacije P
%   RadErrMean = srednja greska estimacije radijusa putanje satelita
%   RadErrStd =  standardna devijacija greske estimacije radijusa putanje satelita


%% parametri sustava
G = 6.6742e-11; % [m^3/kg/s^2] univerzalna gravitacijska konstanta
M = 5.98e24; % [kg] masa Zemlje


%% nominalna tajektorija - odrediti omega0
r0 = 6.57e6;
omega0 = sqrt(G*M/r0^3);
x0 = [r0; 0; 0; omega0];


%% inicijalizacija sustava

% ovdje opisati sustav u prostoru stanja - postaviti odgovarajuće matrice
A = [ 0, 1,  0, 0; 2*(G*M)/r0^3, 0,  0, 2*r0*omega0; 0, 0,  0, 1; 0, -2*omega0, 0, 0];
B = [0, 0, 0, 0]';
H = [1 0 0 0; 0 0 1 0];
L = [0 0 0 0; 0 1 0 0; 0 0 0 0; 0 0 0 0];
M = diag(2);
r = 100;
th = 0.1;

% ovdje postaviti vrijeme diskretizacije T
T = 60;
A_LKF = expm(A*T);
% ovdje postaviti varijance procesnog i mjernog suma Q i R

Q22 = 1e-6;
Q = diag([0, Q22, 0 ,0]);
R = diag([r, th]);

% inicijalizacija filtera
x = [r0; 0; 0; 1.1*omega0]; % inicijalno stanje
xhat = x; % estimat inicijalnog stanja
P = diag([0,0,0,0]); % inicijalna kovarijanca greske estimacije

%% SIMULACIJA KALMANOVOG FILTRA

% parametri simulacije
tf = 180*60; % duljina simulacije [s]
dt = T; % korak simulacije [s]
PlotStep = 1; % koliko cesto crtati tocke

i = 0;
xArray = x;
xhatArray = xhat;
trP = [];
for t = dt : dt : tf
    
   % Simuliraj sustav (pravokutna integracija).
   xdot(1,1) = x(2);
   xdot(2,1) = x(1)*x(4)^2-G*M/x(1)^2 + sqrt(Q22)*randn; % dodavanje Gaussovog procesnog suma varijance Q22 u 2. varijablu stanja
   xdot(3,1) = x(4);
   xdot(4,1) = -2*x(2)*x(4)/x(1);
   x = x + xdot * dt;
   
   
   % Simuliraj mjerenje.
   z = measurementModelLinear(x);
   % dodavanje Gaussovog bijelog suma varijance R;
   z = z + chol(R) * randn(size(R,1),1);
   
      % Simuliraj filtar.
   % ovdje napisati kod odgovarajuceg  Kalmanovog filtra
   
   if strcmp(filter, 'EKF')
       A_EKF = [0 1 0 0; 2*G*M/xhat(1)^3 0 0 2*xhat(1)*xhat(4);
            0 0 0 1; 0 -2*xhat(3) 0 0];
       A_EKF = expm(A_EKF*T);
       P = A_EKF * P * A_EKF' + Q;
       xhat = A_EKF*xhat; 

       K = P*(H')/(H*P*(H') + R);
       xhat = xhat + K*(z - H*xhat);
       I4 = eye(4);
       P = (I4-K*H)*P;
       
   elseif strcmp(filter, 'LKF')
       P = A_LKF*P*A_LKF' + L*Q*L';
       xhat = A_LKF*xhat; 

       K = (P*H')/(H*P*H'+M*R*M');
       y = z - [x0(1); x0(3)];
       xhat = xhat + K*(y - H*xhat);
       P = (P-K*H*P);
       
   elseif strcmp(filter, 'IEKF')
       A_IEKF = [0 1 0 0; 2*G*M/xhat(1)^3 0 0 2*xhat(1)*xhat(4);
            0 0 0 1; 0 -2*xhat(3) 0 0];
       A_IEKF = expm(A_IEKF*T);
       P = A_IEKF * P * A_IEKF' + L*Q*L';
       
       x_ap = xhat;
       for j = 0:3
            K = P*(H')/(H*P*(H') + R);
            xhat = x_ap + K*(z - H*xhat - H*(x_ap - xhat));
            P = P - K*H*P;
       end

   else
       
       display(['Filter ' filter ' nije implementiran.' ]);
       return
       
   end
   
   % Save data for plotting.
   i = i + 1;
   if i == PlotStep
      xArray = [xArray x];
      xhatArray = [xhatArray xhat];
      i = 0;
   end
end
disp('Trace:')
tracep = trace(P);
disp(tracep);

%% Iscrtavanje
close all;
t = 0 : PlotStep*dt : tf;

figure;
err = abs(xArray(1,:) - xhatArray(1,:));
plot(t, err);
set(gca,'FontSize',12); set(gcf,'Color','White');
grid on
xlabel('[sekunde]'); ylabel('Greska estimacije radiusa [m]');

RadErrMean = mean(err);
RadErrStd = std(err);
disp(['Srednja vrijednost greske estimacije radiusa ', filter ':' num2str(RadErrMean) ' m']);
disp(['Standardna devijacija greske estimacije radiusa ', filter ':' num2str(RadErrStd) ' m']);


figure;
plot(t, xArray(1,:)); hold on
title(['Simulacija satelita -' filter], 'FontSize', 12);
set(gca,'FontSize',12); set(gcf,'Color','White');
xlabel('sekunde'); ylabel('Tocni vs. estimirani radijus');
plot(t, xhatArray(1,:), '-.');
legend('Tocni', 'Estimirani')

if ~isempty(trP)
    figure
    plot(trP), title('Trag matrice P');
    set(gca,'FontSize',12); set(gcf,'Color','White');
    grid on
    xlabel('[korak]'); ylabel('trace(P)');
end

return
%%

% modeli mjerenja u vjezbi
function z = measurementModelLinear(x)

z = [x(1); x(3)];

return    