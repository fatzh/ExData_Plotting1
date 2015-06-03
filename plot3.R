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
png(filename="./plot3.png")

## plotting an empty plot with the appropriate scales and axis labels
plot(rep(d$Datetime, 3), c(d$Sub_metering_1, d$Sub_metering_2, d$Sub_metering_3), type='n', ylab="Energy sub metering", xlab='')
## plot a line date versus submetering 1
lines(d$Datetime, d$Sub_metering_1)
## plot a red line date versus submetering 2
lines(d$Datetime, d$Sub_metering_2, col="red")
## plot a blue line date versus submetering 3
lines(d$Datetime, d$Sub_metering_3, col="blue")
## and adds the legend
legend('topright', lwd=1,  col=c('black', 'red', 'blue'), legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'))

## closing png device
dev.off()