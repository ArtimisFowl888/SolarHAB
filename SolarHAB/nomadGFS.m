function NCDF = nomadGFS(grib,simulation)

url = 'https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/'+grib.file_name;
filename = "forcast\"+year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"_"+num2str(hour(grib.start),'%02.f')+'nomad.grib';
sprintf("Downloading grib: "+year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"_"+num2str(hour(grib.start),'%02.f')+'nomad.grib')
grib.outfilename = websave(filename,url);
grib.ncfilename = "forcast\nc\" +year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"_"+num2str(hour(grib.start),'%02.f')+'nomad.nc';
wgrib2cmd= "wgrib2"+' -match ":HGT:|:UGRD:|:VGRD:|:TMP:|:ALBDO:" '+convertCharsToStrings(grib.outfilename)+' -netcdf ' + grib.ncfilename;
system(wgrib2cmd);
NCDF.info = ncinfo(grib.ncfilename);
NCDF.Albedo = ncread(grib.ncfilename,'ALBDO_surface');
NCDF.UGRD(:,:,:,1) = ncread(grib.ncfilename,'UGRD_0D01mb');
NCDF.UGRD(:,:,:,2) = ncread(grib.ncfilename,'UGRD_0D02mb');

