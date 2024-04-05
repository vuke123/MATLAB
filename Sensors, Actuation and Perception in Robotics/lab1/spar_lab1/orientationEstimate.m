close all;

use_mag_calibration = 0;
Ts = 0.02;

pp = poseplot(eye(3), [0,2,0], ScaleFactor=0.5);
hold on;
pp3 = poseplot(eye(3), [0,0,0], ScaleFactor=0.5);
pp2 = poseplot(eye(3), [0,4,0], ScaleFactor=0.5);
title("Out-of-the-box measurements");
xlabel('X'); ylabel('Y'); zlabel('Z');

for i=1:10000000
    acc = m.Acceleration;
    acc = vec2frd(acc); 
    [roll, pitch] = getRollPichFromAcceleration(acc);
    
    or = m.Orientation;
    orned = [or(:,3), -or(:,2), or(:,1)];
    
    mag = m.MagneticField;
    mag = vec2frd(mag);
    if use_mag_calibration
        mag = (mag - b) * A;
    end
    heading =  rad2deg(getHeadingFromMag(mag, roll, pitch));

    headingf = rad2deg(atan2(-mag(2), mag(1)));


    
    % [rad2deg(roll), rad2deg(pitch), headingh]
    
    qa = quaternion([deg2rad(heading), pitch, roll], 'euler', 'ZYX', 'frame');
    qa2 = quaternion([orned(3), orned(2), orned(1)], 'eulerd', 'ZYX', 'frame');
    qa3 = quaternion([deg2rad(headingf), pitch, roll], 'euler', 'ZYX', 'frame');
    set(pp, "Orientation", qa);
    set(pp2, "Orientation", qa2);
    set(pp3, "Orientation", qa3);
    legend("Roll-pitch komp.", "Bez roll-pitch komp.", "AHRS telefona");
    drawnow limitrate
end