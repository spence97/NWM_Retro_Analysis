#Cycle through files and load
ncdffile=('Desktop/SummerInstitute/retro_nwm_v10_streamflow/1993/199301010000_streamflow.nc')
retrodata=nc_open(ncdffile)
print(retrodata)
