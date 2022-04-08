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
fire_raster <-
    raster("spatial_data/firemerg2.tif/firemerg2.tif")

high_sev_raster <- fire_raster
high_sev_raster[high_sev_raster < 3]  <- NA

## read in shape file of the 2020 and other fires in OR and CA
fire_polygons <- sf::read_sf("spatial_data/FireMerge_Final")
fire_polygons <- st_transform(fire_raster, st_crs(fire_raster))

fire_polygons_subset <- fire_polygons[, c("FireSev")]

high_sev_polygons <- fire_polygons_subset[fire_polygons_subset$FireSev
                                          == "high",]

## takes a long time and doesn't actually seem to work
## high_sev_polygons <- terra:::aggregate(high_sev_polygons,
##                            by=list(high_sev_polygons$FireSev),
##                                        FUN=mean, na.rm=TRUE)

## read in the legacy sites from 2021 (already converted into points)
sites2021 <- sf::read_sf("spatial_data/NCASI_GIS_2022/2021stands_points.shp")

## change crs to match
sites2021 <- st_transform(sites2021, st_crs(fire_raster))

site.ids <- sites2021$Stand

getIntersectionArea <- function(site.id, radius, sites, dd.type) {
    site.pt <- sites[sites$Stand == site.id,]
    ## create buffer around site
    buff <- st_buffer(site.pt, dist=radius)
    new.poly <-  st_intersection(dd.type, buff)

    if(length(st_area(new.poly)) != 0){
        new.poly <- terra:::aggregate( new.poly,
                                      by=list( new.poly$FireSev),
                                      FUN=mean, na.rm=TRUE)
    }
    if(inherits(new.poly, "try-error"))browser()
    if(is.null(new.poly)){
        ## if no area within buffer
        area.nat <- 0
    } else{
        area.nat <- st_area(new.poly)
        print(area.nat)
    }
    if(length(area.nat) == 0) area.nat <- 0
    if(length(area.nat) > 1) browser()
    data.frame(area=area.nat,
               site=site.id,
               radius=radius)
}


areas <- lapply(site.ids, getIntersectionArea, 1000,
                burned_sites, high_sev_polygons)


areas <- do.call(rbind, areas)

write.csv(areas, "spatial_data/high_sev_areas.csv",
          row.names=FALSE)

