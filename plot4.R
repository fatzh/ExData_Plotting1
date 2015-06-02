##
## Loading the data
##
## The data file is assumed to be present in a subdirectory of the working directory called 'data'
##
if(!require(tidyr, quietly=TRUE)) {
    stop("The package 'tidyr' is required, please install it to run this script.")
}
if(!require(sqldf, quietly=TRUE)) {
    stop("The package 'sqldf' is required, please install it to run this script.")
}

## load data
d <- read.csv.sql('./data/household_power_consumption.txt',
                  sql="select * from file where Date in ('1/2/2007', '2/2/2007')",
                  colClasses = c('character', 'character', rep('numeric', 7)),
                  header=TRUE,
                  sep=';',
                  row.names=FALSE)


## merge date and time
d <- unite(d, Datetime, Date, Time, sep=' ')
## and make it a proper time
d$Datetime <- strptime(d$Datetime, "%d/%m/%Y %H:%M:%S")

## write output in a PNG file
png(filename="./plot4.png")

## we will go for column split
par(mfcol = c(2, 2))

## this is actually plot 2, with a different Y label
plot(d$Datetime, d$Global_active_power, type='n', ylab="Global Active Power", xlab='')
lines(d$Datetime, d$Global_active_power)

## this is plot3 without the legend box
plot(rep(d$Datetime, 3), c(d$Sub_metering_1, d$Sub_metering_2, d$Sub_metering_3), type='n', ylab="Energy sub metering", xlab='')
lines(d$Datetime, d$Sub_metering_1)
lines(d$Datetime, d$Sub_metering_2, col="red")
lines(d$Datetime, d$Sub_metering_3, col="blue")
legend('topright', lwd=1, bty = "n",  col=c('black', 'red', 'blue'), legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'))

## third plot
plot(d$Datetime, d$Voltage, type='n', ylab='Voltage', xlab='datetime')
lines(d$Datetime, d$Voltage)

## and last plot
plot(d$Datetime, d$Global_reactive_power, type='n', xlab='datetime', ylab='Global_reactive_power')
lines(d$Datetime, d$Global_reactive_power)

dev.off()