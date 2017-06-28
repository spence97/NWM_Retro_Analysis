require(rgdal)

fgdb = "C:/Users/Spencer/Documents/Research/SI/gis_nwm_v11/nwm_v11.gdb"

# List all feature classes in a file geodatabase
subset(ogrDrivers(), grepl("GDB", name))
fc_list = ogrListLayers(fgdb)
print(fc_list)

States = readOGR(dsn=fgdb,layer="States")
NHD = readOGR(dsn=fgdb,layer="channels_nwm_v11_routeLink")
summary(Gaged_Streams)
summary(States)
plot(States)
lines(Gaged_Streams)

State_Select = States[which(States$STATE_ABBR=="CA"),]
plot(State_Select)

stream_subset = NHD[State_Select,]
stream_subset1 = stream_subset[stream_subset$order_ > 3,]
lines(stream_subset1)

stream_subset2 = stream_subset1[(stream_subset1$gages != " "|stream_subset1$gages != ""),]
stream_subset2$gages = factor(stream_subset2$gages)
library(gdata)
stream_subset2$gages = trim(stream_subset2$gages, recode.factor = TRUE)
stream_subset2 = stream_subset2[(stream_subset2$gages != ""),]
levels(stream_subset2$gages)

library(dataRetrieval)
Gage_list = as.character(stream_subset2$gages)
tempdailyq = readNWISdata(sites=Gage_list, service="dv", parameterCd="00060", startDate="1993-01-01", endDate="2016-10-31")
  




tempdataframe = data.frame(date=tempdailyq$dateTime, flow=tempdailyq$X_00060_00003)
