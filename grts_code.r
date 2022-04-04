rm(list=ls())
## library(rgdal)
library(raster)
library(rgeos)
library(terra)
library(spsurvey)
library(tidyverse)
library(sf)

setwd("C:/Users/rah10/Dropbox (University of Oregon)/bees_and_fire2022/")

#read in shape file
FireNames <- sf::read_sf("SeverityMerge_220308")

#make into S4 type (i think we don't need to do this actually)
#FireNames <- sf::st_read("SeverityMerge_220308")

#filter by each fire

Holiday <- FireNames[FireNames$Fire_Name == 'Holiday' , ]
Holiday_att <- st_set_geometry(Holiday, NULL)

Beachie <- FireNames[FireNames$Fire_Name == 'Beachie', ]
Beachie_att <- st_set_geometry(Beachie, NULL)

Claremont <- FireNames[FireNames$Fire_Name == 'Claremont', ]
Claremont_att <- st_set_geometry(Claremont, NULL)

Dixie <- FireNames[FireNames$Fire_Name == 'Dixie', ]
Dixie_att <- st_set_geometry(Dixie, NULL)

Riverside <- FireNames[FireNames$Fire_Name == 'Riverside', ]
Riverside_att <- st_set_geometry(Riverside, NULL)

Unburned <- FireNames[FireNames$Fire_Name == 'Unburned', ]
Unburned_att <- st_set_geometry(Unburned, NULL)

#do both with age strata and without age strata
#calculate isolation between classes after grts (a nice histogram or flat, skewed right, not bell shaped!)




#read in the legacy sites from 2021 (converted into points)
sites2021 <- sf::read_sf("stands2021_points.shp")

#convert shapefile into sf object
#crs = coordinate frame; use sf::st_transform() to move btwn coordinate frames. 
#all 2021 shapefiles should be Albers 1983 projection (crs 3310)
#sites2021geo <- st_as_sf(sites2021, coords = c("x", "y"), crs = 3310)
sites2021geo <- st_as_sf(sites2021, coord_sf(geom_sf(geometry)))

#filter out only Sierra Nevada sites 
legacy2021 <- filter(sites2021geo, Watershed%in%c("W58MoodyMd", "W59Sheepca", "W60Rock", "W61Willow", "W62Poplar"))



#convert all fires to sf object

Beachie_geo <- st_as_sf(Beachie, coord_sf(geom_sf(geometry)))
Claremont_geo <- st_as_sf(Claremont, coord_sf(geom_sf(geometry)))
Dixie_geo <- st_as_sf(Dixie, coord_sf(geom_sf(geometry)))
Holiday_geo <- st_as_sf(Holiday, coord_sf(geom_sf(geometry)))
Riverside_geo <- st_as_sf(Riverside, coord_sf(geom_sf(geometry)))
Unburned_geo <- st_as_sf(Unburned, coord_sf(geom_sf(geometry)))


#1. Design for Beachie; each strata will be unique number from Strata column


design <-list(
  '100' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '101' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '102' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '103' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '104' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '105' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '106' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '107' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '108' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '109' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '172' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '173' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '174' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '175' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '176' = list(panel=c(set1=1), seltype="Equal", over=1),
  '177' = list(panel=c(set1=1), seltype="Equal", over=1),
  '178' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '179' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '180' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '181' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '182' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '183' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '184' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '185' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '186' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '22' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '23' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '24' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '246' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '247' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '248' = list(panel=c(set1=1), seltype="Equal", over=1),
  '249' = list(panel=c(set1=1), seltype="Equal", over=1),
  '25' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '250' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '251' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '252' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '253' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '254' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '255' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '256' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '26' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '27' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '28' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '29' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '30' = list(panel=c(set1=1), seltype="Equal", over=1),
  '31' = list(panel=c(set1=1), seltype="Equal", over=1),
  '32' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '33' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '34' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '35' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '95' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '96' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '97' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '98' = list(panel=c(set1=1), seltype="Equal", over=1), 
  '99' = list(panel=c(set1=1), seltype="Equal", over=1)
)




## GRTS code
beachie_grts <- grts(sframe = Beachie_geo, 
                     n_base = unlist(design), #have to unlist  because error :'list' object cannot be coerced to type 'double'
                     stratum_var='Strata')

#error message: stratum :  Not all stratum values are in sample frame. 
#HOWEVER, I double checked the design length and the size of the list of strata in the severitymerge file and visually compared all of the numbers but still getting the error....