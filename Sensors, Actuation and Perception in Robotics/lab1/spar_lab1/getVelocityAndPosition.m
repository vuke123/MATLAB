function [acc, vel, pos] = getVelocityAndPosition(a, R, prev_vel, prev_pos, Ts)
    % From current acceleration measurement, first subtract gravity
    % acceleration which is dependent on the current orientation R. Then
    % use previous step estimates of velocity and position and calculate
    % current step acceleration, velocity and position
    % You may assume that g = 9.80665
    % <YOUR CODE GOES HERE>
    g = [0; 0; -9.80665];
    acc = a - (R * g).';
    vel = prev_vel + Ts * acc / 2;
    pos = prev_pos + Ts * vel / 2;

end

