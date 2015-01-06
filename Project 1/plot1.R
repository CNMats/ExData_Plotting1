## create data folder to download data
if(!file.exists("./data"))
{dir.create("./data")}

## download data and unzip the file
fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile="./data/power_consumption.zip")
unzip("./data/power_consumption.zip")

## read data into R
raw <- read.table("./household_power_consumption.txt",header = TRUE, sep = ";",na.strings = "?")
#str(raw)
#head(raw, n=3)

# format dates to enable subsetting
library(timeDate)
library(date)
library(lubridate)
raw$datetime <- strptime(paste(raw$Date, raw$Time), format = "%d/%m/%Y %H:%M:%S")
#class(raw$datetime)
##[1] "POSIXlt" "POSIXt"
#head(raw$datetime, n=3)
##[1] "2006-12-16 17:24:00 JST" "2006-12-16 17:25:00 JST"
##[3] "2006-12-16 17:26:00 JST"
raw$weekday <- wday(raw$datetime, label = TRUE)
#head(raw$weekday, n=3)
##[1] Sat Sat Sat
##Levels: Sun < Mon < Tues < Wed < Thurs < Fri < Sat

#create subset of 2 days
Prows <- grep(c("2007-02-01|2007-02-02"), raw$datetime)
## int[1:2880]
data <- raw[Prows,]
## 2880 obs, 11 var
#str(data)

# Change system locale to display Weekdays in English
locale <- Sys.getlocale(category = "LC_TIME")
Sys.setlocale(category = "LC_TIME", locale = "English")

#open png graphics device, create 480x480 file in my working directory
#Name each of the plot files as plot1.png, plot2.png, etc.

png(file = "plot1.png", width = 480, height = 480)

#plot the histrogram
#par("mar") #check margin space
par(mar=c(4,4,1,1)) #set margin space
par(mfcol = c(1,1)) #set panel for single plot
hist(data$Global_active_power, col = "red", xlab = "Global Active Power (killowats)", main = "Global Active Power")

#close the graphics device
dev.off()

## restore system's original locale
Sys.setlocale("LC_TIME", locale)
