
library(tidyverse)
library(readr)
library("stringr")

#######################
### altair data munging
#######################

file_names <- dir("/eco/04") 
df_4 <- as.data.frame(do.call(rbind, lapply(file_names, function(x) cbind(read.csv(x)[ ,1], day=strsplit(x,'\\.')[[1]][1]))))
df_4$V1=as.numeric(df_4$V1)
ave_sm4<-aggregate(as.numeric(df_4$V1), list(df_4$day), FUN=mean)
names(ave_sm4)<-c("Date","avg_powerallphases")
ave_sm4$household<-4
rm(df_4)
setwd("/eco/05")
file_names <- dir("eco/05 2") 
df_5 <- as.data.frame(do.call(rbind, lapply(file_names, function(x) cbind(read.csv(x)[ ,1], day=strsplit(x,'\\.')[[1]][1]))))
df_5$V1=as.numeric(df_5$V1)
ave_sm5<-aggregate(as.numeric(df_5$V1), list(df_5$day), FUN=mean)
names(ave_sm5)<-c("Date","avg_powerallphases")
ave_sm5$household<-5
rm(df_5)

file_names <- dir("/eco/06") 
df_6 <- as.data.frame(do.call(rbind, lapply(file_names, function(x) cbind(read.csv(x)[ ,1], day=strsplit(x,'\\.')[[1]][1]))))
df_6$V1=as.numeric(df_6$V1)
ave_sm6<-aggregate(as.numeric(df_6$V1), list(df_6$day), FUN=mean)
names(ave_sm6)<-c("Date","avg_powerallphases")
ave_sm6$household<-6
rm(df_6)

new<-rbind(ave_sm4,ave_sm5,ave_sm6)
write.csv(df,"combine_avgsm.csv",row.names = FALSE)

#######################
### plotly data munging
#######################

files <- list.files("eco/04/",recursive=T) 

df_4 <- as.data.frame(do.call(rbind, lapply(files, function(x) cbind(read.csv(x)[ ,1], day=strsplit(x,'\\.')[[1]][1]))))
df_new<-as.data.frame(str_split_fixed(df_4$day, "/", 2))
names(df_new)<-c("Plug","Date")
df_new$Power<-df_4$V1
df_new$Plug_Category<-df_new%>%ifelse(Plug=="01","Fridge","Entertainment")

df_new4 <- df_new %>% 
  mutate(Plug_Category = if_else(Plug=="01","Fridge","Entertainment"))
df_new%>%count(Plug_Category)
write.csv(df_new4,"plug4.csv",row.names = FALSE)

############################################################
setwd("eco/05/")
files <- list.files("eco/05/",recursive=T) 
df_5 <- as.data.frame(do.call(rbind, lapply(files, function(x) cbind(read.csv(x)[ ,1], day=strsplit(x,'\\.')[[1]][1]))))
df_new<-as.data.frame(str_split_fixed(df_5$day, "/", 2))
names(df_new)<-c("Plug","Date")
df_new$Power<-df_5$V1
df_new <- df_new %>% 
  mutate(Plug_Category = if_else(Plug=="05","Fridge","Entertainment"))
df_new5<-df_new[,2:4]
df_new5%>%count(Plug_Category)
write.csv(df_new5,"plug5.csv",row.names = FALSE)

############################################################
setwd("eco/06/")
files <- list.files("eco/06/",recursive=T) 
df_6 <- as.data.frame(do.call(rbind, lapply(files, function(x) cbind(read.csv(x)[ ,1], day=strsplit(x,'\\.')[[1]][1]))))
df_new<-as.data.frame(str_split_fixed(df_6$day, "/", 2))
names(df_new)<-c("Plug","Date")
df_new$Power<-df_6$V1
df_new <- df_new %>% 
  mutate(Plug_Category = if_else(Plug=="06","Fridge","Entertainment"))
df_new6<-df_new[,2:4]
df_new%>%count(Plug_Category)

write.csv(df_new6,"plug6.csv",row.names = FALSE)

############################################
### add seconds to daily data
############################################

df_4<-read.csv("plug4.csv")
df_4<-df_4[,2:4]
sum_plug4<-df_4 %>%
  group_by(Date, Plug_Category) %>%
  summarise(PowerPerDay = sum(Power))
sum_plug4$Household<-4

df_5<-read.csv("plug5.csv")
sum_plug5<-df_5 %>%
  group_by(Date, Plug_Category) %>%
  summarise(PowerPerDay = sum(Power))
sum_plug5$Household<-5

df_6<-read.csv("plug6.csv")
sum_plug6<-df_6 %>%
  group_by(Date, Plug_Category) %>%
  summarise(PowerPerDay = sum(Power))
sum_plug6$Household<-6

# rm(df_6)
#rm(df_5)
# rm(df_4)

sum_plug<-rbind(sum_plug4,sum_plug5,sum_plug6)
sum_plug$Date <- as.Date(sum_plug$Date , format = "%Y-%m-%d")
sum_plug$Plug_Category<-as.factor(sum_plug$Plug_Category)
sum_plug$Household<-as.factor(sum_plug$Household)
write.csv(sum_plug,"sum_plug.csv",row.names = FALSE)


