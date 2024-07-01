clear all;
%bdclose all; %Close all Simulink windows when running this script
global ROOT;

% Define the structure
VelocityKalman = struct( 'prev_v', 0, 'P', [0, 0; 0, 0]);

% Assign the structure to the base workspace
assignin('base', 'VelocityKalman', VelocityKalman);

% Load VH and VW structures into base workspace
load('VehicleParameters.mat');

modelName = 'MUDV_projekt_R2020a1_2506_beta_version.slx';
open_system(modelName);
%set_param(modelName, 'SimulationCommand', 'start');