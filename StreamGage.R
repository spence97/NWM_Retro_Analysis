library(rgdal)

fgdb = "C:/Users/Spencer/Documents/Research/SI/gis_nwm_v11/nwm_v11.gdb"

# List all feature classes in a file geodatabase
subset(ogrDrivers(), grepl("GDB", name))
fc_list = ogrListLayers(fgdb)
print(fc_list)

# Read in the States and NHD stream network feature classes
States = readOGR(dsn=fgdb,layer="States")
NHD = readOGR(dsn=fgdb,layer="NHD_US_Sample3")

# Select state of interest and plot it
State_Select = States[which(States$STATE_ABBR=="CA"),]
plot(State_Select)

# Subset the NHD stream network to the boundary of the state selected above
library(rgeos)
stream_subset = NHD[State_Select,]

# Subset the NHD stream network in the state by a user defined stream order then overlay the streams on the state map
stream_subset1 = stream_subset[stream_subset$order_ > 3,]
lines(stream_subset1)

# Subset the above subset to select only the streams in NHD that have a corresponding USGS gage
stream_subset2 = stream_subset1[(stream_subset1$gages != " "),]
stream_subset2$gages = factor(stream_subset2$gages)

# Clean up the subset of gaged streams to ensure there are no NULL data values
library(gdata)
stream_subset2$gages = trim(stream_subset2$gages, recode.factor = TRUE)
stream_subset2 = stream_subset2[(stream_subset2$gages != ""),]
levels(stream_subset2$gages)

# Create a list of the stream gage IDs that are assimilated to the NHD stream network
library(dataRetrieval)
Gage_list = as.character(stream_subset2$gages)
Gage_list1 = Gage_list[1:4] #used to speed up debugging process (only looks at first 4 gageIDs in list)

#create a new data frame that will hold the streamflow time series for all gages at a specified time period
Observations = data.frame(Date=seq.Date(as.Date("2001-11-01"),as.Date("2001-12-01"),by=1))

# Loops through the list of gageIDs and appends a new column containing the daily streamflow values for each gageID (the column name is the gageID).
for (i in Gage_list1){
  dailyq = readNWISdata(sites=i, service="dv", parameterCd="00060", startDate="2001-11-01", endDate="2001-12-01")
  df = data.frame(Gage_ID = dailyq$X_00060_00003)
  names(df)[ncol(df)] = paste0(i)
  Observations = cbind(Observations,df)
}

  





