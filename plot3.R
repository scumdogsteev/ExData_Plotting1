## Exploratory Data Analysis Course Project 1
## plot3.R
## by Steve Myles
## 2015-04-07
##
## this generates plot3.png, per the assignment
##
## Assumptions:
## * the data file is in the working directory or the user is connected to the
##   Internet
## * the user has installed the "lubridate" package or is connected to the
##   Internet so the script can install it.

## ***************************************************************************
## downloadUnzip is a function that checks whether the data exists, and 
## downloads/unzips it if not
## this function comes from my repo here:
## https://github.com/scumdogsteev/R-functions-and-such
## ***************************************************************************
downloadUnzip <- function(dir = "data", url, file) {
    ## check if the expected directory exists in the working directory.
    dir <- paste("./", dir, sep = "")
    if (!file.exists(dir)) {
        ## if not, check whether the expected zip file ("file") exists 
        ## in the working directory
        if (!file.exists(file)) {
            ## if not, try to download it -- need to remove 'method = "curl"'
            ## if using in Windows
            download.file(url = url, destfile = file, method = "curl", 
                          mode="wb")
        }
        ## unzip the file if the directory doesn't already exist
        unzip(file)     
    }
    ## if the directory exists and/or if the zip file is downloaded/unzipped
    ## or a previously downloaded version of the zip file is unzipped,
    ## proceed with execution of the script
}

## ***************************************************************************
## download and unzip the data if not available
## ***************************************************************************
downloadUnzip("data", "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              "exdata-data-household_power_consumption.zip")

## ***************************************************************************
## pkgInst is a function that checks whether a package is installed and, if
## not, installs it.
## this function comes from my repo here:
## https://github.com/scumdogsteev/R-functions-and-such
## ***************************************************************************

pkgInst <- function(x) {
    for (i in x) {
        ## "require" returns TRUE invisibly if it was able to load package
        if (!require(i, character.only = TRUE)) {
            ## if package was not able to be loaded, install it
            install.packages(i, dependencies = TRUE)
            ## load package after installing
            require (i, character.only = TRUE)
        }
    }
}

## ***************************************************************************
## load the "lubridate" package, installing it if necessary
## ***************************************************************************
pkgInst("lubridate")

## ***************************************************************************
## read the text file into a data frame called "data," noting that periods 
## (".") separate the columns and ensuring that "?" is the character used to
## represent NA (missing values)
## ***************************************************************************
data <- read.csv("./data/household_power_consumption.txt", sep=";", 
                 na.strings="?")

## ***************************************************************************
## using the dmy function from lubridate, replace Date with its date-formatted
## equivalent
## ***************************************************************************
data$Date <- dmy(as.character(data$Date))

## ***************************************************************************
## using the dmy function from lubridate, subset the data frame to the 
## appropriate dates
## ***************************************************************************
data <- subset(data, data$Date == ymd("2007-02-01") | 
                    data$Date == ymd("2007-02-02"))

## ***************************************************************************
## combine date and time into a single column for use in plotting using the 
## "ymd_hms" function from the lubridate package and the base "paste" function
## ***************************************************************************
data$datetime <- ymd_hms(paste(data2$Date, data2$Time))

## ***************************************************************************
## open the graphics device (png)
## ***************************************************************************
png(filename = "plot3.png", width=480, height=480)

## ***************************************************************************
## create the plot and set the axis title, then add the additional lines per 
## the example
## ***************************************************************************
plot(data$datetime, data$Sub_metering_1, type = "l", xlab = "",
     ylab = "Energy sub metering")
lines(data$datetime, data$Sub_metering_2, col="red")
lines(data$datetime, data$Sub_metering_3, col="blue")

## ***************************************************************************
## add the legend in the top right of the plot
## ***************************************************************************
legend("topright", lty=c(1,1,1), col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## ***************************************************************************
## close the graphics device
## ***************************************************************************
dev.off()