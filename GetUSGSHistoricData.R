#Load libraries
library(dataRetrieval)

setwd('C:/Users/Carly/')
#Subset by HUC or State

#Get Sites that have discharge (code: 00060) from NWIS database
dailyqsites = whatNWISsites(stateCd = "CA",parameterCd = "00060")

#Limit number of sites based on assimilated sites from NWM (e.g. not downstream of dam)
assimilatedsites=read.table('Google Drive/SummerInstitute/gageID_CA.txt',stringsAsFactors = F)
assimilatedsites=assimilatedsites[-1,3]

siteindex=match(assimilatedsites,dailyqsites$site_no)
dischargesites=data.frame(sitename=dailyqsites[siteindex,"site_no"],
                          lat=dailyqsites[siteindex,"dec_lat_va"],
                          long=dailyqsites[siteindex,"dec_long_va"],
                          stringsAsFactors = FALSE)
dischargesites_sub=dischargesites[(!is.na(dischargesites$sitename)),] #Eliminate any gages that do not match the NWM assimilated dataset

#Limit number of sites based on Hydrologic Disturbance Index (less than 10)
# hdi=read.csv('Hydrologic Disturbance Index - HDI/HDI Dataset/disturb_index.csv')
# hdi$sitename=as.character(hdi$sitename)
# dischargesites_sub=merge(dischargesites,hdi)
# dischargesites_sub=dischargesites_sub[(dischargesites_sub$total_disturbance_index<10),]

#Cycle through the sites
getgagedata = function(sitename){
  tempdailyq = readNWISdata(sites=i, service="dv", parameterCd="00060")
  
  if (length(tempdailyq)!=0){
    filename=paste0("Google Drive/SummerInstitute/USGSGageHistoricalData/",i,".csv")
    tempdailyq$dateTime=as.Date(tempdailyq$dateTime)
    tempdailyq=renameNWISColumns(tempdailyq)
    if(!exists(filename)){
      write.csv(tempdailyq,filename,row.names=FALSE)
    }else{
      print(paste0("File already exists for ",i))
    }
  }else{
    print(paste0("Re-check for ",i))
  }
  
}
for (i in dischargesites_sub$sitename){
  getgagedata(i)
}







