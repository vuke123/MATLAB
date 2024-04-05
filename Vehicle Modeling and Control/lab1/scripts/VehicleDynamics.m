function  [vDot,omegaDotf,omegaDotr,Fzf,Fzr]=...
    VehicleDynamics(v,Tdrivf,Tdrivr,slipf,slipr,VEHICLE,ENVIRONMENT)
%----Vehicle dynamics calculation------------------------------------------
% inputs: vehicle speed, drive torque and slip for each wheel, vehicle and
%         environment parameters
% outputs: vehicle acceleration, rot. acceleration of each wheel, normal
%          force on each axle
% Write the explicit solutions here

r = VEHICLE.WHEEL_RADIUS;
m = VEHICLE.MASS; 
lr = VEHICLE.LR;
lf = VEHICLE.LF;
g = ENVIRONMENT.GRAVITY;
inertia = VEHICLE.WHEEL_INERTIA;
tireFirmCoef = 0.8; 

VEHICLE.AERO_RESISTANCE = 0.35;

angleDegrees = 5;
angleRadians = deg2rad(angleDegrees);

Faero = 0.5*ENVIRONMENT.AIR_DENSITY*VEHICLE.FRONT_AREA*VEHICLE.AERO_RESISTANCE*((v)^2);

Fxf = tireFirmCoef*slipf;
Fxr = tireFirmCoef*slipr;

vDot = (Fxf + Fxr - Faero - VEHICLE.MASS*ENVIRONMENT.GRAVITY*sin(angleRadians))/VEHICLE.MASS; %II. law of mechanics

Fzr = (m*g*lf*cos(angleDegrees) + ...
    Faero*VEHICLE.COG_HEIGHT + ...
    m*vDot*VEHICLE.COG_HEIGHT + m*g*VEHICLE.COG_HEIGHT*sin(angleDegrees)) / (lf+lr); %normal force rear wheel

Fzf = (m*g*lr*cos(angleDegrees) + ...
    Faero*VEHICLE.COG_HEIGHT + ...
    m*vDot*VEHICLE.COG_HEIGHT + m*g*VEHICLE.COG_HEIGHT*sin(angleDegrees)) / (lf+lr); %normal force front wheel

Trrr = VEHICLE.ROLL_RESIST_COEFF*VEHICLE.WHEEL_RADIUS*Fzr; %rolling resistance
Trrf = VEHICLE.ROLL_RESIST_COEFF*VEHICLE.WHEEL_RADIUS*Fzf; %rolling resistance

omegaDotr = (Fxr*(-r) - Trrr)/inertia;
omegaDotf = (Fxf*(-r) + (Tdrivr + Tdrivf) - Trrf)/inertia;

%Fx = Fxf + Fxr; ---> The momentum goes with the same principal

end