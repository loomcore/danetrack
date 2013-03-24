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
from <- args[4] # TODO: need to convert from date to col. index
to <- args[5]   # TODO: need to convert from date to col. index

weeks <- c(1:8) # c(from:to)

if (type == "MeanAttempt") {
  for(i in seq(1, length(marks[,1]), by=3)) {
    # do something
  }
} else if (type == "MeanRate") {
  for(i in seq(1, length(marks[,1]), by=3)) {
    # do something else
  }
} else {
  for(i in seq(1, length(marks), by=3)) {
    if (name == marks[i,1]) {
      switch(type,
        "Ratio" = child <- marks[i+1,3:10]/marks[i,3:10],
        "AttemptRate" = child <- marks[i,3:10]/marks[i+2,3:10],
        "CorrectRate" = child <- marks[i+1,3:10]/marks[i+2,3:10],
        "Combined" = child <- rbind(marks[i,3:10],marks[i+1,3:10]),
        "CombinedRate" = child <- rbind(marks[i,3:10]/marks[i+2,3:10],marks[i+1,3:10]/marks[i+2,3:10]),
        "Attempted" = child <- marks[i,3:10],
        "Correct" = child <- marks[i+1,3:10],
        "Time" = child <- marks[i+2,3:10])
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

png(fh)
# 1:length(child) has replaced weeks and 8 to accommodate removed NAs
if ((type == "Combined") || (type == "CombinedRate")) {
  plot(1:length(child[1,]),child[1,],type="l",xlab="Session",ylab=ylabel,main=title,col="red",xaxs="i",yaxs="i",ylim=c(0,ceiling(max(child))),xlim=c(1,length(child[1,])))
  lines(x=1:length(child[2,]),y=child[2,],col="blue")
  legend("topleft",c("Attempted","Correct"),col=c("red","blue"),lty=1,lwd=1)
} else {
  plot(1:length(child),child,type="l",xlab="Session",ylab=ylabel,main=title,col="red",xaxs="i",yaxs="i",ylim=c(0,ceiling(max(child))),xlim=c(1,length(child)))
}
grid(col="lightgray")
dev.off()
