function [Tdrivf,Tdrivr,gear,engine_speed] = Drivetrain(wf,wr,gear_old,VEHICLE)
% This function finds a gear that provides highest engine torque. 
% This function knowing the wheel speed, gear ratios and final gear finds
% all possible engine speeds and corresponding engine torques (based on the 
% given engine map). Then from
% engine torques using all gears calculates all wheel torques (one for
% each gear). Then selects the highest one and corresponding gear as output.
% i.e. Tdriv (for front or rear depending on the value of 
% VEHICLE.TORQUE_DIST). Down-shifting is avoided.

speed_vec = VEHICLE.ENGINE_SPEED_VEC;
torque_vec = VEHICLE.ENGINE_TORQUE_VEC;
ratio_vec = VEHICLE.RATIO_VEC;
ratio_final = VEHICLE.RATIO_FINAL;

% Maximum engine speed
max_speed = speed_vec(end);

% Maximum torque index
[~, idx] = max(torque_vec);

% Minimum engine speed is set to speed at maximum torque
min_speed = speed_vec(idx); % Maxium torque is immediately reached when releasing clutch in 1st gear

% Determination of the driven axis
if VEHICLE.TORQUE_DIST == 0
    w_ref = wr;
elseif VEHICLE.TORQUE_DIST == 1
    w_ref = wf;
else
    w_ref = 0.5 * (wf+wr);
end

% Engine speed in all gears
speed_all_gears = ratio_final * ratio_vec * w_ref;

% Set minimum engine speed in all gears
speed_all_gears = max(speed_all_gears, min_speed);

% Calculate drive torque in all gears
torque_all_gears = interp1(speed_vec,torque_vec,speed_all_gears);
Tdriv_all_gears = ratio_final * ratio_vec .* torque_all_gears;

% Limit drive torque to maximum engine speed
for i=1:length(Tdriv_all_gears)
    if (speed_all_gears(i) > max_speed)
        Tdriv_all_gears(i) = 0;     
    end
end

% Check to avoid down shifting
[~,gear] = max(Tdriv_all_gears);            % Max Tdriv and corresponding gear
gear = max(gear, gear_old);                 % Select higher gear or use previous gear
Tdriv = Tdriv_all_gears(gear);              % Set drive torque for selected gear
Tdrivf = VEHICLE.TORQUE_DIST * Tdriv;       % Set drive torque for front axis
Tdrivr = (1-VEHICLE.TORQUE_DIST) * Tdriv;   % Set drive torque for rear axis
engine_speed = speed_all_gears(gear);       % Set engine speed for selected gear

end