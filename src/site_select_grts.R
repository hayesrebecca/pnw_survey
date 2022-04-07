
site_select_grts <- function(all_legacy_sites=NULL,  ## all the legancy sites from 2021
                             watersheds=NULL, ## a vector of the watershes in the fire of interest
                             all_fire_polygons,  ## the giant merged fire polygons
                             fire.name, ## fire of interest as a character
                             design_vector, ##design input for grts vector
                             save.dir ## director to save
                             ){
                                        #filter to just include specific fire polygons
    subset_fire <- all_fire_polygons[all_fire_polygons$Fire_Name == fire.name, ]

    if(!is.null(all_legacy_sites)){
        print(fire.name)
        ## subset to the correct watershes
        subset_2021_sites <-
            all_legacy_sites[all_legacy_sites$Watershed %in%
                             watersheds,]
        ## run grts with legacy sites
        strat_eqprob <- grts(subset_fire,
                             n_base = design_vector,
                             stratum_var = "OBJECTID",
                             legacy_sites=subset_2021_sites,
                             legacy_stratum_var = 'Watershed',
                             mindis=1000)
    } else{
        ## run grts without legacy sites
        strat_eqprob <- grts(subset_fire,
                             n_base = design_vector,
                             stratum_var = "OBJECTID",
                             mindis=1000)
    }

    ## export the sites selected
    st_write(strat_eqprob$sites_base,
             dsn= file.path(save.dir, sprintf("grts_sites/%s.shp", fire.name))
             )

    return(strat_eqprob)

}