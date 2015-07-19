df <- aggregate.ts(repdata,as.list(repdata$date),nfrequency=1,FUN=sum, simplify=T)
repdata <- as.data.frame(aggregate.ts(repdata,as.list(repdata$date),nfrequency=1,FUN=sum, simplify=T))
repdata$date <- as.Date(repdata$date)

byDate <- aggregate(steps ~ date, repdata, sum, na.rm = TRUE)
avgSteps <- aggregate(steps ~ interval, repdata, mean, na.rm = TRUE)
maxStepsCount <- which.max(avgSteps$steps)
hist(totalStepsDate$steps, col = "blue",
     main = "Total Number Steps Per Day", xlab = "Steps Per Day")
repdata <- mutate(repdata, Day = paste(year(date),yday(date)))
repdata$Day <- as.numeric(sub(" ","",repdata$Day))
plot(as.Date(repdata$date),repdata$steps, repdata$interval, xlab= "Date", ylab= "Steps", type="l", col='blue')
