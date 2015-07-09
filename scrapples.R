df <- aggregate.ts(repdata,as.list(repdata$date),nfrequency=1,FUN=sum, simplify=T)
repdata <- as.data.frame(aggregate.ts(repdata,as.list(repdata$date),nfrequency=1,FUN=sum, simplify=T))
