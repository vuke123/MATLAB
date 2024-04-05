% % % A script which helps solving subproblem 1.a). In here you will find how
% % % to correctly use function genMeasurements in order to create the system as
% % % described in equation (3). Parameters are already defined as needed in
% % % subproblem 1.a) All you need to do is parametrically define matrix H_ti
 close all
 syms t
% % %TO-DO. Generate 3x9 matrix H_ti. This matrix can be defined parametrically
% % %with regards to parameter t, for example H_ti = [cos(t), 0; 0, sin(t)];
 HTi = [1, 0, 0, cos(t), 0, 0, sin(t), 0, 0;
     0, 1, 0, 0, cos(t), 0, 0, sin(t), 0;
       0, 0, 1, 0, 0, cos(t), 0, 0, sin(t)];
% 
 p0 = [200; 300; 300];
 d1 = [0; 200; 0];
 d2 = [100; 0; 200];
 x = [p0; d1; d2];

% Ellipse visualization
figure;
%Generates measurements without noise, i.e. covariance matrix has 0
%variance
[~, ~, z] = genMeasurements(HTi, x, linspace(0, 2*pi, 50), t, diag([0, 0, 0]));
plot3(z(1:3:end), z(2:3:end), z(3:3:end))
hold on;
%Generates measrements with noise as defined in 1.a), i.e. Sigma_ti =
%diag([4, 4, 4]). Note that Sigma_ti can also be defined parametrically,
%for example diag([t, 2*t, t])
[H, ~, z] = genMeasurements(HTi, x, linspace(0, 2*pi, 50), t, diag([4, 4, 4]));

scatter3(z(1:3:end), z(2:3:end), z(3:3:end))
xlabel('x')
ylabel('y')
zlabel('z')
title('Measured and real trajectory')
legend('Real trajectory', 'Measured trajectory')
%% 

Ns = linspace(5, 50, 10);
M = [5, 50];
N_size = length(Ns);    
CRLBValues = zeros(N_size, 1);
varEstimates = zeros(N_size, length(M));
Sigma = diag([2, 2, 2]);

for i = 1:length(Ns)
    tValues = linspace(0, 2*pi, Ns(i));
    for j = 1:length(M) 
        varEstimates(i, j) = calculateVarianceLS(HTi, x, tValues, t, M(j), Sigma);
        [H, Sigma_, ~] = genMeasurements(HTi, x, tValues, t, Sigma);
    end 
    CRLBValues(i) = trace(inv(H' * (inv(Sigma_)) * H));
end

figure; 
plot(Ns, CRLBValues, 'k-', 'LineWidth', 2);
hold on;
plot(Ns, varEstimates(:, 1), 'bs-', 'MarkerFaceColor', 'b');
hold on;
plot(Ns, varEstimates(:, 2), 'rs-', 'MarkerFaceColor', 'r');
xlabel('Number of Measurements (N)');
ylabel('Variance');
title('CRLB and Estimated Variances for Different N');
grid on;

% Create legend
legend('CRLB', 'Variance Estimation M=5', 'Variance Estimation M=50', 'Location', 'best');

%% 

N = 10; 
M = 10; 
sigmaZ = linspace(1, 5, 10); 
tValues = linspace(0, 2*pi, N); 

varEstimates = zeros(size(sigmaZ, 2), 1);
CRLBValues = zeros(size(sigmaZ, 2), 1);

for j = 1:size(sigmaZ,2)
    SigmaZ = diag([sigmaZ(j), sigmaZ(j), sigmaZ(j)]); 
    [H, Sigma, ~] = genMeasurements(HTi, x, tValues, t, SigmaZ);
    varEstimates(j) = calculateVarianceLS(HTi, x, tValues, t, M, SigmaZ);
    CRLBValues(j) = trace(pinv(H' * pinv(Sigma) * H));
end

figure;
plot(sigmaZ, CRLBValues,'LineWidth', 2); 
hold on;
plot(sigmaZ, varEstimates, 'LineWidth', 2); 
xlabel('Noise Variance (\sigma_z^2)');
ylabel('Variance');

title('Impact of Noise Variance on Estimation Precision');
legend('CRLB', 'Estimated variance', 'Location','Best');
grid on;
%% 
