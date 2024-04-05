% Vehicle Dynamics and Control, FER, 2022.
% Marko Švec, Josip Kir Hromatko
%--------------------------------------------------------------------------
clear; close all; clc;
load("Vjezba1.mat")
%----Define vehicle parameters---------------------------------------------
GolfDatasheet;  % loads VEHICLE and ENVIRONMENT variables

%-----Define torque distribution between front and rear axis [0 ... 1]-----
VEHICLE.TORQUE_DIST = 1;  % torqueRatio: 0 => RWD, 1 => FWD

%----Define road condition-------------------------------------------------
ENVIRONMENT.ROAD_CONDITION = 1;  % dry=1, wet=2, ice=3 

%----Define slope of road--------------------------------------------------
ENVIRONMENT.ROAD_SLOPE = 2*pi/180;  % [rad]

%----Define initial conditions---------------------------------------------
distance = 0;                       % Initial travelled distance [m]
speed = 0.2;                        % Initial speed [m/s]
wf = (1.05*speed)/VEHICLE.WHEEL_RADIUS; % Initial rot. speed of front wheel
wr = (1.05*speed)/VEHICLE.WHEEL_RADIUS; % Initial rot. speed. of rear wheel
gear = 1;

%----Define timestep and integration time----------------------------------
t_start = 0;                    % Starting t
t_end   = 15;                   % Ending t [s]
dt      = 0.0005;               % t step [s]
t       = (t_start:dt:t_end);   % t vector

%----Preallocate arrays for speed------------------------------------------
a_vector=zeros(size(t));
v_vector=zeros(size(t));
s_vector=zeros(size(t));
slipf_vector=zeros(size(t));
slipr_vector=zeros(size(t));
wf_vector=zeros(size(t));
wr_vector=zeros(size(t));
Fzf_vector=zeros(size(t));
Fzr_vector=zeros(size(t));
wdotf_vector=zeros(size(t));
wdotr_vector=zeros(size(t));
Tdrivf_vector=zeros(size(t));
Tdrivr_vector=zeros(size(t));
gear_vector=zeros(size(t));
weng_vector=zeros(size(t));

%----Anti-slip control initialization--------------------------------------
Fzf_approx = VEHICLE.MASS * ENVIRONMENT.GRAVITY * VEHICLE.LR / VEHICLE.L;
Fzr_approx = VEHICLE.MASS * ENVIRONMENT.GRAVITY * VEHICLE.LF / VEHICLE.L;
mu_step = 0.001;
mu_vec = MagicFormula(0:mu_step:1,ENVIRONMENT.ROAD_CONDITION);
% find slip curve peak
[mu_util_max, idx_mu_max] = max(mu_vec);  
slip_opt = idx_mu_max * mu_step;
% set max. torque w.r.t. the corresponding force
Tdrivf_max = Fzf_approx * mu_util_max * VEHICLE.WHEEL_RADIUS;
Tdrivr_max = Fzr_approx * mu_util_max * VEHICLE.WHEEL_RADIUS;

%% ----Simulation of vehicle dynamics based on full throttle---------------
for i=1:length(t)
    % Calcultate slip
    slipf = WheelSlip(speed,wf,VEHICLE.WHEEL_RADIUS);
    slipr = WheelSlip(speed,wr,VEHICLE.WHEEL_RADIUS);

    % Calculate Tdriv, gear and engine speed
    [Tdrivf,Tdrivr,gear,weng] = Drivetrain(wf,wr,gear,VEHICLE);
    
    % Limit slip and torque values (ideal slip controller)
    slipf = min(slipf, slip_opt);
    slipr = min(slipr, slip_opt);
    Tdrivf = min(Tdrivf, Tdrivf_max);
    Tdrivr = min(Tdrivr, Tdrivf_max);
    
    % Simulate vehicle dynamics
    [a,wdotf,wdotr,Fzf,Fzr] = VehicleDynamics(...
            speed,Tdrivf,Tdrivr,slipf,slipr,VEHICLE,ENVIRONMENT);
    
    % Updating the distance, velocity, and rotational velocity
    distance = distance + speed*dt;
    speed = speed + a*dt;
    wf = wf + wdotf*dt;
    wr = wr + wdotr*dt;
    
    % Update drive torques and slip for anti-slip control
    Tdrivf_max = Fzf * mu_util_max * VEHICLE.WHEEL_RADIUS;
    Tdrivr_max = Fzr * mu_util_max * VEHICLE.WHEEL_RADIUS;

    % Save data for plotting
    a_vector(i)=a;
    v_vector(i)=speed;
    s_vector(i)=distance;
    slipf_vector(i)=slipf;
    slipr_vector(i)=slipr;
    wf_vector(i)=wf;
    wr_vector(i)=wr;
    Fzf_vector(i)=Fzf;
    Fzr_vector(i)=Fzr;
    wdotf_vector(i)=wdotf;
    wdotr_vector(i)=wdotr;
    Tdrivf_vector(i)=Tdrivf;
    Tdrivr_vector(i)=Tdrivr;
    gear_vector(i)=gear;
    weng_vector(i)=weng;
end

%% ----Plot the results----------------------------------------------------
PlotResults(t,a_vector,v_vector,s_vector,Tdrivf_vector,Tdrivr_vector,...
    Fzf_vector,Fzr_vector,slipf_vector, slipr_vector,gear_vector, ...
    weng_vector);

x100 = find(s_vector>=100,1);
t100 = x100*dt;
if ~isempty(t100)
    disp(['The vehicle reached the 100m mark in ',num2str(t100), ' seconds.'])
else
    disp('The vehicle did not reach the 100m mark.')
end