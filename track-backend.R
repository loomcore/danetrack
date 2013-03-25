# track 0.0.1
# track-backend.R
# A tool to turn a CSV file of test results into pretty plots.
# Copyright (C) 2013 P. M. Yeeles
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Usage # TODO
# Per-child plot: Usage: track -n "Firstname Lastname" "rate"|"ratio" from to
# Plot of means: track -a from to
# Boxplots: track -b from to

args <- commandArgs(trailingOnly = TRUE)
print(args)

file <- args[1]

marks <- read.csv(file)

name <- args[2]
type <- args[3]
# from <- args[4] # TODO: need to convert from date to col. index
# to <- args[5]   # TODO: need to convert from date to col. index

# weeks <- c(1:8) # c(from:to)

rlen <- length(marks[1,])

if (type == "MeanAttempt") {
  for(i in seq(1, length(marks[,1]), by=3)) {
    # do something
  }
} else if (type == "MeanRate") {
  for(i in seq(1, length(marks[,1]), by=3)) {
    # do something else
  }
} else {
  for(i in seq(1, length(marks[,1]), by=3)) {
    if (name == marks[i,1]) {
      switch(type,
        "Ratio" = child <- marks[i+1,3:rlen]/marks[i,3:rlen],
        "AttemptRate" = child <- marks[i,3:rlen]/marks[i+2,3:rlen],
        "CorrectRate" = child <- marks[i+1,3:rlen]/marks[i+2,3:rlen],
        "Combined" = child <- rbind(marks[i,3:rlen],marks[i+1,3:rlen]),
        "CombinedRate" = child <- rbind(marks[i,3:rlen]/marks[i+2,3:rlen],marks[i+1,3:rlen]/marks[i+2,3:rlen]),
        "Attempted" = child <- marks[i,3:rlen],
        "Correct" = child <- marks[i+1,3:rlen],
        "Time" = child <- marks[i+2,3:rlen])
    }
  }
# marks[i,from:to] # TODO: sort out from:to
}

# remove NA values
if ((type == "Combined") || (type == "CombinedRate")) {
  # for (i in 1:length(child[,1]))
  tmp0 <- child[1,][!is.na(child[1,])] # brittle
  tmp1 <- child[2,][!is.na(child[2,])]
  child <- rbind(tmp0,tmp1)
} else {
  child <- child[!is.na(child)]
}

# paste("foo","bar",sep="") to concat strings
namevec <- unlist(strsplit(name," "))
title <- paste(paste(name,":",sep=""),switch(type,"AttemptRate"="Attempt Rate","CorrectRate"="Correct Rate","CombinedRate"="Answer Rates","Combined"="Questions Answered",type),sep=" ")
switch(type,
  "Ratio" = ylabel <- "Correct/Attempted Ratio",
  "AttemptRate" = ylabel <- "Attempt frequency/Hz",
  "CorrectRate" = ylabel <- "Correct frequency/Hz",
  "Combined" = ylabel <- "Number of Questions",
  "CombinedRate" = ylabel <- "Frequency/Hz",
  "Attempted" = ylabel <- "Questions Attempted",
  "Correct" = ylabel <- "Correct Answers",
  "Time" = ylabel <- "Session Time")
fh <- paste(namevec[1],namevec[2],type,".png",sep="")

if (substring(type,nchar(type)-3,nchar(type)) == "Rate") {
  yticks <- seq(0,1,0.1)
  ylabs <- formatC(yticks,digits=1,format="f")
} else {
  yticks <- seq(floor(min(child)),ceiling(max(child)),10)
  ylabs <- formatC(yticks,digits=0,format="f")
}

png(fh,width=1024,height=600)
# 1:length(child) has replaced weeks and 8 to accommodate removed NAs
if ((type == "Combined") || (type == "CombinedRate")) {
  plot(1:length(child[1,]),child[1,],type="l",xlab="Session",ylab=ylabel,main=title,col="red",xaxs="i",yaxs="i",ylim=c(floor(min(child)),ceiling(max(child))),xlim=c(1,length(child[1,])),xaxp=c(1,length(child),length(child)-1),yaxt="n") # yaxp=c(floor(min(child)),ceiling(max(child)),10))
  axis(side=2,at=yticks,labels=ylabs)
  lines(x=1:length(child[2,]),y=child[2,],col="blue")

  model0 <- lm(unlist(child[1,])~seq(1,length(unlist(child[1,])),1))
  abline(model0,col="red",pch=23,lty=2)

  model1 <- lm(unlist(child[2,])~seq(1,length(unlist(child[2,])),1))
  abline(model1,col="blue",pch=23,lty=2)

  legend("topleft",c("Attempted","Correct"),col=c("red","blue"),lty=1,lwd=1)
} else {
  plot(1:length(child),child,type="l",xlab="Session",ylab=ylabel,main=title,col="red",xaxs="i",yaxs="i",ylim=c(floor(min(child)),ceiling(max(child))),xlim=c(1,length(child)),xaxp=c(1,length(child),length(child)-1),yaxt="n")# yaxp=c(floor(min(child)),ceiling(max(child)),10))
  axis(side=2,at=yticks,labels=ylabs)

  model <- lm(unlist(child)~seq(1,length(unlist(child)),1))
  abline(model,col="red",pch=23,lty=2)

}
grid(col="lightgray")
dev.off()
