library(dplyr)
library(lubridate)
# Set setwd() to working directory containing data
setwd("C:/Users/nkd29/Desktop/Nikhils_Stuff/01_Career/03_Courses/Coursera_R_Data_Science_Johns_Hopkins/04_Exploratory_Data_Analysis/CourseProject1")
list.files()

fname = "household_power_consumption.txt"

# Load in data
home_data <- tbl_df(read.table(fname,header = TRUE,sep = ';')) 

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

# png file to save as
png(filename = "plot2.png",width = 480,height = 480)

# Plot 2        
plot(home_filt$datetime,home_filt$Global_active_power
     type = 'l',
     main = 'Global Active Power', 
     xlab='',
     ylab = 'Global Active Power (kilowatts)')

dev.off()