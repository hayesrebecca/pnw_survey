rm(list=ls())
set.seed(9)
library(raster)
library(spsurvey)
library(tidyverse)
library(sf)
library(landscapemetrics)
library(rgeos)

## rebecca
## setwd("C:/Users/rah10/Dropbox (University of Oregon)/")

## Lauren mac pro
setwd("/Volumes/bombus/Dropbox (University of Oregon)/")

setwd("pnw_survey_saved/")

## ## read in shape file of the 2020 and other fires in OR and CA
## fire_raster <-
##     raster("spatial_data/firemerg2.tif/firemerg2.tif")

## high_sev_raster <- fire_raster
## high_sev_raster[high_sev_raster < 3]  <- NA

## read in shape file of the 2020 and other fires in OR and CA
fire_polygons <- sf::read_sf("spatial_data/FireMerge_Final")

fire_polygons_subset <- fire_polygons[, c("FireSev")]

high_sev_polygons <- fire_polygons[fire_polygons$FireSev == "high",]

high_sev_polygons <- aggregate(high_sev_polygons, by='FireSev')

## read in the legacy sites from 2021 (already converted into points)
sites2021 <- sf::read_sf("spatial_data/NCASI_GIS_2022/2021stands_points.shp")

## change crs to match Firenames
sites2021 <- st_transform(sites2021, st_crs(fire_polygons))

holiday_watersheds <- c("W56Johnson", "W57Ritchie", "W55Indian")
dixie_watersheds <- c("W58MoodyMd", "W59Sheepca", "W62Poplar",  "W60Rock")
claremont_watersheds <- c("W61Willow")
beachie_watersheds <- c("W50Pine", "W51Molalla")

all_fire_watersheds <- c(holiday_watersheds, dixie_watersheds,
                         claremont_watersheds, beachie_watersheds)

burned_sites <- sites2021[sites2021$Watershed %in%
                          all_fire_watersheds,]
## convert to familiar data
## burned_sites <- sf:::as_Spatial(burned_sites)

## site.ids <- burned_sites@data$Stand

site.ids <- burned_sites$Stand

getIntersectionArea <- function(site.id, radius, sites, dd.type) {

    site.pt <- sites[sites$Stand == site.id,]
    ## create buffer around site
    browser()
    buff <- st_buffer(site.pt, dist=radius)
    new.poly <-  st_intersection(dd.type, buff)
    browser()
    if(inherits(new.poly, "try-error"))browser()
    if(is.null(new.poly)){
        ## if no area within buffer
        area.nat <- 0
    } else{
        area.nat <- gArea(new.poly)
    }
    data.frame(area=area.nat,
               site=ss,
               radius=radius)
}


areas <- lapply(site.ids, getIntersectionArea, 1000, burned_sites, high_sev_polygons)

x <- getIntersectionArea(1000, burned_sites, high_sev_raster)
