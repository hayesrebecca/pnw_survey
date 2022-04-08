

site_select_grts <- function(all_legacy_sites=NULL,  ## all the legancy sites from 2021
                             watersheds=NULL, ## a vector of the watershes in the fire of interest
                             all_fire_polygons,  ## the giant merged fire polygons
                             fire.name, ## fire of interest as a character
                             design_vector, ##design input for grts vector
                             save.dir, ## director to save
                             caty_list ## a list of how many samples should be selected for each owner
                             ){
                                        #filter to just include
                                        #specific fire polygons

    subset_fire <- all_fire_polygons[all_fire_polygons$FireName == fire.name, ]
    if(!is.null(all_legacy_sites)){
        print(paste(fire.name, "with legacy sites"))

        print(unique(subset_fire$OWNER))
        print(unique(subset_fire$FireSev))
        ## subset to the correct watershes
        subset_2021_sites <-
            all_legacy_sites[all_legacy_sites$Watershed %in%
                             watersheds,]
        if(nrow(subset_2021_sites) != 0){
            ## run grts with legacy sites
            strat_eqprob <- grts(subset_fire,
                                 n_base = design_vector,
                                 stratum_var = "FireSev",
                                 legacy_sites=subset_2021_sites,
                                 legacy_stratum_var = 'FireSev',
                                 mindis=500,
                                 caty_n = caty_list,
                                 caty_var = 'OWNER')
        } else{
            print(paste(fire.name, "without legacy sites"))

            print(unique(subset_fire$OWNER))
            print(unique(subset_fire$FireSev))

            ## run grts without legacy sites
            strat_eqprob <- grts(subset_fire,
                                 n_base = design_vector,
                                 stratum_var = "FireSev",
                                 mindis=500,
                                 caty_n = caty_list,
                                 caty_var = 'OWNER'
                                 )
        }
    } else {
        print(paste(fire.name, "without legacy sites"))
        print(unique(subset_fire$OWNER))
        print(unique(subset_fire$FireSev))
        ## run grts without legacy sites
        strat_eqprob <- grts(subset_fire,
                             n_base = design_vector,
                             stratum_var = "FireSev",
                             mindis=500,
                             caty_n = caty_list,
                             caty_var = 'OWNER'
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
