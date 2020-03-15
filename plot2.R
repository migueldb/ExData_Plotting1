################################################################################
##
## This script is part of a programming assignment submission
## John Hopkins University and Coursera
## Specialization: Data Science
## Course: Exploratory Data Analysis
## Assignment type: Peer-graded
## Title: Course Project 1
## Assignment Instructions can be found at: 
## https://www.coursera.org/learn/exploratory-data-analysis/peer/ylVFo/\
## course-project-1
## plot2.R - This script generates the second assingment plot
## Student: Miguel Duarte B.
## email: duartemj@outlook.com
##
################################################################################

## Cleaning the environment first

rm(list=ls(all=TRUE))

## Check the working directory and the Raw data directory, create one if 
## necessary

## To set a separate Raw file inside the work directory uncoment the 
## #  "Raw" line and the comma after getwd() line

rawDir <- file.path(
    getwd(),
    "Raw"
)

if (
    !file.exists(
        rawDir
    )
){
    dir.create(
        rawDir
    )
}

## Download the files
## Assign the urls to variables

fileUrl1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#### Actually download the files

sourceFN <- "exdata_data_household_power_consumption.zip"
if (
    !file.exists(
        file.path(
            rawDir,
            sourceFN
        )
    )
){
    download.file(
        fileUrl1, 
        file.path(
            rawDir, 
            sourceFN
        )
    )
    dateDownloaded1 <- date()
}

## Unzip the source file
## First check if the file has been unzipped already if not then unzip

sourceDir <- "exdata_data_household_power_consumption"

if (
    !file.exists(
        file.path(
            rawDir,
            sourceDir
        )
    )
){
    unzip(
        file.path(
            rawDir,
            sourceFN
        ),
        exdir = file.path(
            rawDir,
            sourceDir
        )
    )
}

## Using readr to read files
library(readr)

## Using dplyr to manipulate the data objects
library(dplyr)

exdataFN <- "household_power_consumption.txt"

## Check the size of the file

print(
    paste(
        c(
            "The size of the file ",
            exdataFN,
            " is: ",
            round(
                file.size(
                    file.path(
                        rawDir,
                        sourceDir,
                        exdataFN
                    )
                ) / 2^20,
                2
            ),
            " megabytes."
        ),
        collapse = "")
)

## Read the power consumption data
exdata <- read_delim(
    file.path(
        rawDir,
        sourceDir,
        exdataFN),
    delim = ";",
    col_types = cols(
        Date = col_date(format = "%d/%m/%Y"),
        Time = col_time(format = "%H:%M:%S"),
        .default = col_double()
    ),
    na = "?",
    trim_ws = TRUE,
)

## Apply tidy data principles to the column names
## change case to lower case
names(exdata) <- tolower(names(exdata))

## Remove "_"
names(exdata) <- gsub("_", "", names(exdata))

## Manipulate "exdata" object to fit the assignment requirements

exdata <- exdata %>% 
    ## Filter the rows with dates 2007-02-01 and 2007-02-02    
    filter(
        date == "2007-02-01" | date == "2007-02-02"
    ) %>%
    mutate(
        posixtime = as.POSIXct(strptime(paste(date, time), format = "%Y-%m-%d %H:%M", tz = "US/Eastern"))
    )

## Select the PNG graphic device with the correct settings
png(
    filename = "plot2.png",
    width = 480,
    height = 480,
    units = "px"
)

## Generate the line plot
plot(
    exdata$posixtime,
    exdata$globalactivepower,
    type = "l",
    main = NULL,
    xlab = "",
    ylab = "Global Active Power (kilowatts)"#,
    #xaxt = "n"
    )

## Customize x-axis
axis(
    1,
    at = c(0, 40000, 80000),
    labels = c("Thu", "Fri", "Sat")
    )

## Desconnect the graphics device
dev.off()