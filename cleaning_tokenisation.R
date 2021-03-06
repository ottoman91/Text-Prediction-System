# cleaning and tokenising data 

load("totalData.Rdata") 


# remove all symbols except endmarks, and other necessary marks
Data <- gsub("[^a-zA-Z0-9@'???\\$\\.\\?\\!_ \\-]", "", Data)

# replace email with <email>, replace website with <website>
emailExp <- "[-a-zA-Z0-9_.%]+@[-a-zA-Z0-9_.%]+\\.[a-zA-Z]+"
Data <- gsub(emailExp, "<email>", Data)
websiteExp <- "http:[-a-zA-Z0-9/_.%\\?]+"
Data <- gsub(websiteExp, "<website>", Data)

# replace numbers with <num>
numExp <- "-*[0-9]+((\\.|/|\\-|\\:)[0-9]+)*"   # represent all numbers                    
Data <- gsub(numExp, "<num>", Data)
Data <- gsub("( | -)\\.<num>", " <num>", Data) 

Data <- gsub("\\.+", "\\.", Data) 

# remove all _ - signs except dash in words.
Data <- gsub("_+", " ", Data)
Data <- gsub("(([^a-zA-Z0-9>]-+[^a-zA-Z0-9<])|(^-+)|([^a-zA-Z0-9>]-+)|(-+[^a-zA-Z0-9<])|(-+$))+", " ", Data) 


# remove single quote, but preserve apostrophe in the format like "John's"
apossExp <- "('|???)s "   # replace all apostrophe like 's  with <aposs>
apostExp <- "n('|???)t "  # replace all apostrophe like n't with <apost>
apost2Exp <- "n('|???)t\\." # replace all apostrophe like n't. with <apost2>
aposmExp <- "[Ii]('|???)m "  # replace all apostrophe like i'm with <aposm>
aposlExp <- "('|???)ll "  # replace all apostrophe like 'll with <aposl>
aposrExp <- "('|???)re "   # replace all apostrophe like 're with <aposr>
aposdExp <- "('|???)d "    # replace all apostrophe like 'd with <aposd>
aposvExp <- "('|???)ve "   # replace all apostrophe like 've with <aposv>


Data <- gsub(apossExp, "<aposs>", Data)
Data <- gsub(apostExp, "<apost>", Data)
Data <- gsub(apost2Exp, "<apost2>", Data)
Data <- gsub(aposmExp, "<aposm>", Data)
Data <- gsub(aposlExp, "<aposl>", Data)
Data <- gsub(aposrExp, "<aposr>", Data)
Data <- gsub(aposdExp, "<aposd>", Data)
Data <- gsub(aposvExp, "<aposv>", Data) 

punctMarks <- "'+|???+" 

Data <- gsub(punctMarks, "", Data) 


# since most of the punctuations cleared, now it's time to restore back the apostrophes.
Data <- gsub("<aposs>", "'s ", Data)
Data <- gsub("<apost>", "n't ", Data)
Data <- gsub("<apost2>", "n't.", Data)
Data <- gsub("<aposm>", "I'm ", Data)
Data <- gsub("<aposl>", "'ll ", Data)
Data <- gsub("<aposr>", "'re ", Data)
Data <- gsub("<aposd>", "'d ", Data)
Data <- gsub("<aposv>", "'ve ", Data)

Data <- gsub(" +", " ", Data)
Data <- gsub("^ | $", "", Data)  

#the cleaned data is saved till here for this stage
save(Data, file = "cleanTotalData.RData")

#data was loaded again in the Data object.
#continue further cleaning and tokenisation now. 

# eliminate the endmarks
Data <- gsub("\\!|\\?", "", Data)

Data <- gsub("([Jj]an\\.)|([Jj]an )", "January ", Data)
Data <- gsub("([Ff]eb\\.)|([Ff]eb )", "February ", Data)
Data <- gsub("([Mm]ar\\.)|([Mm]ar )", "March ", Data)
Data <- gsub("([Aa]pr\\.)|([Aa]pr )", "Apirl ", Data)
Data <- gsub("([Mm]ay\\.)|([Mm]ay )", "May ", Data)
Data <- gsub("([Jj]un\\.)|([Jj]un )", "June ", Data)
Data <- gsub("([Jj]ul\\.)|([Jj]ul )", "July ", Data)
Data <- gsub("([Aa]ug\\.)|([Aa]ug )", "August ", Data)
Data <- gsub("([Ss]ep\\.)|([Ss]ep )", "September ", Data)
Data <- gsub("([Oo]ct\\.)|([Oo]ct )", "October ", Data)
Data <- gsub("([Nn]ov\\.)|([Nn]ov )", "November ", Data)
Data <- gsub("([Dd]ec\\.)|([Dd]ec )", "December ", Data)

Data <- gsub("\\.+$", "", Data)
Data <- gsub(" +", " ", Data) 

# separate out training and validation sets.
set.seed(141122)
sel <- rbinom(length(Data), 1, 0.6)
sel <- (sel == 1)
training <- Data[sel]
validation <- Data[!sel] 

file.create("training.txt")
file.create("validation.txt") 
con <- file('training.txt', "w")
writeLines(training, con, sep = "\n")
close(con) 
con <- file('validation.txt', "w")
writeLines(validation, con, sep = "\n")
close(con)
rm(sel)
rm(validation)

#create bi-grams and display on histogram
Bigram<- NGramTokenizer(training, Weka_control(min = 2, max = 2))
freq.Bigram <- data.frame(table(Bigram))
sort.Bigram <- freq.Bigram[order(freq.Bigram$Freq,decreasing = TRUE),]
Bigram_top10<-head(sort.Bigram,10)
barplot(Bigram_top10$Freq, names.arg = Bigram_top10$Bigram, border=NA, las=2, main="Top 10 Most Frequent BiGrams", cex.main=2,col = "pink")

#create tri-grams and display on histogram
Trigram<- NGramTokenizer(dat, Weka_control(min = 3, max = 3))
freq.Trigram <- data.frame(table(Trigram))
sort.Trigram <- freq.Trigram[order(freq.Trigram$Freq,decreasing = TRUE),]
Trigram_top10<-head(sort.Trigram,10)
barplot(Trigram_top10$Freq, names.arg = Trigram_top10$Trigram, border=NA, las=2, main="Top 10 Most Frequent TriGrams", cex.main=2,col = "orange")


