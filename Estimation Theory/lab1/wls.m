function x_ml = wls(H, z, Sigma)
    x_ml = (inv(H.'*(inv(Sigma))*H))*H.'*inv(Sigma)*z;
end
