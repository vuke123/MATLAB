function [H, Sigma, z] = genMeasurements(H_ti, x, values, t, Sigma_ti)
%GENMEASUREMENTS Generates measurements and appropriate matrices given in equation (3) of task 1

%Function inputs are: H_ti as in equation (2). This is a parametrically defined linear system matrix FOR A SINGLE MEASUREMENT which can depend on parameter t.
%                     Sigma_ti as in equation (2): Parametrically defined normal distribution covariance matrix FOR A SINGLE MEASUREMENT.
%                     t: Symbolic matlab variable which can be defined with function syms
%                     values: Vector of values [t1, ..., tN] for N measurements. 
%                     x: Parameter vector being estimated
%
%Function outputs are: z, H, and Sigma as defined in (3)
rows = size(H_ti, 1);
cols = size(H_ti, 2);
N = length(values);
H = zeros(N * rows, cols);
Sigma = zeros(N * rows, N * rows);

for i=1:length(values)
   H(rows*(i-1)+1:rows*(i), 1:cols) = subs(H_ti, t, values(i));
   Sigma(rows*(i-1)+1:rows*(i), rows*(i-1)+1:rows*(i)) = subs(Sigma_ti, t, values(i));
end

%C_w_stacked = diag(repmat(diag(C_w), N, 1));
w = mvnrnd(zeros(1, N*rows), Sigma);
z = H * x + w.';
end

