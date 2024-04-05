function xEst = mmse(H, z, Cov, sigmaX, xApriori)
    n = size(H, 2);
    Px = (sigmaX*sigmaX)*(eye(n));
    PEst = inv(H.'*(inv(Cov))*H + inv(Px));
    xEst = xApriori + (PEst)*H.'*(inv(Cov))*(z-H*xApriori);
end
