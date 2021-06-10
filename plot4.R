# When loading the dataset into R, please consider the following:
#   
#   1. The dataset has 2,075,259 rows and 9 columns. First calculate a rough 
#      estimate of how much memory the dataset will require in memory before reading into R.
#      Make sure your computer has enough memory (most modern computers should be fine).
# 
#   2. We will only be using data from the dates 2007-02-01 and 2007-02-02. One 
#      alternative is to read the data from just those dates rather than reading 
#      in the entire dataset and subsetting to those dates.
# 
#   3. You may find it useful to convert the Date and Time variables to Date/Time 
#      classes in R using the strptime() and as.Date() functions.
# 
#   4. Note that in this dataset missing values are coded as ?.

# library(ggplot2)
library(dplyr)
library(lubridate)
# Set setwd() to working directory containing data
setwd("C:/Users/nkd29/Desktop/Nikhils_Stuff/01_Career/03_Courses/Coursera_R_Data_Science_Johns_Hopkins/04_Exploratory_Data_Analysis/CourseProject1")
list.files()

fname = "household_power_consumption.txt"

# Load in data
home_data <- tbl_df(read.table(fname,header = TRUE,sep = ';')) 

# Reformat some data to make it useful
# example: as.Date("1/2/2007","%d/%m/%Y")
# home_data$datetime <- strptime(home_data$datetime,format = '%d/%m/%Y %H:%M:%S')
# home_data$Date <- as.Date(home_data$Date,"%d/%m/%Y")

# lubridate package
home_data$datetime <- paste(home_data$Date,home_data$Time)
home_data$datetime <- dmy_hms(home_data$datetime)
home_data <- home_data %>% select(Date,Time,datetime,everything())

home_data$Date <- dmy(home_data$Date)
home_data$Time <- hms(home_data$Time)

home_data$Global_active_power <- as.numeric(home_data$Global_active_power)
home_data$Global_reactive_power <- as.numeric(home_data$Global_reactive_power)
home_data$Sub_metering_1 <- as.numeric(home_data$Sub_metering_1)
home_data$Sub_metering_2 <- as.numeric(home_data$Sub_metering_2)
home_data$Sub_metering_3 <- as.numeric(home_data$Sub_metering_3)

#Filter out dates of interest
home_filt <- home_data %>% filter(Date == "2007-02-01"|Date == "2007-02-02")

# typeof(home_filt$Global_active_power[3])
# gap <- names(home_filt)[3]

# qplot(Global_active_power,data=home_filt,facets = .~Date)
# qplot(Global_active_power,data=home_filt,binwidth=0.5,fill='red',main = 'Global Active Power',xlab='Global Active Power (kilowatts)',ylab = 'Frequency')

png(filename = "plot4.png", width = 480, height = 480)
# arrange grid
par(mfrow=c(2,2))

# Plot 1 - upper left         
plot(home_filt$datetime,home_filt$Global_active_power,
     type = 'l',
     xlab='',
     ylab = 'Global Active Power')

# Plot 2 - upper right
plot(home_filt$datetime,home_filt$Voltage,
     type = 'l',
     xlab = 'datetime',
     ylab = 'Voltage')

# Plot 3 - bottome left
# Create a first line
plot(home_filt$datetime, home_filt$Sub_metering_1, type = "l", #frame = FALSE, pch = 19,
           col = "black", xlab = "", ylab = "Energy sub metering")
# Add a second line
lines(home_filt$datetime, home_filt$Sub_metering_2, pch = 18, col = "red", type = "l") #, lty = 2)

# Add third line
lines(home_filt$datetime, home_filt$Sub_metering_3, pch = 18, col = "blue", type = "l") #, lty = 2)

# Add a legend to the plot
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
       col=c("black", "red", "blue"), lty = 1:2, cex=0.8)
# 
# Plot 4 - bottom right

# Plot 1 - upper left corner        
plot(home_filt$datetime,home_filt$Global_reactive_power,
     type = 'l',
     ylab = 'Global_reactive_power', 
     xlab='datetime')

dev.off()

