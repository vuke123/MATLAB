load('measurementsNoisy100.mat');
X_hom = [X(1:2,:);X(4,:)];
xs = zeros(size(x1,1), size(x1,2), 3);
xs(:,:,1) = x1;
xs(:,:,2) = x2;
xs(:,:,3) = x3;
N = [];

for i = 1:3
    M = [];
    x2d = xs(:,:,i);
    for j = 1:size(X, 2)
        u = x2d(1, j);
        v = x2d(2, j);
        x = X_hom(1,j); 
        y = X_hom(2,j); 
        z = X_hom(3,j); 
        M = [M; [-x,-y,-z, 0, 0, 0, x*u,y*u, u]; 
            [0, 0, 0, -x, -y, -z, x*v,y*v, v]];
    end
    [U,S,V] = svd(M); 
    h = V(:, size(V, 2)); 
    
    H = [h(1) h(2) h(3);  
     h(4) h(5) h(6); 
     h(7) h(8) h(9)];
   
    disp(['H', num2str(i), ':'])
    disp(H)

    N = [N; H(1,1)*H(1,2), H(2,1)*H(1,2) + H(1,1)*H(2,2), H(3,1)*H(1,2) + H(1,1)*H(3,2), H(2,1)*H(2,2), H(3,1)*H(2,2) + H(2,1)*H(3,2), H(3,1)*H(3,2)];  % h11^T * B * h12 = 0
    N = [N; H(1,1)^2 - H(1,2)^2,...
        2*(H(1,1)*H(2,1) - H(1,2)*H(2,2)), ...
        2*(H(1,1)*H(3,1) - H(1,2)*H(3,2)), ...
        H(2,1)^2 - H(2,2)^2, ...
        2*(H(2,1)*H(3,1) - H(2,2)*H(3,2)), ...
        H(3,1)^2 - H(3,2)^2];  % h11^T * B * h11 - h12^T * B * h12 = 0  
end

disp('N:')
disp(N);

[U_N, S_N, V_N] = svd(N);

b = V_N(:, size(V_N,2));
B = [b(1), b(2), b(3); b(2), b(4), b(5); b(3), b(5), b(6)];
disp('B:')
disp(B);

B_scaled = B / b(6);
A = chol(B_scaled);
K = inv(A).';
K = K / K(3,3);
disp('K:')
disp(K);

R = inv(K)*H;
v = inv(K)*H(:,1);
lambda = 1 / dot(v,v);
t = lambda*h3;  

if det(R) < 0
    R = -R;  
end

disp('Rotacijska matrica R:');
disp(R);
disp('Vektor translacije t:');
disp(t);

disp('[R|t]:');
disp([R, t]);

projection = K * (R * X_hom) / lambda;
projection = projection / projection(2,:);
x1 = x1 / x1(2,:);
errors = x1 - projection;
reprojection_error = sum(abs(errors(1:2,:))); 

fprintf('Ukupna reprojekcijska pogreška: %.2f\n', reprojection_error);

