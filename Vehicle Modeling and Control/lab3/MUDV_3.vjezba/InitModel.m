%% Data for the simulation.
% Data corresponds to Saab 9-3.
clear;clc;close all

% Vehicle data
sampleTime                  = 1e-2;                             % Sample time for data output, s
vehicleData.m               = 1675;                             % Total mass, kg
vehicleData.mu              = 167.5;                            % Unsprung mass, kg
vehicleData.ms              = vehicleData.m-vehicleData.mu;     % Sprung mass, kg
vehicleData.J               = 2617;                             % Vehicle inertia about Z axis, kgm^2
vehicleData.L               = 2.675;                            % Wheelbase, m
vehicleData.c0              = 30.7;                             % Tyre stiffness parameter, 1/rad
vehicleData.c1              = -0.00235;                         % Tyre stiffness parameter, 1/(Nrad)
vehicleData.steeringRatio   = 15.9;                             % Steering ratio, -
vehicleData.h               = 0.543;                            % Height of CoG, m
vehicleData.hrcf            = 0.045;                            % Front roll center height, m
vehicleData.hrcr            = 0.101;                            % Rear roll center height, m
vehicleData.cw              = 7e4;                              % Total roll stiffness, Nm/rad
vehicleData.w               = 1.51;                             % Track width, m
vehicleData.g               = 9.81;                             % Acceleration due to gravity, m/s^2
vehicleData.R               = 0.3;                              % Wheel radius, m
vehicleData.k               = 30000;                            % Suspension stiffness, N/m
vehicleData.d               = 4000;                             % Suspension damping, N/(m/s)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PARAMETERS TO BE CHANGED IN DIFFERENT TASKS:
vehicleData.lf              = 0.37*vehicleData.L;               % Distance of CoG from front axle
vehicleData.lr              = vehicleData.L-vehicleData.lf;     % Distance of CoG from rear axle 
simulationTime              = 10;                               % Simulation time, s
vx0                         = 100;                              % Initial speed, km/h
SWA                         = 16.9;                               % Steering wheel angle, deg
brakeForceDemand            = 4000;                              % Demanded braking force, N
vehicleData.distRatio       = 0.2;                              % Brake distribution ratio, front/total
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%