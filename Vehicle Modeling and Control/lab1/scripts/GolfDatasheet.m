%%=== VW Golf II data =====================================================
%% --- Chassis ------------------------------------------------------------
VEHICLE.MASS = 907;                 %[kg]     Curb weight (full tank, no driver or pass.)
VEHICLE.L = 2.475;                  %[m]      Wheel base
VEHICLE.LF = 0.63*VEHICLE.L;        %[m]      Distance along X-axis from CoG to front axle
VEHICLE.LR = VEHICLE.L-VEHICLE.LF;  %[m]      Distance along X-axis from CoG to rear axle
VEHICLE.COG_HEIGHT = 0.543;         %[m]      Distance along Z-axis from CoG to ground.
VEHICLE.FRONT_AREA = 1.91;          %[m^2]    Front area
VEHICLE.DRAG_COEFF = 0.34;          %[-]      Air drag coefficient 

%% --- Tire / Wheel -------------------------------------------------------
VEHICLE.ROLL_RESIST_COEFF = 0.0164; %[-]      Rolling resistance constant
VEHICLE.WHEEL_RADIUS = 0.316;       %[m]      Radius of wheel
VEHICLE.WHEEL_INERTIA = 2;          %[kg*m^2] Moment of inertia for two wheels and axle

%% --- Environment --------------------------------------------------------
ENVIRONMENT.AIR_DENSITY = 1.3;      %[kg/m^3] Air density
ENVIRONMENT.GRAVITY = 9.81;         %[m/s^2]  Gravitational constant

%% --- Engine -------------------------------------------------------------
VEHICLE.RATIO_VEC = [3.385 1.76 1.179 0.894 0.66];  % Ratio for each gear (1-5)
VEHICLE.RATIO_FINAL = 3.67;                         % Final drive ratio

% Engine speed vector corresponding to torque vector [rad/s]
VEHICLE.ENGINE_SPEED_VEC = [ ...
    0 500 750 1000 1250 1500 1750 2000 2500 ...
    3000 3500 4000 4500 5000 5500 6000 6500] * pi/30;

% Engine maximum torque vector (throttle = 100%) [Nm]
VEHICLE.ENGINE_TORQUE_VEC = [...
       0.0000  72.3550 108.6000 144.8500 175.8800 206.8800 ...
      234.8900 251.9300 264.9800 265.0000 265.0000 263.0000 ...
      255.0200 240.0300 223.0300 204.0400 187.0300];