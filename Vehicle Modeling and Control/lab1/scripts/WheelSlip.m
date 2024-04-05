function slip = WheelSlip(v,w,wheel_radius)
%----Wheel slip calculation------------------------------------------------
% inputs: wheel transl. speed, wheel rot. speed, wheel radius
% output: longitudinal wheel slip [-]
if v > 0 
    slip = (w * wheel_radius - v) / w * wheel_radius;
else 
    slip = (w * wheel_radius - v) / v;
end

end