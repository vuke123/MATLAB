close all;

logs = angle_measurement_logs;

angvel = logs.angvel_logs;
angvel = vec2frd(angvel);
orient = logs.orient_logs;

times = (1:length(angvel)) * Ts;

% TRANSFORM ORIENTATIONS

orient = [orient(:, 3), -orient(:, 2), orient(:, 1)];
q = quaternion([orned(:, 3), orned(:, 2), orned(:, 1)], 'eulerd', 'ZYX', 'frame');
R = quat2rotm(q);

angles = zeros(length(times), 3);
true_angles = zeros(length(times), 3);
for i=2:length(times)
    angles(i, :) = getAnglesFromGyro(angvel(i, :), angles(i-1, :), Ts);
    true_angles(i, :) = orient(i, :) / 180 * pi;
end

figure
plot(timeseries(angvel, times))
title('Angular velocities');

figure
plot(timeseries(angles, times))
title('Angles');

figure
plot(timeseries(true_angles, times))
title('True angles');
