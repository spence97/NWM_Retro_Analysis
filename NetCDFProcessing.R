library(ncdf4)
directory='C:/Users/carly/Desktop/SummerInstitute/retro_nwm_v10_streamflow'
setwd(directory)
yearfilelist=shell('dir /b', intern=TRUE)

start.time = Sys.time()
for (m in yearfilelist){
  
 yearfolder=paste0(directory,"/",m) 
 setwd(yearfolder)
 ncdffilelist=shell('dir /b', intern=TRUE)
 for (n in ncdffilelist){
   ncdffile=paste0(ncdffilelist,"/",n)
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

