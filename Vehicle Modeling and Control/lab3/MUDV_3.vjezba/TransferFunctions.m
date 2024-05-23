d_values = [100, 500, 1000, 4000, 8000, 10000];
k = 30000; 
mu = 167.5;                           
m = 1675-167.5;    

s = tf('s');

figure;
hold on;
for d = d_values
    driv_comf = (d*s^2+k*s^2)/(m*s^2+d*s+k);
    bode(driv_comf);
end
title('Bode Diagram for Drive Comfort for Different d Values');
legend('d = 100', 'd = 500', 'd = 1000', 'd = 4000', 'd = 8000', 'd = 10000');
hold off;

figure;
hold on;
for d = d_values
    amort_fat = (-m*s^2) / (m*s^2+d*s+k);
    bode(amort_fat);
end
title('Bode Diagram for Amortizer Fatigue for Different d Values');
legend('d = 100', 'd = 500', 'd = 1000', 'd = 4000', 'd = 8000', 'd = 10000');
hold off;

figure;
hold on;
for d = d_values
    wheel_adh = ((mu*d + m*d)*s^3 + (mu*k + m*k)*s^2) / (m*s^2+d*s+k);
    bode(wheel_adh);
end
title('Bode Diagram for Wheel Adherence for Different d Values');
legend('d = 100', 'd = 500', 'd = 1000', 'd = 4000', 'd = 8000', 'd = 10000');
hold off;
