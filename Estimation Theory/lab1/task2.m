% A script which helps solving subproblem 1.a). In here you will find how
% to correctly use function genMeasurements in order to create the system as
% described in equation (3). Parameters are already defined as needed in
% subproblem 1.a) All you need to do is parametrically define matrix H_ti
close all
syms t

%TO-DO. Generate 3x9 matrix H_ti. This matrix can be defined parametrically
%with regards to parameter t, for example H_ti = [cos(t), 0; 0, sin(t)];
HTi = [1, 0, 0, cos(t), 0, 0, sin(t), 0, 0;
       0, 1, 0, 0, cos(t), 0, 0, sin(t), 0;
       0, 0, 1, 0, 0, cos(t), 0, 0, sin(t)];

p0 = [200; 300; 300];
d1 = [0; 200; 0];
d2 = [100; 0; 200];
x = [p0; d1; d2];
cov = diag([exp(t), exp(t), exp(t)]);
N = linspace(5, 50, 10);

M = 20;
N_size = length(N);
CRLBValues = zeros(N_size,1);
varianceEstimation = zeros(N_size,1);

for i = 1:length(N)
    tValues = linspace(0, 2*pi, N(i));
    varianceEstimation(i) = calculateVarianceLS(HTi, x, tValues, t, M, cov);
    [H, Sigma_, ~] = genMeasurements(HTi, x, tValues, t, cov);
    CRLBValues(i) = trace(pinv(H' * (pinv(Sigma_)) * H));
end

figure; 
plot(N, CRLBValues, 'k-', 'LineWidth', 2);
hold on;
plot(N, varianceEstimation, 'bs-', 'MarkerFaceColor', 'b');
xlabel('Number of Measurements (N)');
ylabel('Variance/CRLB');
legend('CRLB', 'Variance Estimation M=20', 'Location', 'best');
title('CRLB and Estimated Variances for Different N');
grid on;


N = linspace(5, 50, 10);
M = 20;
N_size = length(N);
CRLBValues = zeros(N_size,1);
varianceEstimation = zeros(N_size,1);

for i = 1:length(N)
    tValues = linspace(0, 2*pi, N(i));
    varianceEstimation(i) = calculateVarianceWSL(HTi, x, tValues, t, M, cov);
    [H, Sigma_, ~] = genMeasurements(HTi, x, tValues, t, cov);
    CRLBValues(i) = trace(pinv(H' * (pinv(Sigma_)) * H));
end

figure; 
plot(N, CRLBValues, 'k-', 'LineWidth', 2);
hold on;
plot(N, varianceEstimation, 'bs-', 'MarkerFaceColor', 'b');
xlabel('Number of Measurements (N)');
ylabel('Variance/CRLB');
legend('CRLB', 'Variance Estimation M=20', 'Location', 'best');
title('CRLB and Estimated Variances for Different N');
grid on;
% 




