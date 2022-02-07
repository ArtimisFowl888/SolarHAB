function NCDF = nomadGFS(grib,simulation)

url = 'https://nomads.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/'+grib.file_name;
filename = "forcast\"+year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"_"+num2str(hour(grib.start),'%02.f')+'nomadforcast.grib';
grib.outfilename = websave(filename,url);
grib.ncfilename = "forcast\nc\" +year(grib.start)+num2str(month(grib.start),'%02.f')+num2str(day(grib.start),'%02.f')+"_"+num2str(hour(grib.start),'%02.f')+'nomadforcast.nc';
wgrib2cmd= "wgrib2 "+convertCharsToStrings(grib.outfilename)+' -netcdf ' + grib.ncfilename;
system(wgrib2cmd);
NCDF.info = ncinfo(grib.ncfilename);
