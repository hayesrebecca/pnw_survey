rm(list=ls())
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

load(file="spatial_data/finalSpData/firePolygons.Rdata")
load(file="spatial_data/finalSpData/grts2021Sites.Rdata")

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

