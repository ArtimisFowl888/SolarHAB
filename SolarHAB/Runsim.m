
addpath('functions')
gfs = "2021-08-13 12:00:00";
start_time = "2022-02-8 13:30:00";

%% Balloon

balloon.shape='sphere';
balloon.d=7; % (m) Diameter of Sphere Balloon
balloon.mp=3.5; % (kg) Mass of Payload
balloon.areaDensityEnv=939. * 7.87E-6; % (Kg/m^2) rhoEnv*envThickness
balloon.mEnv=1.75; % (kg) Mass of Envelope - SHAB1
balloon.cp=1250.0; % (J/(kg K)) Specific heat of envelope material
balloon.absEnv=0.6; % Absorbiviy of envelope material
balloon.emissEnv=0.6; % Emisivity of enevelope material
balloon.Upsilon=2.5; % Ascent Resistance coefficient

%% Simulation

simulation.start_time=datetime(start_time);  % (UTC) Simulation Start Time, updated above
simulation.sim_time=16;  % (hours) Simulation time in hours (for trapezoid.py)
simulation.vent=0.0;  % (kg/s) Vent Mass Flow Rate  (Do not have an accurate model of the vent yet, this is innacurate)
simulation.alt_sp=15000.0;  % (m) Altitude Setpoint
simulation.v_sp=0.;  % (m/s) Altitude Setpoint, Not Implemented right now
% simulation.start_coord.lat= 35.811422;  % (deg) Latitude
% simulation.start_coord.lon= -99.193882;  % (deg) Longitude
% simulation.start_coord.alt= 561.;  % (m) Elevation
simulation.start_coord.lat= 36.1626;  % (deg) Latitude
simulation.start_coord.lon= -96.8358;  % (deg) Longitude
simulation.start_coord.alt= 300.;  % (m) Elevation
simulation.start_coord.timestamp= start_time;  % timestamp
simulation.min_alt=300.;  % starting altitude. Generally the same as initial coordinate
simulation.float=11500.;  % Maximum float altitude for simple trapezoidal trajectories
simulation.dt = 2.0;  % (s) Time Step for integrating (If error's occur, use a lower step size)
simulation.GFSrate=60;  % (s) How often New Wind speeds are looked up


%% Earth

earth_properties.Cp_air0=1003.8;  % (J/Kg*K)  Specifc Heat Capacity, Constant Pressure
earth_properties.Cv_air0=716.;  % (J/Kg*K)  Specifc Heat Capacity, Constant Volume
earth_properties.Rsp_air=287.058;  % (J/Kg*K) Gas Constant
earth_properties.P0=101325.0;  % (Pa) Pressure @ Surface Level
earth_properties.emissGround=.95;  % assumption
earth_properties.albedo=0.17;  % assumption

%% netCDF

grib.lat_range=40;  % (.25 deg)
grib.lon_range=40;  % (.25 deg)
grib.hours=1;
grib.res=0.25;  % (deg) Do not change
grib.start = datetime(gfs);
grib.file_name = "gfs."+year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"/"+num2str(hour(grib.start),'%02.f')+"/atmos/"+"gfs.t"+num2str(hour(grib.start),'%02.f')+"z.pgrb2.0p25.f"+num2str(grib.hours,'%03.f');
grib.ncfilename = "forcast\nc\" +year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"_"+num2str(hour(grib.start),'%02.f')+'nomad.nc';

NCDF.matfilename = "forcast\mat\" +year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"_"+num2str(hour(grib.start),'%02.f')+'AWS.mat';

if datetime('now')-datetime(gfs,'InputFormat','yyyy-MM-dd hh:mm:ss') > duration(hours(216))
    server = 'AWS';
    try
        load(NCDF.matfilename);
        sprintf("loading:" +year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"_"+num2str(hour(grib.start),'%02.f')+'AWS.mat')
    catch
        sprintf("downloading from:"+server)
        [NCDF, grib] = AWSGFS(grib,simulation);
    end
    
else
    server = 'nomad';
    try
        load(NCDF.matfilename);
        sprintf("loading:" +year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"_"+num2str(hour(grib.start),'%02.f')+'AWS.mat')
    catch
        sprintf("downloading from:"+server)
        [NCDF, grib] = nomadGFS(grib,simulation);
    end

end

%% Radation

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
Rad.Parea = 0.25*pi*balloon.d*balloon.d;
Rad.Sarea = pi*balloon.d*balloon.d;

    
    