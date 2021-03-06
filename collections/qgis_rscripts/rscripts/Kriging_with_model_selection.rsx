##Basic statistics=group
##Layer=vector
##Field=Field Layer
##Model=selection Exp;Log;Sph;Gau;Exc;Mat;Cir;Lin;Bes;Pen;Per;Wav;Hol;Leg;Ste
##Output_raster_cell_size=number 10
##Output_raster=output raster
##load_vector_using_rgdal
library(gstat)
library(rgl)
library(spatstat)
library(maptools)
# install.packages("pls")
library (pls)
library(automap)
library(raster)
Y<-as.factor(Layer[[Field]])
attribut<-as.data.frame(Y)
A<-as.numeric(Y)
for(j in (1:length(levels(Y))))
 for(i in 1:dim(attribut)[1]){
  if (attribut[i,1]==levels(Y)[j]){
   A[i]=j
 }
}
coords<-coordinates(Layer)
Mesure<- data.frame(LON=coords[,1], LAT=coords[,2], A)
coordinates(Mesure)<-c("LON","LAT")
Models<-c("Exp","Log","Sph","Gau","Exc","Mat","Cir","Lin","Bes","Pen","Per","Wav","Hol","Leg","Ste")
Model<-Model+1
select_model<-Models[Model]
MinX<-min(coords[,1])
MinY<-min(coords[,2])
MaxX<-max(coords[,1])
MaxY<-max(coords[,2])
Seqx<-seq(MinX, MaxX, by=Output_raster_cell_size)
Seqy<-seq(MinY, MaxY, by=Output_raster_cell_size)
MSeqx<-rep(Seqx, length(Seqy))
MSeqy<-rep(Seqy, length(Seqx))
MSeqy <- sort(MSeqy, decreasing=F)
Grille <- data.frame(X=MSeqx, Y=MSeqy)
coordinates(Grille)=c("X","Y")
gridded(Grille)<-TRUE
v<-autofitVariogram(A~1,Mesure,model = select_model)
prediction <-krige(formula=A~1, Mesure, Grille, model=v$var_model)
result<-raster(prediction)
proj4string(Layer)->crs
proj4string(result)<-crs
Output_raster<-result
