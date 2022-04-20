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

final.save.dir <- "spatial_data/finalSpData"

load(file=file.path(final.save.dir, "high_sev_polygons.Rdata"))



grts.save.dir <- "spatial_data/grts_sites"

grts.files <- list.files(grts.save.dir, pattern="RData")
fires <- gsub(".RData", "", grts.files)

fire.list <- vector(mode="list", length=length(fires))

for(i in 1:length(fires)){
    load(file.path(grts.save.dir, grts.files[i]))
    old.sites <- strat_eqprob$sites_legacy
    new.sites <- strat_eqprob$sites_base
    new.sites$Stand <- paste0(fires[i], "_2022_", rep(1:nrow(new.sites)))
    old.sites  <-   old.sites[,
                              colnames(old.sites)[colnames(old.sites) %in% colnames(new.sites)]]
    new.sites$OWNER.1 <- NULL
    new.sites$FireSev.1 <- NULL
    new.sites$FireName.1 <- NULL
    old.sites$FireName <- unique(new.sites$FireName)
    all.sites <- rbind(old.sites[, colnames(new.sites)], new.sites)
    fire.list[[i]] <- all.sites
    st_write(all.sites,
             dsn= file.path(sprintf("spatial_data/grts_and_legacy_sites/%s.shp",
                                    fires[i])),
             delete_dsn = TRUE
             )

}

names(fire.list) <- fires

site.ids <- lapply(fire.list, function(x) x$Stand)

getIntersectionArea <- function(site.id, radius, sites, dd.type) {
    print(site.id)
    site.pt <- sites[sites$Stand == site.id,]
    ## create buffer around site
    buff <- st_buffer(site.pt, dist=radius)
    new.poly <-  st_intersection(dd.type, buff)

    if(length(st_area(new.poly)) != 0){
        new.poly <- terra:::aggregate(new.poly,
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

    print(site.pt$siteuse)
    data.frame(area=area.nat,
               site=site.id,
               radius=radius,
               sitereuse= unique(site.pt$siteuse))
}

high.sev.area <- vector(mode="list", length=length(fires))

for(i in 1:length(fire.list)){
    areas <- lapply(site.ids[[i]], getIntersectionArea, 1000,
                    fire.list[[i]], high_sev_polygons)

    high.sev.area[[i]]  <- do.call(rbind, areas)

}

all.high.sev.area <- do.call(rbind, high.sev.area)

write.csv(all.high.sev.area, "spatial_data/high_sev_areas.csv",
          row.names=FALSE)


# Overlaid histograms
ggplot(all.high.sev.area, aes(x=area, color=sitereuse)) +
  geom_histogram(fill="white", alpha=0.5, position="identity")

ggsave("spatial_data/high_sev_hist.pdf")
