## This file will:
## 1. Download & load individual power consumption data from UCI's machine learning
## repository
## 2. Replicate plot 1 from Coursera's Exploratory Data Analysis Wk 1 Course Project

library(lubridate)

## If data directory does not already exist, create a data directory in current
## working directory
datadir = "./data"
if(!dir.exists(datadir)){
    dir.create(datadir)
}

## If data has not already been downloaded, download data for analysis
fileName = "powercons.zip"
filepath = file.path(datadir,fileName)
if(!file.exists(filepath)){
    fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl,filepath, method = "curl")
}

## If data has not already been unzipped, unzip data set
if(!file.exists("./data/household_power_consumption.txt")){
    unzip(filepath, exdir = datadir)
}

## Load column names & data from 2007-02-01 and 2007-02-02, per course requirements
cnames <- read.table("./data/household_power_consumption.txt", sep = ";", nrows = 1, colClasses = c("character","character","character","character","character","character","character","character","character"))
rl <- readLines("./data/household_power_consumption.txt")
n <- grep("^1/2/2007",rl)
n2 <- grep("^2/2/2007",rl)
data <- read.table("./data/household_power_consumption.txt", sep = ";", skip = n[1]-1,nrows = length(n))
data2 <- read.table("./data/household_power_consumption.txt", sep = ";", skip = n2[1]-1,nrows = length(n2))

## Consolidate data & clear memory
data <- rbind(data,data2)
rm(n,n2,rl,data2)

## Add column names to data & update data classes
colnames(data) <- cnames
data$Date <- dmy(data$Date)
data$Time <- strptime(data$Time, format = "%T")
data$Time[1:1440] <- format(data$Time, format = "2007-02-01 %T")
data$Time[1441:2880] <- format(data$Time, format = "2007-02-02 %T")

## Build plot 2
plot(data$Time,data$Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)") 
dev.copy(png,file = "plot2.png")
dev.off()