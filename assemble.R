# Canadian Historical Weather Data


# for year in `seq 1998 2008`;do for month in `seq 1 12`;do wget --content-disposition "http://climat.weather.gc.ca/climateData/bulkdata_e.html?format=csv&stationID=1706&Year=${year}&Month=${month}&Day=14&timeframe=1&submit= Download+Data" ;done;done
# 
# WHERE; 
# •	year = change values in command line (‘seq 1998 2008)
# •	month = change values in command line (‘seq 1 12)
# •	format= [csv|xml]: the format output
# •	timeframe = 1: for hourly data 
# •	timeframe = 2: for daily data 
# •	timeframe = 3 for monthly data 
# •	Day: the value of the "day" variable is not used and can be an arbitrary value 
# •	For another station, change the value of the variable stationID
# •	For the data in XML format, change the value of the variable format to xml in the URL. 
# 

require(curl)
require(readr)
require(plyr)

# Download datasets. Environment Canada historical data available by month.


# For the station, I'm using Vancouver Harbour (around Deadman's Island in Coal Harbour. YVR INTL AIRPORT has a data break around June 2013 - use at caution).

stationID <- "888"

for (i in 1:21) {
  year <- 1994 + i 
  year <- as.character(year)
  query <- paste0("http://climate.weather.gc.ca/climateData/bulkdata_e.html?format=csv&stationID=",stationID,"&Year=",year,"&Month=1&Day=14&timeframe=2&submit=Download+Data")
  writableOutput <- paste0(stationID,"_",year,".csv")
  curl_download(query, writableOutput)
}

# The Environment Canada data is not nicely parsed and contains descriptions in the top rows. The number of rows to skip requires a little bit of trial and error, but it looks like 27 for day/month data, 18 for month/year data, and 16 for hourly/daily.

annual <- c()

for (j in 1:21)  { 
  tmp <- read_csv(dir()[j], col_names = FALSE, n_max = 50)
  startingRow <- as.numeric(row.names(tmp[tmp[,1]=="Date/Time",])[3])
  annual[[j]] <- as.data.frame(read_csv(dir()[j], col_names = TRUE, skip = startingRow-1))
}
annual <- rbind.fill(annual)

