% Postprocessing after the simulation. Generates plots of the relevant
% vehicle states and parameters. 

% Some figure formatting
set(0,'DefaultAxesFontSize',10)
set(0,'DefaultAxesLineWidth',0.5)
set(0,'defaultlinelinewidth',0.5)

vx = x(:,1);
vy = x(:,2);
wz = x(:,3);
ax = y(:,1);
ay = y(:,2);

%% Longitudinal velocity
figure(1);
subplot(2,3,1)
plot(t,vx*3.6)
grid on;
xlabel('Time [s]')
ylabel('Longitudinal velocity [km/h]')

%% Lateral velocity
figure(1);
subplot(2,3,2);
plot(t,vy*3.6);
grid on;
xlabel('Time [s]')
ylabel('Lateral velocity [km/h]')

%% Yaw rate
figure(1)
subplot(2,3,3)
plot(t,wz*180/pi,t,delta.*vx/vehicleData.L*180/pi,'r--');
grid on;
ylabel('Yaw rate [deg/s]')
xlabel('Time [s]')
legend('Actual yaw rate', 'Neutral Steer')

%% Vehicle longitudinal acceleration
figure(1)
subplot(2,3,4)
plot(t,ax)
grid on;
xlabel('Time [s]')
ylabel('Longitudinal acceleration [m/s^2]')

%% Vehicle lateral acceleration
figure(1)
subplot(2,3,5)
plot(t,ay)
grid on;
xlabel('Time [s]')
ylabel('Lateral acceleration [m/s^2]')

%% Vehicle yaw acceleration
figure(1)
subplot(2,3,6)
plot(t,180/pi*wzDot)
grid on;
xlabel('Time [s]')
ylabel('Yaw acceleration [deg/s^2]')

%% Vehicle travel animation
figure(2);
hTrajectory = plot(X(1),Y(1)); hold on;
hTitle=title(sprintf('Time = %0.3g',t(1)));
axis equal;
xlim([min(X)-10 max(X)+100])
ylim([min(-100, min(Y)-50) max(100, max(Y)+50)])
axis manual;
grid on;
hold on;
xlabel('X [m]')
ylabel('Y [m]')

lf = vehicleData.lf*5;
lr = vehicleData.lr*5;
w  = vehicleData.w*5;

X1 =  lf*cos(psi) - w/2*sin(psi);
X2 =  lf*cos(psi) + w/2*sin(psi);
X3 = -lr*cos(psi) + w/2*sin(psi);
X4 = -lr*cos(psi) - w/2*sin(psi);

Y1 =  w/2*cos(psi) + lf*sin(psi);
Y2 = -w/2*cos(psi) + lf*sin(psi);
Y3 = -w/2*cos(psi) - lf*sin(psi);
Y4 =  w/2*cos(psi) - lf*sin(psi);

hCar = patch([X1(1,1) X2(1,1) X3(1,1) X4(1,1)], [Y1(1,1) Y2(1,1) Y3(1,1) Y4(1,1)],'red','facecolor','none','edgecolor','red');

xLimits = get(gca,'xlim');
yLimits = get(gca,'ylim');
axis manual;
xlim(xLimits)
ylim(yLimits)

for i = 1:1/(sampleTime*100):length(psi)
    set(hTrajectory,'XData',X(1:i),'YData',Y(1:i));
    set(hCar,'Xdata',X(i)+[X1(i,1) X2(i,1) X3(i,1) X4(i,1)], 'Ydata',Y(i)+[Y1(i,1) Y2(i,1) Y3(i,1) Y4(i,1)]);
    set(hTitle,'String',sprintf('Time= %0.3g',t(i)));
    drawnow;
end

hold off;
%% Vehicle path and orientation
figure(3)
hTrajectory = plot(X,Y); hold on;
axis equal;
grid on;
xlabel('X [m]')
ylabel('Y [m]')

for i = 1:1/(sampleTime):length(psi)
    patch(X(i)+[X1(i,1) X2(i,1) X3(i,1) X4(i,1)], Y(i,1)+[Y1(i,1) Y2(i,1) Y3(i,1) Y4(i,1)],'red','facecolor','none','edgecolor','red');
end
hold off;

%% Lateral and longitudinal axle forces
figure(4)
subplot(3,1,1)
plot(t,Fyw)
grid on;
xlabel('Time [s]')
ylabel('Lat. axle forces [N]')
legend('Front','Rear')

%% Axle front and rear slip angles
figure(4)
subplot(3,1,2)
plot(t,slipAngle*180/pi)
grid on;
xlabel('Time [s]')
ylabel('Axle slip angles [deg]')
legend('Front','Rear')

%% Wheel vertical forces
figure(4)
subplot(3,1,3)
plot(t,FzWheel)
grid on;
xlabel('Time [s]')
ylabel('Vertical forces [N]')
legend('Front left','Front right','Rear left','Rear right')