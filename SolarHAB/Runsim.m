

gfs = "2022-02-05 06:00:00";
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
grib.hours=24;
grib.res=0.25;  % (deg) Do not change
grib.start = datetime(gfs);
grib.file_name = "gfs."+year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"/"+num2str(hour(grib.start),'%02.f')+"/atmos/"+"gfs.t"+num2str(hour(grib.start),'%02.f')+"z.pgrb2.0p25.f"+num2str(grib.hours,'%03.f')

if datetime('now')-datetime(gfs,'InputFormat','yyyy-MM-dd hh:mm:ss') > 216
    server = 'neci';
else
    server = 'nomad';
     NCDF = nomadGFS(grib,simulation);
end