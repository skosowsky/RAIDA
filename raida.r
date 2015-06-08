source("http://www.bioconductor.org/biocLite.R")

biocLite("limma")
	a
biocLite("qvalue")
	a
install.packages("http://cals.arizona.edu/~anling/software/RAIDA_1.0.tar.gz",repos=NULL,type="source")

library("BiocInstaller")
library("protoclust")
library("qvalue")
library("limma")
library("RAIDA")

###Set WD to location of input data
setwd("C:\\Users\\Sean\\Documents\\R\\Data\\Metagenomic-Analysis-master\\Original data")
filelist<-as.list(list.files("C:\\Users\\Sean\\Documents\\R\\Data\\Metagenomic-Analysis-master\\Original data",pattern=".csv"))
filenames<-list.files("C:\\Users\\Sean\\Documents\\R\\Data\\Metagenomic-Analysis-master\\Original data",pattern=".csv")
for (i in 1:length(filenames)) assign(filenames[[i]], read.csv(filenames[[i]]))
for (i in 1:length(filelist)){ 
filelist[[i]]<-as.data.frame(read.csv(filelist[[i]]))}
water<-c("PHYLLO09","PHYLLO10","PHYLLO11","PHYLLO13","PHYLLO15","PHYLLO21","PHYLLO23","PHYLLO26","PHYLLO27")
drought<-c("PHYLLO12","PHYLLO14","PHYLLO16","PHYLLO22","PHYLLO24","PHYLLO25","PHYLLO28","PHYLLO29")

filecount<-c(1,2,3,4,6,7)
waterlist<-list()
for(i in 1:6){
waterlist[[i]]<-as.data.frame(cbind(filelist[[filecount[i]]][,1],filelist[[filecount[i]]][,which(colnames(filelist[[filecount[i]]])[-1]==as.vector(filelist[[5]]$Sample_ID) & as.vector(filelist[[5]]$treatment)=="watered")+1]))
}

droughtlist<-list()
for(i in 1:6){
droughtlist[[i]]<-as.data.frame(cbind(filelist[[filecount[i]]][,which(colnames(filelist[[filecount[i]]])[-1]==as.vector(filelist[[5]]$Sample_ID) & as.vector(filelist[[5]]$treatment)=="drought")+1]))
}

ordereddata<-list()
for(i in 1:6){
ordereddata[[i]]<-as.data.frame(cbind(waterlist[[i]],droughtlist[[i]]))}

watercount<-vector(length=6)
for(i in 1:6){
watercount[i]<-dim(waterlist[[i]])[2]}

droughtcount<-vector(length=6)
for(i in 1:6){
droughtcount[i]<-dim(droughtlist[[i]])[2]}


for(i in 1:6){
rownames(ordereddata[[i]])<-ordereddata[[i]][,1]
ordereddata[[i]]<-ordereddata[[i]][-1]}

raida.list<-list()
for(j in 1:6){
raida.list[[j]]<-raida(ordereddata[[j]],c(9,8),show.ref.features = FALSE, show.all.features = FALSE, mtcm="BY", zsc = 0)}

filenames<-filenames[-5]
fnames<-vector(length=6)
for(i in 1:6){
fnames[i]<-paste("RAIDA.OUTPUT",filenames[i],sep=".")}
###Set to desired destination of output data
setwd("C:\\Users\\Sean\\Documents\\R\\Data\\Metagenomic-Analysis-master\\RAIDA output")
for(i in 1:6){
write.csv(raida.list[[i]],file=fnames[i],row.names=T)
}