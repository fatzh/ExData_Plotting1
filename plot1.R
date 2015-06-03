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
png(filename="./plot1.png")

## Plot an histogram, red, using the gloabl active power data. Also setting the axis label and the main title
hist(d$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")

## close PNG file
dev.off()