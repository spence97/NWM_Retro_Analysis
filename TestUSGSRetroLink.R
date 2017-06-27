#Load libraries
library(ncdf4)
library(dataRetrieval)

setwd('C:/Users/Carly/')
start_date="1987-06-01"
end_date="2017-06-01"
#Subset by HUC or State

#Get Sites that have discharge (code: 00060) from NWIS database
dailyqsites = whatNWISsites(stateCd = "CA",parameterCd = "00060", startDate=start_date,endDate=end_date)

#Limit number of sites based on assimilated sites from NWM (e.g. not downstream of dam)
assimilatedsites=as.character(read.csv('Google Drive/SummerInstitute/gageID_CA.csv')$gages)

siteindex=match(assimilatedsites,dailyqsites$site_no)
dischargesites=data.frame(sitename=dailyqsites[siteindex,"site_no"],
                          lat=dailyqsites[siteindex,"dec_lat_va"],
                          long=dailyqsites[siteindex,"dec_long_va"],
                          stringsAsFactors = FALSE)
dischargesites_sub=dischargesites[(!is.na(dischargesites$sitename)),]

#Limit number of sites based on Hydrologic Disturbance Index (less than 10)
# hdi=read.csv('Hydrologic Disturbance Index - HDI/HDI Dataset/disturb_index.csv')
# hdi$sitename=as.character(hdi$sitename)
# dischargesites_sub=merge(dischargesites,hdi)
# dischargesites_sub=dischargesites_sub[(dischargesites_sub$total_disturbance_index<10),]

#Cycle through the sites
getgagedata = function(sitename){
  tempdailyq = readNWISdata(sites=i, service="dv", parameterCd="00060",
                            startDate=start_date,endDate=end_date)
  
  if (length(tempdailyq)!=0){
    filename=paste0("Google Drive/SummerInstitute/USGSGageHistoricalData/",i,".csv")
    tempdailyq$dateTime=as.Date(tempdailyq$dateTime)
    tempdailyq=renameNWISColumns(tempdailyq)
    write.csv(tempdailyq,filename,row.names=FALSE)
    print("Success")
  }else{
    print(paste0("Re-run for ",i))
  }
  
}
for (i in dischargesites_sub$sitename){
  getgagedata(i)
}

#Look up USGS site number to find corresponding NHD COMID



#Cycle through files and load
ncdffile=('Desktop/SummerInstitute/retro_nwm_v10_streamflow/1993/199301010000_streamflow.nc')
retrodata=nc_open(ncdffile)
print(retrodata)


