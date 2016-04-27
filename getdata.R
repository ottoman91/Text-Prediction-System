#load specific libraries
suppressPackageStartupMessages(library(tm))
suppressPackageStartupMessages(library(NLP))

#unzip file 
dataUrl <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(dataUrl, destfile = "Coursera-SwiftKey.zip", method = "wget")
unzip("Coursera-SwiftKey.zip",exdir="./") 
#set working directory
setwd("./final") 
setwd("./en_US/")
#create connections for all files
samplingFile <- function(filename, prob) {
  incon <- file(paste("en_US.", filename, ".txt",sep=""),"r")
  file <- readLines(incon)
  # sampling by rbinom()
  set.seed(123)
  sample_file <- file[rbinom(n = length(file), size = 1, prob = prob) == 1]
  close(incon)
  
  # Write out the sample file to the local file to save it
  outCon <- file(paste("sample_", filename, ".txt",sep=""), "w")
  writeLines(sample_file, con = outCon)
  close(outCon)
} 

#create the sample files for all three files
samplingFile("blogs", 0.2) 
samplingFile("news",0.2) 
samplingFile("twitter",0.2)  

#create the R Data frames for each line
twitter_file <- file("sample_twitter.txt", "r") 
twitterData <- readLines(twitter_file) 
close(twitter_file) 
#save(twitterData, file = "twitterData.RData") 

news_file <- file("sample_news.txt", "r")
newsData <- readLines(news_file)
close(news_file)
#save(newsData, file = "newsData.RData") 

blogs_file <- file("sample_blogs.txt", "r")
blogsData <- readLines(blogs_file)
close(blogs_file)
#save(blogsData, file="blogsData.RData") 
#for saving all datasets in a single RData structure
Data <- c(twitterData,newsData,blogsData)

save(Data,file="totalData.Rdata" )
