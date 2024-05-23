function [xhat, P, xRMSE] = Vozilo(gps_type)

% Pracenje vozila u 2D
%
% Ulazi su:
%   gps_type = tip koristenih mjerenja
%          'gps_easy' - osnovni skup mjerenja
%          'gps_hard' - prošireni skup mjerenja s velikim pogreškama

% Izlazi su:
%   Estimirano stanje xhat = [x;, y;, xdot; ydot]
%   Kovarijanca pogreske estimacije P
%   XRMSE = srednja kvadraticna pogreska estimacije lokacije vozila

%% inicijalizacija sustava

% ovdje opisati sustav u prostoru stanja: postaviti matrice Phi, Gamma, H, L, M
T = 0.1;
A = [1 0 T 0; 
     0 1 0 T;
     0 0 1 0;
     0 0 0 1]; 
B = [0; 0; 0; 0];
H = [ 1 0 0 0;
      0 1 0 0];
M = eye(2); 
L = eye(4); 

% ovdje postaviti vrijeme diskretizacije T

% ovdje postaviti matrice kovarijanci procesnog i mjernog suma Q i R
Q = eye(4); % Process noise covariance
R = eye(2); % Measurement noise covariance

w_v = (50*0.1*(1000/3600))^2; 
w_p = (T*w_v)^2;

Q(1,1) = w_p;
Q(2,2) = w_p;
Q(3,3) = w_v; 
Q(4,4) = w_v; 

RInitial = R*4;

% ucitaj odgovarajuci skup mjerenja
y = [];
if strcmp(gps_type, 'gps_easy')
    load gps_easy gps_y_easy x_gt
    y = gps_y_easy;
elseif strcmp (gps_type, 'gps_hard')
    load gps_hard gps_y_hard x_gt
    y = gps_y_hard;
else
    error(['Skup mjerenja ' gps_type ' nije definiran.' ]);
end

% inicijalizacija filtra
xhat = [y(1,1) y(1,2) 0 0].'; % estimacija inicijalnog stanja
P = eye(4); % inicijalna matrica kovarijanci pogreske estimacije
P(1:2, 1:2) = RInitial;
xhatArray = [];
PtraceArray = [];
xhatErrArray = [];

%% SIMULACIJA KALMANOVOG FILTRA
if strcmp(gps_type, 'gps_easy')
    R = RInitial;
    for k = 1 : size(y,1)
       % Ovdje napisati kod odgovarajuceg  Kalmanovog filtra
       P_ = A*P*A.'+ L*Q*L.';
       K = P_*H.'*inv((H*P_*H.' + M.'*R*M.'));
       xhat_ = A*xhat;
       xhatErr = (y(k,:)).'-(H*xhat_);
       %possible hard data option --> innovation threshold check --> increase
       %of the R matrix
       xhat = xhat_ + K*(xhatErr);
       dimension = size(K*H,1);
       P = (eye(dimension) - K*H)*P_*(eye(dimension) - K*H).' + K*R*K.';
       % Spremi podatke za iscrtavanje
       xhatArray = [xhatArray; xhat(1:2)'];
       PtraceArray = [PtraceArray; trace(P)];
       xhatErrArray = [xhatErrArray; xhatErr(1:2)'];
    end
else
    Q = Q*1.2;
    R=RInitial*1.2;
    for k = 1 : size(y,1)
       % Ovdje napisati kod odgovarajuceg  Kalmanovog filtra za KOMPLEKSNE
       % PODATKE
       P_ = A*P*A.'+ L*Q*L.';
       xhat_ = A*xhat;
       if any(isnan(y(k,:)))
        xhat = xhat_;
        P = P_;
       else
        K = P_*H.'*inv((H*P_*H.' + M.'*R*M.'));
        xhatErr = (y(k,:)).'-(H*xhat_);
        xhat = xhat_ + K*(xhatErr);
        P = (eye(size(A)) - K*H)*P_*(eye(size(A)) - K*H).' + K*R*K.';
       end
       %possible hard data option --> innovation threshold check --> increase
       %the R matrix
       
       % Spremi podatke za iscrtavanje
       xhatArray = [xhatArray; xhat(1:2)'];
       PtraceArray = [PtraceArray; trace(P)];
       xhatErrArray = [xhatErrArray; xhatErr(1:2)'];
    end
end

xRMSE = sqrt(mean(xhatErrArray.^2, 1));
if strcmp(gps_type, 'gps_hard')
    yRMSE = sqrt(mean((y - xhatArray).^2, 1));
    disp(['RMSE mjerenja lokacije vozila  ',  num2str(yRMSE) ' m']);
end
disp(['RMSE estimacije lokacije vozila  ',  num2str(xRMSE) ' m']);

%% Iscrtavanje
figure; hold on;
title('Trajektorija vozila i mjerenja senzora');
plot(xhatArray(:,1), xhatArray(:,2), 'g');
plot(x_gt(:,1), x_gt(:,2));
plot(y(:,1), y(:,2), 'xr');

figure; 
title('Trag matrice P');
plot(PtraceArray);
figure;
title('Korijen kvadrata pogreske estimacije');
plot(xhatErrArray);
