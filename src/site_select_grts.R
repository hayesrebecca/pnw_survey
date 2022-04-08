

site_select_grts <- function(all_legacy_sites=NULL,  ## all the legancy sites from 2021
                             watersheds=NULL, ## a vector of the watershes in the fire of interest
                             all_fire_polygons,  ## the giant merged fire polygons
                             fire.name, ## fire of interest as a character
                             design_vector, ##design input for grts vector
                             save.dir, ## director to save
                             dist.btw.sites =1000 ## the min distance
                             ## between sites in the units of the
                             ## spatial data (currently UTM)
                             ){

    ## function for choose new sites based on grts. Takes legacy sites
    ## if they exist, and a design matrix based on fire severity and
    ## owner. Subsets to each fire and each fire's legacy sites, then
    ## chooses points based on the design matrix.

    subset_fire <- all_fire_polygons[all_fire_polygons$FireName == fire.name, ]
    if(!is.null(all_legacy_sites)){
        print(paste(fire.name, "with legacy sites"))

        print(unique(subset_fire$FireSevOwner))
        ## subset to the correct watershes
        subset_2021_sites <-
            all_legacy_sites[all_legacy_sites$Watershed %in%
                             watersheds,]
        if(nrow(subset_2021_sites) != 0){
            ## run grts with legacy sites
            strat_eqprob <- grts(subset_fire,
                                 n_base = design_vector,
                                 stratum_var = "FireSevOwner",
                                 legacy_sites=subset_2021_sites,
                                 legacy_stratum_var = 'FireSevOwner',
                                 mindis=dist.btw.sites)
        } else{
            print(paste(fire.name, "without legacy sites"))

            print(unique(subset_fire$FireSevOwner))

            ## run grts without legacy sites
            strat_eqprob <- grts(subset_fire,
                                 n_base = design_vector,
                                 stratum_var = "FireSevOwner",
                                 mindis=dist.btw.sites

                                 )
        }
    } else {
        print(paste(fire.name, "without legacy sites"))
        print(unique(subset_fire$FireSevOwner))
        ## run grts without legacy sites
        strat_eqprob <- grts(subset_fire,
                             n_base = design_vector,
                             stratum_var = "FireSevOwner",
                             mindis=dist.btw.sites
                             )
    }

    ## export the sites selected
    st_write(strat_eqprob$sites_base,
             dsn= file.path(save.dir, sprintf("grts_sites/%s.shp",
                                              fire.name)),
             delete_dsn = TRUE
             )

    return(strat_eqprob)

}
