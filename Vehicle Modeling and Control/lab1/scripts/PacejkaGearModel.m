% Parameters of Pacejka model
load("Vjezba1.mat");
D_cond = [1, 0.6, 0.1];  
C_cond = [1.45, 1.35, 1.50];   
E_cond = [-4.0, -0.2, 0.8];
conditions = {"Dry", "Wet", "Ice"};

K = 3*pi/180;

Fxz = zeros(length(D_cond), length(sx));

for j = 1:length(D_cond)
    B = 100*atan(K)/(C_cond(j)*D_cond(j));
    for i = 1:length(sx)
        sx_val = sx(i);
        F = D_cond(j)*sin(C_cond(j)*atan(B*sx_val - E_cond(j)*(B*sx_val - atan(B*sx_val))));
        Fxz(j, i) = F;
    end
end

figure;
hold on;
for j = 1:length(D_cond)
    plot(sx, Fxz(j, :), 'DisplayName', sprintf('conditions = %s', conditions{j}));
end
hold off;
title('Tire force for different sliding parameters');
xlabel('sx');
ylabel('Fxz');
legend(conditions);
grid on;

D = 1;
C = 1.45;
E = -4;
fun = D*sin(C*atan((100*atan(K)/(C*D))*sx - E*((100*atan(K)/(C*D))*sx - atan((100*atan(K)/(C*D))*sx))));
figure; 
hold on; 
plot(sx, fun)

load('Vjezba1.mat');

sx = linspace(0, 1, 20);

D = optimvar('D',1);
C = optimvar('C',1);
E = optimvar('E',1);
fun = D*sin(C*atan((100*atan(K)/(C*D))*sx - E*((100*atan(K)/(C*D))*sx - atan((100*atan(K)/(C*D))*sx))));

obj = sum((fun - F_norm).^2);
lsqproblem = optimproblem("Objective",obj);
x0.D = 1;
x0.C = 1.45;
x0.E = -4;

show(lsqproblem);

[sol,fval] = solve(lsqproblem,x0);
disp(sol.D)
disp(sol.C)
disp(sol.E)

