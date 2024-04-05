Ts = 0.01;

%m = mobiledev;
%m.AccelerationSensorEnabled = true;
%m.Logging = true;

%struct_name = 'acc_calib_logs';
struct_name = 'distance_measurement_logs';
% struct_name = 'angle_measurement_logs';

% MAKE SURE THAT ALL SENSORS ARE TURNED ON 
% ON YOUR MOBILE PHONE. IF NOT, SET THE APPROPRIATE
% FLAG TO ZERO

stream_acc = 1;
stream_angvel = 1;
stream_orient = 1;
stream_magfield = 1;

logs = struct;
min_len = 1000000000000000;
if stream_acc 
    logs.acc_logs = m.accellog;
    min_len = min([min_len, length(logs.acc_logs)]);
end

if stream_angvel 
    logs.angvel_logs = m.angvellog;
    min_len = min([min_len, length(logs.angvel_logs)]);
end

if stream_orient 
    logs.orient_logs = m.orientlog;
    min_len = min([min_len, length(logs.orient_logs)]);
end

if stream_magfield 
    logs.magfield_logs = m.magfieldlog;
    min_len = min([min_len, length(logs.magfield_logs)]);
end


% CLIP MEASUREMENTS
if stream_acc 
    logs.acc_logs = logs.acc_logs(1:min_len, :);
end

if stream_angvel 
    logs.angvel_logs = logs.angvel_logs(1:min_len, :);
end

if stream_orient 
    logs.orient_logs = logs.orient_logs(1:min_len, :);
end
if stream_magfield 
    logs.magfield_logs = logs.magfield_logs(1:min_len, :);
end


% logs.mag_logs = m.magfieldlog;

eval([struct_name, ' = logs']);
