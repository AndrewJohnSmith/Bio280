#Run this when you first download R.
install.packages(c("geiger", "qpcR", "phytools", "ouch", "ape", "OUwie", "picante", "parallel", "surface", "auteur"))
#Once all are installed (R will do this for you) you no longer have to worry about them.

setwd("/Users/Home/Dropbox/Amherst/TeachingAssistant/Fall2013/Honors/Bio280")
source("Bio280_SOURCE.R")

Files<-MakeFiles()


#Your tree and data is stored as 'Tree' and 'Data' respectively.
Tree<-Files[[1]]
Data<-Files[[2]]

#Standardize variables against standard length
Standardize(Data, "Measurement_1", "StLength")


#Geiger Evolutionary Models#
#Single variable
MyModels<-GeigerModels(Tree, Data, "preorb.siz")
#View results
MyModels

#OUCH Evolutionary Models#
#Single Variable
MyOUCHModels<-OuchModels(Tree, Data, "preorb.siz", "Habitat")
#View results
MyOUCHModels

#OUwie Evolutionary Models#
#Generate trees with stocastically mapped characters.
MySimTrees<-SimmapTrees(Tree, Data, "Diet", 5)

#View the first four of those character change trees.
PlotSimTreeDiet(MySimTrees, 0.6)
PlotSimTreeHabitat(MySimTrees, 0.6)

#Perform the OU analysis with your recently generated trees.
#Run the analysis over multiple cores to speed it up.
MyOUwieModels<-OUwieModelsMC(MySimTrees, Data, "preorb.siz", "Diet", "OUM")
#View results
MyOUwieModels

##Diet##
FinalOutput<-CollateOUwieNormDiet(MyOUwieModels)

##Habitat##
FinalOutput<-CollateOUwieNormHabitat(MyOUwieModels)


#Cannot use "Trait" here, need to insert the column number(s) that your data is in.
#For just a single trait use Data[,columnnumber] e.g...
DispData<-Disparity(Tree, Data, Data[,3])

#Or
#use Data[,column-number-start:column-number-end]
DispDatas<-Disparity(Tree, Data, Data[,3:4])


#Correlations in evolutionary rate along the tree
Rate.Shifts(Tree, Data, "ma", Ngens=1000)
Rate.Correlation(Tree, Data, "ma", "preorb.siz")
#Sometimes Trait.Correlation wont run - try a couple of different trait combinations.
Trait.Correlation(Tree, Data, "ma", "preorb.siz")

#Plotting Extras
AncestralMap(Tree, Data, "ma")
PMorphospace(Tree, Data, Habitat, preorb.siz, ma)


#Difficult to use
ConvergentTest<-SURFACE(Tree, Data, Data[,3:4])



## :(  ##
#Problem scripts#

#Advanced OUwie models. Many of these will saddle.
MyOUwieModels<-OUwieModelsMC(MySimTrees, Data, "preorb.siz", "Diet", "OUMV")
#View results
MyOUwieModels

#Saving results - use diet if you used the diet regime.
#Use if objective function may be at a saddle point
FinalOutput<-CollateOUwieEigHabitat(MyOUwieModels)
FinalOutput<-CollateOUwieEigDiet(MyOUwieModels)

#You may be able to use this if all converged.
FinalOutput<-CollateOUwieNormDiet(MyOUwieModels)
FinalOutput<-CollateOUwieNormHabitat(MyOUwieModels)

#Descripts of the models you can run in place of "OUM".#
#model=OU1  a single peak Ornstein-Uhlenbeck model across the entire tree.
#model=OUM  a multi-peak Ornstein-Uhlenbeck model with different optima (theta) for each regime.
#model=OUMV  a multi-peak Ornstein-Uhlenbeck model with different optima (theta) and different Brownian rate parameter (sigma2) for each regime.
#model=OUMA  a multi-peak Ornstein-Uhlenbeck model with different optima (theta) and different strength of selection parameter (alpha) for each regime.
#OUMA didn't seem to run to completion.
#model=OUMVA  a multi-peak Ornstein-Uhlenbeck model with different optima (theta), different Brownian rate parameter (sigma2), and different strength of selection parameter (alpha) for each regime.
#OUMVA rarely has enough information to work.