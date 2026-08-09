#setwd("C:/Users/ASUS/Desktop/postdoc/Cx_pipiens")
setwd("/Users/huiqing/Documents/Cx_pipiens/angsd/b6/pcangsd/")
rm(list=ls())
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(ggpubr)

title<-"b6 - 74 samples - 5,947,997 sites (minMaf 0.05) - pcangsd"

# R script for plotting PCA from pcangsd
m <- as.matrix(read.table("b6_k2.cov"))
e <- eigen(m)
eigen.values<-e$values
pc1.val<-format(round(((eigen.values[1]/sum(eigen.values))*100),digits=2),nsmall=2)
pc2.val<-format(round(((eigen.values[2]/sum(eigen.values))*100),digits=2),nsmall=2)
pc3.val<-format(round(((eigen.values[3]/sum(eigen.values))*100),digits=2),nsmall=2)
pc4.val<-format(round(((eigen.values[4]/sum(eigen.values))*100),digits=2),nsmall=2)

eigen.vectors<-e$vectors
pop <-read.table("pop74.txt", sep="\t", header=TRUE) # read in pop file
pca.dat <- cbind(pop,eigen.vectors[,c(1,2,3,4)]) # combine datasets
names(pca.dat)[8]<-paste("pc1"); names(pca.dat)[9]<-paste("pc2");names(pca.dat)[10]<-paste("pc3");names(pca.dat)[11]<-paste("pc4") 
pca.dat$spp<-as.factor(pca.dat$spp); pca.dat$indv<-as.factor(pca.dat$indv)
pca.dat$localityState<-as.factor(pca.dat$localityState)
#col=brewer.pal(n=12, name="Paired")
col=c("#A6CEE3","#1F78B4","#1F78B4","#1F78B4","#B2DF8A","#33A02C","#FB9A99","#E31A1C","#FDBF6F","#FF7F00","#CAB2D6","#6A3D9A","#FFFF99","#B15928")

p1.2<-ggplot(pca.dat, aes(x=pc1, y=pc2,label=indv,shape=spp,fill=localityState))+
  geom_point(size=3, color="black")+ 
  xlab(paste0("PC1 (",pc1.val,"%)")) + ylab(paste0("PC2 (",pc2.val,"%)"))+
  #geom_label_repel(aes(label=indv))+
  scale_shape_manual(values=c(21,24,22))+
  scale_fill_manual(values=col)+
  #ggtitle("b6 - 74 samples - 5,947,997 sites - pcangsd")+
  guides(fill = guide_legend(override.aes = list(shape=21)))+
  theme_bw()
p1.2

p1.3<-ggplot(pca.dat, aes(x=pc1, y=pc3, shape=spp, fill= localityState))+
  geom_point(size=3, color="black")+ 
  xlab(paste0("PC1 (",pc1.val,"%)")) + ylab(paste0("PC3 (",pc3.val,"%)"))+
  #geom_label_repel(aes(label=indv))+
  scale_shape_manual(values=c(21,24,22))+
  scale_fill_manual(values=col)+
  #ggtitle("b6 - 74 samples - 5,947,997 sites - pcangsd")+
  guides(fill = guide_legend(override.aes = list(shape=21)))+
  theme_bw()
p1.3

p1.4<-ggplot(pca.dat, aes(x=pc1, y=pc4, shape=spp, fill= localityState))+
  geom_point(size=3, color="black")+ 
  xlab(paste0("PC1 (",pc1.val,"%)")) + ylab(paste0("PC4 (",pc4.val,"%)"))+
  #geom_label_repel(aes(label=indv))+
  scale_shape_manual(values=c(21,24,22))+
  scale_fill_manual(values=col)+
  #ggtitle("b6 - 74 samples - 5,947,997 sites - pcangsd")+
  guides(fill = guide_legend(override.aes = list(shape=21)))+
  theme_bw()
p1.4

p3.4<-ggplot(pca.dat, aes(x=pc3, y=pc4, shape=spp, fill= localityState))+
  geom_point(size=3, color="black")+ 
  xlab(paste0("PC3 (",pc3.val,"%)")) + ylab(paste0("PC4 (",pc4.val,"%)"))+
  #geom_label_repel(aes(label=indv))+
  #scale_fill_manual(values=c('#999999',"#3B528BFF", "#21908CFF","#FDE725FF"))+
  scale_shape_manual(values=c(21,24,22))+
  scale_fill_manual(values=col)+
  #ggtitle("b6 - 74 samples - 5,947,997 sites - pcangsd")+
  guides(fill = guide_legend(override.aes = list(shape=21)))+
  theme_bw()
p3.4

pdf("pcangsd_b6_pca.pdf", width=16, height=10)
plot<-ggarrange(p1.2,p1.3,p1.4,p3.4,
          ncol=2,nrow=2, #labels=c("A","B"),
          common.legend = TRUE, legend="right")
annotate_figure(plot, top = text_grob(paste0(title), size = 14, face="bold"))
dev.off()



