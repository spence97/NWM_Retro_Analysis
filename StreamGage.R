library(rgdal)

fgdb = "C:/Users/Spencer/Documents/Research/SI/gis_nwm_v11/nwm_v11.gdb"

# List all feature classes in a file geodatabase
subset(ogrDrivers(), grepl("GDB", name))
fc_list = ogrListLayers(fgdb)
print(fc_list)

States = readOGR(dsn=fgdb,layer="States")
NHD = readOGR(dsn=fgdb,layer="NHD_US_Sample3")

State_Select = States[which(States$STATE_ABBR=="CA"),]
plot(State_Select)

library(rgeos)
stream_subset = NHD[State_Select,]
stream_subset1 = stream_subset[stream_subset$order_ > 3,]
lines(stream_subset1)

stream_subset2 = stream_subset1[(stream_subset1$gages != " "),]
stream_subset2$gages = factor(stream_subset2$gages)
library(gdata)
stream_subset2$gages = trim(stream_subset2$gages, recode.factor = TRUE)
stream_subset2 = stream_subset2[(stream_subset2$gages != ""),]
levels(stream_subset2$gages)

library(dataRetrieval)
Gage_list = as.character(stream_subset2$gages)
Gage_list1 = Gage_list[1:4]

Observations = data.frame(Date=seq.Date(as.Date("2001-11-01"),as.Date("2001-12-01"),by=1))
for (i in Gage_list1){
  dailyq = readNWISdata(sites=i, service="dv", parameterCd="00060", startDate="2001-11-01", endDate="2001-12-01")
  df = data.frame(Gage_ID = dailyq$X_00060_00003)
  names(df)[ncol(df)] = paste0(i)
  Observations = cbind(Observations,df)
}

  





