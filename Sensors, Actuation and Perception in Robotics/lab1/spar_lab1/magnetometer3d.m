close all;
x = m.magfieldlog;
x = [x(:,2), x(:,1), -x(:,3)];

[A, b, expMFS] = magcal(x);
xc = (x - b) * A';

de = HelperDrawEllipsoid;
de.plotCalibrated(A,b,expMFS,x,xc, 'Auto');

figure;
scatter3(x(:,1), x(:,2), x(:,3));
hold on; grid on;
scatter3(xc(:,1), xc(:,2), xc(:,3));
axis equal
title('Magnetometer before and after calibration.');
legend("Uncalibrated", "Hard-iron calibration");

N = length(x);
r = sum(xc.^2,2) - expMFS.^2;
E = sqrt(r.'*r./N)./(2*expMFS.^2);
fprintf('Residual error in corrected data : %.2f\n\n',E);

figure;
plot(rad2deg(-atan2(x(:,2), x(:,1))));
hold on;
grid on;
plot(rad2deg(-atan2(xc(:,2),xc(:,1))))
title("Yaw before and after calibration.");
legend("Uncalibrated", "Hard-iron calibration");

A
b


