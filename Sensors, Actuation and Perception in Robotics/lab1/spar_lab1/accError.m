function err = accError(x, inputs)
% Given the vector of parameters x = [x1, x2, x3, x4, x5, x6, x7, x8, x9]
% and the list of acceleration measurements, calculate the mean squared
% error of the sensor model and gravity acceleration constant. You may
%inputs = Nx3
    
    g = 9.80665;
    A = [x(1), x(2), x(3);
         x(2), x(4), x(5);
         x(3), x(5), x(6)];
    b = [x(7), x(8), x(9)];
    
    N = length(inputs(:,1));
    acc_c = A*((inputs-b).');
    acc_c = acc_c.';
    err = sum((norm(acc_c) - g)^2) / N;

end
