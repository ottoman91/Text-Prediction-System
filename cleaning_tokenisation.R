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



