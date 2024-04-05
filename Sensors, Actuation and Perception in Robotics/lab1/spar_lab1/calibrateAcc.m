close all;

g = 9.81;

% CHANGE THIS TO THE LOGS VARIABLE
logs = acc_calib_logs.acc_logs;

pivot = int32((1 + length(logs)) * 0.667);

data = logs(1:pivot, :);
test = logs(pivot+1:end, :);


x0 = [1 0 0 1 0 1  0 0 0];
options = optimoptions('fmincon','PlotFcn','optimplotfvalconstr', 'MaxIterations', ...
    200, 'MaxFunctionEvaluations', 6000);

[res, fval] = fmincon(@(x)accError(x, data), x0, [],[],[],[],[],[], ...
    @(x) constraints(x),...
    options);

x = res;
A_acc = [x(1) x(2) x(3);
        x(2) x(4), x(5);
        x(3) x(5) x(6)];
b_acc = [x(7) x(8) x(9)];

corr = (test - b_acc) * A_acc';

t = (vecnorm(test')' - g);
test_error = sum(t .* t) / length(data)

t = (vecnorm(corr')' - g);
test_error_calib = sum(t .* t) / length(data)

A_acc
b_acc



function [cneq, ceq] = constraints(x)
 b = [x(7) x(8) x(9)];
 cneq = [];
 cneq(1) = abs(b(1)) - 0.3;
 cneq(2) = abs(b(2)) - 0.3;
 cneq(3) = abs(b(3)) - 0.3;
 ceq = [];
end