rm(list=ls())
set.seed(9)
## library(rgdal)
library(raster)
library(rgeos)
library(terra)
library(spsurvey)
library(tidyverse)
library(sf)

## rebecca
# setwd("C:/Users/rah10/Dropbox (University of Oregon)/")

setwd("pnw_survey_saved/")

grts.save.dir <- "spatial_data"

source("")

#read in shape file
FireNames <- sf::read_sf("SeverityMerge_220308")

#read in the legacy sites from 2021 (converted into points)
sites2021 <- sf::read_sf("stands2021_points.shp")

#change crs to match Firenames
sites2021 <- st_transform(sites2021, st_crs(FireNames))

## get rid of random bad sites with no x y 
sites2021 <- sites2021[!is.na(sites2021$Watershed),]

## subset sites to the watersheds with in each fire
holiday_watersheds <- c("W56Johnson", "W57Ritchie", "W55Indian")
dixie_watersheds <- c("W58MoodyMd", "W59Sheepca", "W62Poplar",  "W60Rock")
claremont_watersheds <- c("W61Willow")
beachie_watersheds <- c("")
riverside_watersheds <- c("")

site_select_grts <- function(all_legacy_sites,  ## all the legancy sites from 2021
                             watersheds, ## a vector of the watershes in the fire of interest
                             all_fire_polygons,  ## the giant merged fire polygons 
                             fire.name, ## fire of interest as a character
                             design_vector, ##design input for grts vector
                             save.dir ## director to save
                             ){
  ## subset to the correct watershes
  subset_2021_sites <- all_legacy_sites[all_legacy_sites$Watershed %in% watersheds,]
  
  #filter to just include specific fire polygons
  subset_fire <- all_fire_polygons[all_fire_polygons$Fire_Name == fire.name, ]
  
  #run grts
  strat_eqprob <- grts(subset_fire, 
                       n_base = design_vector, 
                       stratum_var = "Strata", 
                       legacy_sites=subset_2021_sites, 
                       legacy_stratum_var = 'Watershed',
                       mindis=1000)
  
  #export the site selection to dropbox
  st_write(strat_eqprob$sites_base,
           dsn= file.path(save.dir, sprintf("grts_sites/%s.shp", fire.name))
  )

  return(strat_eqprob)

}


claremont_grts <- site_select_grts(all_legacy_sites = sites2021,
                             watersheds= claremont_watersheds,
                             all_fire_polygons = FireNames,
                             fire.name = "Claremont",
                             design_vector = claremont_design,
                             save.dir  = grts.save.dir)


holiday_grts <- site_select_grts(all_legacy_sites = sites2021,
                                   watersheds= holiday_watersheds,
                                   all_fire_polygons = FireNames,
                                   fire.name = "Holiday",
                                   design_vector = holiday_design,
                                   save.dir  = grts.save.dir)


dixie_grts <- site_select_grts(all_legacy_sites = sites2021,
                                 watersheds= holiday_watersheds,
                                 all_fire_polygons = FireNames,
                                 fire.name = "Dixie",
                                 design_vector = dixie_design,
                                 save.dir  = grts.save.dir)

beachie_grts <- site_select_grts(all_legacy_sites = sites2021,
                               watersheds= beachie_watersheds,
                               all_fire_polygons = FireNames,
                               fire.name = "Beachie",
                               design_vector = beachie_design,
                               save.dir  = grts.save.dir)

riverside_grts <- site_select_grts(all_legacy_sites = sites2021,
                                 watersheds= riverside_watersheds,
                                 all_fire_polygons = FireNames,
                                 fire.name = "Riverside",
                                 design_vector = riverside_design,
                                 save.dir  = grts.save.dir)






