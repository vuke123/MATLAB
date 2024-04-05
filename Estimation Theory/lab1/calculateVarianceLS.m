function varEst = calculateVarianceLS(HTi, x, tValues, t, M, Sigma_)
    xEstimates = zeros(length(x), M); 
    for i = 1:M
        [H, ~, z] = genMeasurements(HTi, x, tValues, t, Sigma_);
        xEst = lsEstimator(H, z);
        xEstimates(:, i) = xEst;
    end
    varEst = trace(calculate_variance(x, xEstimates, M)); %unbiased and variance calculated from rows
end
function var = calculate_variance(x_true, x, M)
    var = ((x-x_true).' * (x-x_true) )/ M;
end

function xEst = lsEstimator(H, z)
    xEst = pinv(H)*z;
end

