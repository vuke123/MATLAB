close all;

g = 9.81;
logs = distance_measurement_logs;
pivotTime = 14.76;

use_acc_calib = 1;

acc = logs.acc_logs;
% acc = vec2frd(acc);
orient = logs.orient_logs;
angvel = logs.angvel_logs;
angvel = vec2frd(angvel);



pivot = int32(pivotTime / Ts);
calib_data = acc(1:pivot, :);
acc_data = acc(pivot+1:end, :);
angvel_data = angvel(pivot+1:end, :);
orient_data = orient(pivot+1:end, :);

times = (1:length(acc_data)) * Ts;


%CALIBRATE ACCELERATION

if use_acc_calib

    x0 = [1 0 0 1 0 1  0 0 0];
    options = optimoptions('fmincon','PlotFcn','optimplotfvalconstr', 'MaxIterations', ...
        2000, 'MaxFunctionEvaluations', 6000);
    
    
    
    [res, fval] = fmincon(@(x)accError(x, calib_data), x0, [],[],[],[],[],[], ...
        @(x) constraints(x),...
        options);
    
    x = res;
    A_acc = [x(1) x(2) x(3);
            x(2) x(4), x(5);
            x(3) x(5) x(6)];
    b_acc = [x(7) x(8) x(9)];
    
    A_acc
    b_acc
end

% TRANSFORM ORIENTATIONS

orned = [orient_data(:, 3), -orient_data(:, 2), orient_data(:, 1)];
q = quaternion([orned(:, 3), orned(:, 2), orned(:, 1)], 'eulerd', 'ZYX', 'frame');
R = quat2rotm(q);


% CORRECT ACCELERATIONS AND REMOVE GRAVITY

corr = zeros(length(q), 3);
vel = zeros(length(times), 3);
p = zeros(length(times), 3);
angles = zeros(length(times), 3);
for i=2:length(times)
    a = acc_data(i, :);
    R = quat2rotm(q(i));
    g_t = - R' * [0 0 g]';
    if use_acc_calib
        a = (a - b_acc) * A_acc' ;
    end

    [cor, v, pos] = getVelocityAndPosition(a, R, vel(i-1, :), p(i-1, :), Ts);
    
    corr(i, :) = cor;
    vel(i, :) = v;
    p(i, :) = pos;
    angles(i, :) = angles(i-1, :) + angvel_data(i, :) * Ts;
end

figure;
plot(timeseries(corr, times))
title('Linear accelerations');

figure;
plot(timeseries(vel, times))
title('Linear velocities');

figure;
plot(timeseries(p, times))
title('Positions');

figure
plot(timeseries(angvel_data, times))
title('Angular velocities');

figure
plot(timeseries(angles, times))
title('Angles');


function [cneq, ceq] = constraints(x)
 A = [x(1) x(2) x(3) x(4) x(5) x(6)];
 b = [x(7) x(8) x(9)];
 cneq = [];
 cneq(1) = abs(b(1)) - 0.3;
 cneq(2) = abs(b(2)) - 0.3;
 cneq(3) = abs(b(3)) - 0.3;
 cneq(4) = abs(A(1) - 1) - 1; 
 cneq(5) = abs(A(2)) - 0.5;
 cneq(6) = abs(A(3)) - 0.5;
 cneq(7) = abs(A(4) - 1) - 0.1;
 cneq(8) = abs(A(5)) - 0.5;
 cneq(9) = abs(A(6) - 1) - 1;
 ceq = [];
end