rm(list=ls())
library(terra)
library(spsurvey)
library(sf)

## rebecca
## setwd("C:/Users/rah10/Dropbox (University of Oregon)/")

## Lauren mac pro
setwd("/Volumes/bombus/Dropbox (University of Oregon)/")

## Jesse

setwd("pnw_survey_saved/")

public.owners <- c("BLM", "STATE", "USFS")

## *******************************************************************
## fire polygons: dissolve and clean up
## *******************************************************************

fire_polygons <- sf::read_sf("spatial_data/FireMerge_1kmroadbuff.shp/FireMerge_1kmroadbuff.shp")

fire_polygons$FireSev[fire_polygons$FireSev == "NoData"] <- "unburned"

## subset to fire sev and owner to facilitate merging
fire_polygons_subset <- fire_polygons[, c("FireSev", "OWNER",
                                          "FireName")]


fire_polygons_diss <- terra:::aggregate(
                                  fire_polygons_subset,
                                  by=list(FireSev=fire_polygons_subset$FireSev,
                                          OWNER=fire_polygons_subset$OWNER,
                                          FireName= fire_polygons_subset$FireName),
                                  FUN=unique, na.rm=TRUE)


## merge public owners
fire_polygons_diss$OWNER[fire_polygons_diss$OWNER %in% public.owners] <-
    "PUBLIC"

fire_polygons_diss$FireSevOwner  <- paste0(fire_polygons_diss$FireSev,
                                           fire_polygons_diss$OWNER)

unique(fire_polygons_diss$FireSevOwner)

st_write(fire_polygons_diss,
         dsn="spatial_data/finalSpData/dissolved_owner_sev_polygons.shp",
          delete_dsn = TRUE)


save(fire_polygons, fire_polygons_diss, file=
                     "spatial_data/finalSpData/firePolygons.Rdata")

## *******************************************************************
##  legancy sites: merge attributes and clean up
## *******************************************************************

sites2021 <- sf::read_sf("spatial_data/NCASI_GIS_2022/2021stands_points.shp")

## csv of owner data
owners <-
    read.csv("spatial_data/NCASI_GIS_2022/2021stands_obscowner.csv")

## match owners by stand to 2021 data
sites2021$OWNER <- owners$OWNER[match(sites2021$Stand,
                                      owners$Stand)]

sites2021$FireSev <- owners$FireSev[match(sites2021$Stand,
                                      owners$Stand)]

sites2021$FireSev[is.na(sites2021$FireSev)]  <-  "unburned"

## convert public land to one owner category
sites2021$OWNER[sites2021$OWNER %in% public.owners] <- "PUBLIC"

## change crs to match Firenames
sites2021 <- st_transform(sites2021, st_crs(fire_polygons))

## get rid of random bad sites with no x y
sites_grts <- sites2021[!is.na(sites2021$Watershed),]
sites_grts <- sites_grts[!is.na(sites_grts$OWNER),]
## sites_grts <- sites_grts[!is.na(sites_grts$FireSev),]

sites_grts$FireSevOwner  <- paste0(sites_grts$FireSev,
                                          sites_grts$OWNER)

unique(sites_grts$FireSevOwner)

save(sites_grts, file=
                     "spatial_data/finalSpData/grts2021Sites.Rdata")


save(sites2021, file=
                     "spatial_data/finalSpData/sites2021.Rdata")


## *******************************************************************
## fire raster: subset to high sev
## *******************************************************************

## ## read in shape file of the 2020 and other fires in OR and CA
fire_raster <-
    rast("spatial_data/firemerg2.tif/firemerg2.tif")

high_sev_raster <- fire_raster
high_sev_raster[high_sev_raster < 3]  <- NA

writeRaster(high_sev_raster,
            filename="spatial_data/finalSpData/high_sev_raster.tif",
            overwrite=TRUE)

save(high_sev_raster, fire_raster, file=
                     "spatial_data/finalSpData/fireRasters.Rdata")


## *******************************************************************
## fire polygons: subset to high sev
## *******************************************************************

fire_polygons <- sf::read_sf("spatial_data/FireMerge_Final/FireMerge_Final.shp")

high_sev_polygons <- fire_polygons[fire_polygons$FireSev == "high",]

high_sev_polygons <- terra:::aggregate(
                                  high_sev_polygons,
                                  by=list(FireSev=high_sev_polygons$FireSev,
                                          FireName= high_sev_polygons$FireName),
                                 FUN=unique, na.rm=TRUE)

save(high_sev_polygons, file=
                     "spatial_data/finalSpData/high_sev_polygons.Rdata")
