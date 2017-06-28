library(ncdf4)
#Set working directory to folder with NetCDF data (stored in different folders for each year)
directory=getwd()
setwd(directory)
yearfilelist=shell('dir /b', intern=TRUE)

start.time = Sys.time()
for (m in yearfilelist){
  
 yearfolder=paste0(directory,"/",m) 
 ncdffilelist=shell('dir /b', intern=TRUE)

 for (n in ncdffilelist){
   ncdffile=paste0(yearfolder,"/",n)
   nwmfile=nc_open(ncdffile,readunlim=FALSE)
   #Get streamflow (in cms)
   nwmdata=ncvar_get(nwmfile,
                     varid="streamflow",
                     count = c(1,-1)) #Number of values to get in each dimension
   nc_close(nwmfile)
 }
}

end.time = Sys.time()
time.taken = end.time - start.time
time.taken



for (i in netcdffiles){
retrodata=nc_open(i)
streamflow=ncvar_get(retrodata,start=c(1,1), count = c(1,1))
}


...Relevent codes...

