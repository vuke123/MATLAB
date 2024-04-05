prev_vel = 0;
prev_pos = 0; 
Ts = 1/100; 
azimuth = -83.9; % in degrees
pitch = -0.3;    
roll = -0.03;    

R = eulerToRotationMatrix(azimuth, pitch, roll);
N = size(test,1);
acc_c = zeros(N,3); 
vel = zeros(N,3);
pos = zeros(N,3);

for i= 1:size(test,1)  
    [acc_, vel, pos] = getVelocityAndPosition(test(i,:), R, prev_vel, prev_pos, Ts);
    prev_vel = vel;
    prev_pos = pos;
    acc_c(i, :)=acc_;
    vel(i, :)=vel;
    pos(i, :)=pos;
end

% Define time vector
time = (0:92) * (1/100); % Time difference between every item is 1/100 s

% Plot acceleration
figure;
subplot(3,1,1);
plot(time, acc_c(:,1), 'b', 'LineWidth', 1.5); % Plot corrected acceleration
hold on;
plot(time, vel(:,1), 'r--', 'LineWidth', 1.5); % Plot velocity as proxy for pure acceleration
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
title('X-Axis Acceleration');
legend('Corrected Acceleration', 'Pure Acceleration');

subplot(3,1,2);
plot(time, acc_c(:,2), 'b', 'LineWidth', 1.5); % Plot corrected acceleration
hold on;
plot(time, vel(:,2), 'r--', 'LineWidth', 1.5); % Plot velocity as proxy for pure acceleration
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
title('Y-Axis Acceleration');
legend('Corrected Acceleration', 'Pure Acceleration');

subplot(3,1,3);
plot(time, acc_c(:,3), 'b', 'LineWidth', 1.5); % Plot corrected acceleration
hold on;
plot(time, vel(:,3), 'r--', 'LineWidth', 1.5); % Plot velocity as proxy for pure acceleration
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
title('Z-Axis Acceleration');
legend('Corrected Acceleration', 'Pure Acceleration');

% Plot velocity
figure;
subplot(3,1,1);
plot(time, vel(:,1), 'b', 'LineWidth', 1.5); % Plot velocity
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('X-Axis Velocity');

subplot(3,1,2);
plot(time, vel(:,2), 'b', 'LineWidth', 1.5); % Plot velocity
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Y-Axis Velocity');

subplot(3,1,3);
plot(time, vel(:,3), 'b', 'LineWidth', 1.5); % Plot velocity
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Z-Axis Velocity');

% Plot position
figure;
subplot(3,1,1);
plot(time, pos(:,1), 'b', 'LineWidth', 1.5); % Plot position
xlabel('Time (s)');
ylabel('Position (m)');
title('X-Axis Position');

subplot(3,1,2);
plot(time, pos(:,2), 'b', 'LineWidth', 1.5); % Plot position
xlabel('Time (s)');
ylabel('Position (m)');
title('Y-Axis Position');

subplot(3,1,3);
plot(time, pos(:,3), 'b', 'LineWidth', 1.5); % Plot position
xlabel('Time (s)');
ylabel('Position (m)');
title('Z-Axis Position');



function R = eulerToRotationMatrix(azimuth, pitch, roll)
% Convert angles from degrees to radians
    azimuth = deg2rad(azimuth);
    pitch = deg2rad(pitch);
    roll = deg2rad(roll);
    
    % Compute sine and cosine values
    ca = cos(azimuth);
    sa = sin(azimuth);
    cp = cos(pitch);
    sp = sin(pitch);
    cr = cos(roll);
    sr = sin(roll);
    
    % Compute rotation matrix
    R = [ca*cr-sa*sp*sr, -sa*cp, ca*sr+sa*sp*cr;
         sa*cr+ca*sp*sr, ca*cp, sa*sr-ca*sp*cr;
         -cp*sr, sp, cp*cr];
end
