sigmaX = linspace(0.01, 5, 40); %sigmaX = 2
cov = diag([2,2,2]);
%covTi = diag([sigmaZ, sigmaZ, sigmaZ]);
N = 10;
M = 50;

varianceEstimatorLS = zeros(size(sigmaX,2),1);
varianceEstimatorMMSE = zeros(size(sigmaX,2),1);

for i = 1:size(sigmaX,2)
    tValues = linspace(0, 2*pi, N);
    varianceEstimatorMMSE(i) = calculateVarianceMMSE(HTi, x, tValues, t, M, cov, sigmaX(i));
    varianceEstimatorLS(i) = calculateVarianceLS(HTi, x, tValues, t, M, cov);
end

figure; 
plot(sigmaX, varianceEstimatorLS, 'k-', 'LineWidth', 2);
hold on;
plot(sigmaX, varianceEstimatorMMSE, 'bs-', 'MarkerFaceColor', 'b');
xlabel('Sigma X');
ylabel('Variance');
legend('LS', 'MMSE', 'Location', 'best');
title('Comparing variances of two estimators');
grid on;

%%
sigmaZ = linspace(0.01, 10, 20);
sigmaX = 2;
N = 10;
M = 50;

varianceEstimatorLS = zeros(size(sigmaZ,2),1);
varianceEstimatorMMSE = zeros(size(sigmaZ,2),1);

for i = 1:size(sigmaZ,2)
    tValues = linspace(0, 2*pi, N);
    cov = diag([sigmaZ(i), sigmaZ(i), sigmaZ(i)]); 
    varianceEstimatorMMSE(i) = calculateVarianceMMSE(HTi, x, tValues, t, M, cov, sigmaX);
    varianceEstimatorLS(i) = calculateVarianceLS(HTi, x, tValues, t, M, cov);
end

figure; 
plot(sigmaZ, varianceEstimatorLS, 'k-', 'LineWidth', 2);
hold on;
plot(sigmaZ, varianceEstimatorMMSE, 'bs-', 'MarkerFaceColor', 'b');
xlabel('Sigma Z');
ylabel('Variance');
legend('LS', 'MMSE', 'Location', 'best');
title('Comparing variances of two estimators');
grid on;