rm(list=ls())
set.seed(9)
library(terra)
library(spsurvey)
library(tidyverse)
library(sf)

## rebecca
## setwd("C:/Users/rah10/Dropbox (University of Oregon)/")

## Lauren mac pro
setwd("/Volumes/bombus/Dropbox (University of Oregon)/")

## Jesse

setwd("pnw_survey_saved/")

grts.save.dir <- "spatial_data"

source("../pnw_survey/src/grts_design_2022.R")
source("../pnw_survey/src/site_select_grts.R")

## read in shape file of the 2020 and other fires in OR and CA
fire_polygons <- sf::read_sf("spatial_data/FireMerge_Final")

## read in the legacy sites from 2021 (already converted into points)
sites2021 <- sf::read_sf("spatial_data/NCASI_GIS_2022/2021stands_points.shp")

## change crs to match Firenames
sites2021 <- st_transform(sites2021, st_crs(fire_polygons))

## get rid of random bad sites with no x y
sites2021 <- sites2021[!is.na(sites2021$Watershed),]

## subset sites to the watersheds with in each fire
holiday_watersheds <- c("W56Johnson", "W57Ritchie", "W55Indian")
dixie_watersheds <- c("W58MoodyMd", "W59Sheepca", "W62Poplar",  "W60Rock")
claremont_watersheds <- c("W61Willow")
beachie_watersheds <- c("W50Pine", "W51Molalla")
## there are no sites from 2021 in the riverside fire


claremont_grts <- site_select_grts(all_legacy_sites = sites2021,
                                   watersheds= claremont_watersheds,
                                   all_fire_polygons = fire_polygons,
                                   fire.name = "Claremont",
                                   design_vector = claremont_design,
                                   save.dir  = grts.save.dir,
                                   caty_list = claremont_caty)


holiday_grts <- site_select_grts(all_legacy_sites = sites2021,
                                 watersheds= holiday_watersheds,
                                 all_fire_polygons = fire_polygons,
                                 fire.name = "Holiday",
                                 design_vector = holiday_design,
                                 save.dir  = grts.save.dir,
                                 caty_list = holiday_caty)


dixie_grts <- site_select_grts(all_legacy_sites = sites2021,
                               watersheds= holiday_watersheds,
                               all_fire_polygons = fire_polygons,
                               fire.name = "Dixie",
                               design_vector = dixie_design,
                               save.dir  = grts.save.dir,
                               caty_list = dixie_caty)

beachie_grts <- site_select_grts(all_legacy_sites = sites2021,
                                 watersheds= beachie_watersheds,
                                 all_fire_polygons = fire_polygons,
                                 fire.name = "Beachie",
                                 design_vector = beachie_design,
                                 save.dir  = grts.save.dir,
                                 caty_list = beachie_caty)

## not passing in legacy sites because there were none samples in 2021
riverside_grts <- site_select_grts(all_fire_polygons = fire_polygons,
                                   fire.name = "Riverside",
                                   design_vector = riverside_design,
                                   save.dir  = grts.save.dir,
                                   caty_list = riverside_caty)






