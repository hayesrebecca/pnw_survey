rm(list=ls())

set.seed(1234567890)

library(terra)
library(spsurvey)
library(tidyverse)
library(sf)

## rebecca
## setwd("C:/Users/rah10/Dropbox (University of Oregon)/")

## Lauren mac pro
setwd("/Volumes/bombus/Dropbox (University of Oregon)/")
## setwd("~/Dropbox (University of Oregon)/")

## Jesse

setwd("pnw_survey_saved/")

grts.save.dir <- "spatial_data"

source("../pnw_survey/src/grts_design_2022.R")
source("../pnw_survey/src/site_select_grts.R")

load(file="spatial_data/finalSpData/firePolygons.Rdata")
load(file="spatial_data/finalSpData/grts2021Sites.Rdata")

## subset sites to the watersheds with in each fire
holiday_watersheds <- c("W56Johnson", "W57Ritchie", "W55Indian")
dixie_watersheds <- c("W58MoodyMd", "W59Sheepca", "W62Poplar",  "W60Rock")
claremont_watersheds <- c("W61Willow")
beachie_watersheds <- c("W50Pine", "W51Molalla")
## there are no sites from 2021 in the riverside fire

## we are treating all public land owners (USFS, BLM, STATE) are one
## owner. We are sampling all the legacy sites fom 2021 so they are
## included in the design. Intention is to sample high of different
## distances, some moderate as "sources".

claremont_grts <- site_select_grts(all_legacy_sites = sites_grts,
                                   watersheds= claremont_watersheds,
                                   all_fire_polygons = fire_polygons_diss,
                                   fire.name = "Claremont",
                                   design_vector = claremont_design,
                                   save.dir  = grts.save.dir
                                   )


holiday_grts <- site_select_grts(all_legacy_sites = sites_grts,
                                 watersheds= holiday_watersheds,
                                 all_fire_polygons = fire_polygons_diss,
                                 fire.name = "Holiday",
                                 design_vector = holiday_design,
                                 save.dir  = grts.save.dir
                                 )


dixie_grts <- site_select_grts(all_legacy_sites = sites_grts,
                               watersheds= dixie_watersheds,
                               all_fire_polygons = fire_polygons_diss,
                               fire.name = "Dixie",
                               design_vector = dixie_design,
                               save.dir  = grts.save.dir
                               )

beachie_grts <- site_select_grts(all_legacy_sites = sites_grts,
                                 watersheds= beachie_watersheds,
                                 all_fire_polygons = fire_polygons_diss,
                                 fire.name = "Beachie",
                                 design_vector = beachie_design,
                                 save.dir  = grts.save.dir
                                 )

## not passing in legacy sites because there were none samples in 2021
## riverside_grts <- site_select_grts(all_fire_polygons = fire_polygons_diss,
##                                    fire.name = "Riverside",
##                                    design_vector = riverside_design,
##                                    save.dir  = grts.save.dir,
##                                    all_legacy_sites=NULL,
##                                    watersheds=NULL)

source('../pnw_survey/calc_landscape_mets.R')
