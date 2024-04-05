function varMMSE = calculateVarianceMMSE(HTi, x, tValues, t, M, cov, sigmaX)
    Px = sigmaX*eye(length(x));
    xEst = zeros(M, 9);  
    for j = 1:M
        w = mvnrnd(zeros(length(x), 1), Px);
        xNoise = x + w.';
        [H, Cov, z] = genMeasurements(HTi, x, tValues, t, cov);
        xEst(j, :) = mmse(H, z, Cov, sigmaX, xNoise);
    end
    varMMSE = calculate_variance(x.', xEst, M);
    varMMSE = trace(varMMSE);
end

function var = calculate_variance(x_true, x, M)
    var = ((x-x_true).' * (x-x_true) )/ M;
end
