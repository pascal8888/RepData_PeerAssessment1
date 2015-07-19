# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
1. Load the data (i.e. read.csv())

```r
download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip","repdata.zip",mode="wb")
unzip("repdata.zip")
repdata <- read.csv("activity.csv", header=T,stringsAsFactors=F)
```
2 Process/transform the data (if necessary) into a format suitable for your analysis

```
## Warning: package 'plyr' was built under R version 3.1.3
```

```
## Warning: package 'lubridate' was built under R version 3.1.3
```

```
## Warning: package 'lattice' was built under R version 3.1.3
```

```r
totalByDate <- aggregate(steps ~ date, repdata, sum, na.rm=F)
stepsByInterval <- aggregate(steps ~ interval, data = repdata, FUN = mean)
```
## What is mean total number of steps taken per day?
1 Make a histogram of the total number of steps taken each day

```r
hist(totalByDate$steps,30,col="blue",main="Total Steps Per Day - With NA Values", ylab="Number of Days with Value", xlab="Value (Steps) for Day")
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 





2 Calculate and report the mean and median total number of steps taken per day

```r
mean(totalByDate$steps)
```

```
## [1] 10766.19
```

```r
median(totalByDate$steps)
```

```
## [1] 10765
```
## What is the average daily activity pattern?
1 Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```r
plot(stepsByInterval, type = "l", col="blue")
```

![](PA1_template_files/figure-html/unnamed-chunk-6-1.png) 




2 Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```r
stepsByInterval$interval[which.max(stepsByInterval$steps)]
```

```
## [1] 835
```
## Imputing missing values
1 Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```r
sum(is.na(repdata))
```

```
## [1] 2304
```
2 Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

#### Strategy - Use the mean for the interval to fill in missing values
3 Create a new dataset that is equal to the original dataset but with the missing data filled in.

```r
imputed_repdata <- repdata
impute_mean <- function(x) replace(x, is.na(x), mean(x, na.rm = TRUE))
imputed_repdata <- ddply(repdata, ~interval, transform, steps = impute_mean(steps))
imputed_repdata<- imputed_repdata[with(imputed_repdata, order(date, interval)), ]
imputed_total <- aggregate(steps ~ date, data = imputed_repdata, sum)
```
4 Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```r
hist(imputed_total$steps, breaks = 30, col = "green", xlab = "Value (Steps) for Day",ylab="Number of Days with Value", main = "Total Steps Per Day - With Imputed Values for NA")
```

![](PA1_template_files/figure-html/unnamed-chunk-11-1.png) 

```r
mean(imputed_total$steps)
```

```
## [1] 10766.19
```

```r
median(imputed_total$steps)
```

```
## [1] 10766.19
```




## Are there differences in activity patterns between weekdays and weekends?
1 Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

```r
imputed_repdata$weekday <- weekdays(strptime(imputed_repdata$date, format = "%Y-%m-%d"))
weekend <- imputed_repdata$weekday == "Saturday" | imputed_repdata$weekday == "Sunday"
imputed_repdata$weekday[weekend] <- "weekend"
imputed_repdata$weekday[!weekend] <- "weekday"
```
2 Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 

```r
xyplot(steps ~ interval | weekday, data = imputed_repdata, layout=c(1,2), type="l")
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png) 



