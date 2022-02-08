function Rad = Bradiation(simulation, balloon, coords)
Rad.I0 = 1358;               % Direct Solar Radiation Level
Rad.e = 0.016708;            % Eccentricity of Earth's Orbit
Rad.P0 = 10132;             % Standard Atmospheric Pressure at Sea Level
Rad.cloudElev = 3000;        % (m)
Rad.cloudFrac = 0.0;         % Percent cloud coverage [0,1]
Rad.cloudAlbedo = .65;       % [0,1]
Rad.albedoGround = .2;       % Ground albedo [0,1]
Rad.tGround = 293;           % (K) Temperature of Ground
Rad.emissGround = .95;       % [0,1]
Rad.SB = 5.670373E-8;        % Stefan Boltzman Constant
Rad.RE = 6371000;            % (m) Radius of Earth
Rad.radRef= .1;              % [0,1] Balloon Reflectivity
Rad.radTrans = .1;           % [0,1] Balloon Transmitivity
Rad.yday = day(simulation.start_time,'dayofyear');
Rad.Parea = 0.25*math.pi*balloon.d*balloon.d;
Rad.Sarea = math.pi*balloon.d*balloon.d;
Rad.temp = atmosisa(coords.el);