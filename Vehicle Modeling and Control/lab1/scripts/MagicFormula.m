function mu = MagicFormula(slip,road_cond)
%----MAGIC TYRE formula----------------------------------------------------
% inputs: slip [-], road condition (1-dry, 2-wet, 3-ice)
% output: normalized longitudinal tyre force [-]
% NOTE: the function should work with both scalar and vector inputs
PacejkaGearModel;
mu = D_cond(road_cond)*sin(C_cond(road_cond)*atan(B*slip - E_cond(road_cond)* ...
    (B*slip - atan(B*slip))));

end

