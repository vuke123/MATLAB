function PlotResults(t,a_vector,v_vector,s_vector,Tdrivf_vector,...
    Tdrivr_vector,Fzf_vector,Fzr_vector,slipf_vector,slipr_vector,...
    gear_vector,w_eng_vector)

% Distance, speed, acceleration, engine speed, gear
figure('Position', [415, 390, 560, 420])   
subplot(3,1,1)
plot(t,s_vector);
ylabel('Dist. [m]');
grid on
axFig1 = gca;
set(axFig1,'YColor','b');

subplot(3,1,2)
yyaxis left; plot(t,v_vector*3.6); ylabel('Speed [km/h]')
hold on
yyaxis right; plot(t,a_vector); ylabel('Acc. [m/s^2]');
grid on;
legend('Speed','Acceleration','Location','SouthEast')

subplot(3,1,3)
yyaxis left; plot(t,w_eng_vector); ylabel('Engine speed [rad/s]');
hold on
yyaxis right; plot(t,gear_vector); ylabel('Gear [-]');
grid on;
legend('Engine speed','Gear','Location','SouthEast')
xlabel('Time [s]');

% Force, torque, slip
figure('Position', [991, 389, 560, 420])   
subplot(3,1,1)
plot(t,Fzf_vector/1000,'r');
hold on
plot(t,Fzr_vector/1000,'g');
grid on
legend('front','rear');
ylabel('Fzf, Fzr [kN]');

subplot(3,1,2);
plot(t,Tdrivf_vector/1000,'r');
hold on;
plot(t,Tdrivr_vector/1000,'g');
grid on;
legend('front','rear');
ylabel('Tf, Tr [kNm]');

subplot(3,1,3)
plot(t,slipf_vector,'r');
hold on;
plot(t,slipr_vector,'g');
grid on;
legend('front','rear');
ylabel('Slip\_f, Slip\_r');
xlabel('Time [s]');
maxSlip = max([slipf_vector,slipr_vector]);
slipUpperBound = 1.05*maxSlip;
axis([min(t) max(t) 0 slipUpperBound])

end