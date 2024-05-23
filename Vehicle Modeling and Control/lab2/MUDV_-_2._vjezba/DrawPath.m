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

vxLin = xLin(:,1);
vyLin = xLin(:,2);
wzLin = xLin(:,3);
axLin = yLin(:,1);
ayLin = yLin(:,2); 

%% Longitudinal velocity
figure(1);
subplot(2,3,1)
plot(t,vx*3.6, t,vxLin*3.6,'--')
grid on;
xlabel('Time [s]')
ylabel('Longitudinal velocity [km/h]')
legend('Nonlinear','Linear')

%% Lateral velocity
figure(1);
subplot(2,3,2);
plot(t,vy*3.6, t,vyLin*3.6,'--');
grid on;
xlabel('Time [s]')
ylabel('Lateral velocity [km/h]')
legend('Nonlinear','Linear')

%% Yaw rate
figure(1)
subplot(2,3,3)
plot(t,wz*180/pi,t,wzLin*180/pi,'--',t,delta.*vx/vehicleData.L*180/pi,'r--');
grid on;
ylabel('Yaw rate [deg/s]')
xlabel('Time [s]')
legend('Actual nonlinear','Actual linear', 'Neutral Steer')

%% Vehicle longitudinal acceleration
figure(1)
subplot(2,3,4)
plot(t,ax, t, axLin,'--')
grid on;
xlabel('Time [s]')
ylabel('Longitudinal acceleration [m/s^2]')
legend('Nonlinear','Linear')

%% Vehicle lateral acceleration
figure(1)
subplot(2,3,5)
plot(t,ay, t, ayLin,'--')
grid on;
xlabel('Time [s]')
ylabel('Lateral acceleration [m/s^2]')
legend('Nonlinear','Linear')

%% Vehicle yaw acceleration
figure(1)
subplot(2,3,6)
plot(t,180/pi*wzDot, t,180/pi*wzDotLin,'--')
grid on;
xlabel('Time [s]')
ylabel('Yaw acceleration [deg/s^2]')
legend('Nonlinear','Linear')

%% Vehicle travel animation
figure(2);
hTrajectory = plot(X(1),Y(1),'DisplayName','Nonlinear'); hold on;
hTrajectoryLin = plot(XLin(1),YLin(1),'--','DisplayName','Linear');
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

psiVect = [psi, psiLin];

X1 =  lf*cos(psiVect) - w/2*sin(psiVect);
X2 =  lf*cos(psiVect) + w/2*sin(psiVect);
X3 = -lr*cos(psiVect) + w/2*sin(psiVect);
X4 = -lr*cos(psiVect) - w/2*sin(psiVect);

Y1 =  w/2*cos(psiVect) + lf*sin(psiVect);
Y2 = -w/2*cos(psiVect) + lf*sin(psiVect);
Y3 = -w/2*cos(psiVect) - lf*sin(psiVect);
Y4 =  w/2*cos(psiVect) - lf*sin(psiVect);

hCar = patch([X1(1,1) X2(1,1) X3(1,1) X4(1,1)], [Y1(1,1) Y2(1,1) Y3(1,1) Y4(1,1)],'red','facecolor','none','edgecolor','red');
hCarLin = patch([X1(1,2) X2(1,2) X3(1,2) X4(1,2)], [Y1(1,2) Y2(1,2) Y3(1,2) Y4(1,2)],[0.4660 0.6740 0.1880],'facecolor','none','edgecolor',[0.4660 0.6740 0.1880]);

xLimits = get(gca,'xlim');
yLimits = get(gca,'ylim');
axis manual;
xlim(xLimits)
ylim(yLimits)

for i = 1:1/(sampleTime*100):length(psi)
    set(hTrajectory,'XData',X(1:i),'YData',Y(1:i));
    set(hCar,'Xdata',X(i)+[X1(i,1) X2(i,1) X3(i,1) X4(i,1)], 'Ydata',Y(i)+[Y1(i,1) Y2(i,1) Y3(i,1) Y4(i,1)]);
    set(hTrajectoryLin,'XData',XLin(1:i),'YData',YLin(1:i));
    set(hCarLin,'Xdata',XLin(i)+[X1(i,2) X2(i,2) X3(i,2) X4(i,2)], 'Ydata',YLin(i)+[Y1(i,2) Y2(i,2) Y3(i,2) Y4(i,2)]);
    set(hTitle,'String',sprintf('Time= %0.3g',t(i)));
    drawnow;
end

hold off;
legend([hTrajectory hTrajectoryLin]);
%% Vehicle path and orientation
figure(3)
hTrajectory = plot(X,Y,'DisplayName','Nonlinear'); hold on;
hTrajectoryLin = plot(XLin,YLin,'--','DisplayName','Linear');
axis equal;
grid on;
xlabel('X [m]')
ylabel('Y [m]')
legend('Nonlinear','Linear')

for i = 1:1/(sampleTime):length(psi)
    patch(X(i)+[X1(i,1) X2(i,1) X3(i,1) X4(i,1)], Y(i,1)+[Y1(i,1) Y2(i,1) Y3(i,1) Y4(i,1)],'red','facecolor','none','edgecolor','red');
    patch(XLin(i)+[X1(i,2) X2(i,2) X3(i,2) X4(i,2)], YLin(i)+[Y1(i,2) Y2(i,2) Y3(i,2) Y4(i,2)],[0.4660 0.6740 0.1880],'facecolor','none','edgecolor',[0.4660 0.6740 0.1880]);
end

hold off;
legend([hTrajectory,hTrajectoryLin]);

%% Lateral and longitudinal axle forces
figure(4)
subplot(2,1,1)
plot(t,Fyw,t,FywLin,'--')
grid on;
xlabel('Time [s]')
ylabel('Long. and lat. axle forces [N]')
legend('Nonlinear front','Nonlinear rear','Linear front','Linear rear')

%% Axle front and rear slip angles
figure(4)
subplot(2,1,2)
plot(t,slipAngle*180/pi,t,slipAngleLin*180/pi,'--')
grid on;
xlabel('Time [s]')
ylabel('Axle slip angles [deg]')
legend('Nonlinear front','Nonlinear rear','Linear front','Linear rear')

%% 