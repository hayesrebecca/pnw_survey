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



#ignore unbured for now
#Unburned <- FireNames[FireNames$Fire_Name == 'Unburned', ]
#Unburned_att <- st_set_geometry(Unburned, NULL)

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
###break up dixie and holiday farm
## this legacy2021 is just for dixie
#legacy2021 <- filter(sites2021geo, Watershed%in%c("W58MoodyMd", "W59Sheepca", "W60Rock", "W61Willow", "W62Poplar"))



#convert all fires to sf object
#Unburned_geo <- st_as_sf(Unburned, coord_sf(geom_sf(geometry)))





## 4-4-2022
#for claremont (only need 10 so should be simple, only one owner)
#filter to just include claremont sites
Claremont <- FireNames[FireNames$Fire_Name == 'Claremont', ]
#Claremont_att <- st_set_geometry(Claremont, NULL)
Claremont_geo <- st_as_sf(Claremont, coord_sf(geom_sf(geometry)))


strata_n <- c('46' = 4, '47' = 4, '124' = 4, '125' = 4, '201' = 4, '202' = 4, '267' = 4)
strat_eqprob <- grts(Claremont_geo, n_base = strata_n, stratum_var = "Strata")
sp_plot(strat_eqprob, Claremont_geo, key.width = lcm(3), fill=Claremont_geo$Fire_Sev)

#for beachie
Beachie <- FireNames[FireNames$Fire_Name == 'Beachie', ]
#Beachie_att <- st_set_geometry(Beachie, NULL)
Beachie_geo <- st_as_sf(Beachie, coord_sf(geom_sf(geometry)))

design_beachie <-c(
  '100' = 2, 
  '101' = 2, 
  '102' = 2, 
  '103' = 2, 
  '104' = 2, 
  '105' = 2, 
  '106' = 2, 
  '107' = 2, 
  '108' = 2, 
  '109' = 2, 
  '172' = 2, 
  '173' = 2, 
  '174' = 2, 
  '175' = 2, 
  '176' = 2,
  '177' = 2,
  '178' = 2, 
  '179' = 2, 
  '180' = 2, 
  '181' = 2, 
  '182' = 2, 
  '183' = 2, 
  '184' = 2, 
  '185' = 2, 
  '186' = 2, 
  '22' = 2, 
  '23' = 2, 
  '24' = 2, 
  '246' = 2, 
  '247' = 2, 
  '248' = 2,
  '249' = 2,
  '25' = 2, 
  '250' = 2, 
  '251' = 2, 
  '252' = 2, 
  '253' = 2, 
  '254' = 2, 
  '255' = 2, 
  '256' = 2, 
  '26' = 2, 
  '27' = 2, 
  '28' = 2, 
  '29' = 2, 
  '30' = 2,
  '31' = 2,
  '32' = 2, 
  '33' = 2, 
  '34' = 2, 
  '35' = 2, 
  '95' = 2, 
  '96' = 2, 
  '97' = 2, 
  '98' = 2, 
  '99' = 2
)
beachie_grts <- grts(Beachie_geo, n_base = design_beachie, stratum_var = "Strata")
sp_plot(beachie_grts, Beachie_geo, key.width = lcm(3))



#dixie
Dixie <- FireNames[FireNames$Fire_Name == 'Dixie', ]
Dixie_geo <- st_as_sf(Dixie, coord_sf(geom_sf(geometry)))

strata_dixie <- c('1' = 2,
              '151' = 2, 
              '152' = 2,
              '153' = 2,
              '154' = 2,
              '155' = 2,
              '2' = 2,
              '228' = 2,
              '229' = 2, 
              '230' = 2,
              '231' = 2,
              '232' = 2,
              '3' = 2,
              '4' = 2,
              '5' = 2,
              '74' = 2, 
              '73' = 2,
              '75' = 2,
              '76' = 2,
              '77' = 2)
dixie_eqprob <- grts(Dixie_geo, n_base = strata_dixie, stratum_var = "Strata")
sp_plot(dixie_eqprob, Dixie_geo, key.width = lcm(3))

#riverside
Riverside <- FireNames[FireNames$Fire_Name == 'Riverside', ]
Riverside_geo <- st_as_sf(Riverside, coord_sf(geom_sf(geometry)))

#holiday
Holiday <- FireNames[FireNames$Fire_Name == 'Holiday' , ]
Holiday_geo <- st_as_sf(Holiday, coord_sf(geom_sf(geometry)))

