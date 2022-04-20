
beachie_design <- c( ## target 20 assuming not sampling riverside
    'highPUBLIC' = 4, ## one extra
    'medPUBLIC' = 2,
    'lowPUBLIC' = 2, ## already have
    'highE' = 2, ## Very little in fire perim, choosing > 2 gets
    ## points very close to each other
    'medE' = 2,
    'lowE' = 2, ## already have
    'highM' = 4, ## one extra
    'medM' = 2
    ## 'unburnedM' = 6 ## already have  => doing just 1
    ## 'unburnedPUBLIC = 1 doing just 1
)

claremont_design <- c( # target 11
  'highC' = 3, ## 2 target + 1 extra (not enough area for more)
  'medC' = 3, ## 2 target + 1 extra (not enough area for more)
  'highPUBLIC' = 4,  ## already have 3 high
  'medPUBLIC' = 4 ## already have 3 medium
)

## riverside_design <- c(
##     'highPUBLIC' = 2,
##     'medPUBLIC' = 2,
##     'highE' = 4,
##     'medE' = 2,
##     'highM' = 4,
##     'medM' = 2
## )

holiday_design <- c( # target 36
    'highPUBLIC' = 10, ## all new  + 2 extra
    'medPUBLIC' = 2, ## all new
    'lowPUBLIC' = 2, ## all new
    'highT' = 6, ## all new
    'medT' = 2, ## all new
    ## 'highU' = 4, ## all new
    ## 'medU' = 2, ## all new
    'highM' = 10, ## already have 3 + 8 + 2 extra
    'medM' = 4, ## already have
    'lowM' = 2 ## already have (could drop?)
    ## 'unburnedM' = 5 ## already have ##
    ## (just doing 2)
)


dixie_design <- c( # target 24,
    'highC' = 5, ## have 2 + 2 + 1 extra
    'medC' = 6, ## have 6
    'highQ' = 5, # all new + 1 extra
    'medQ' = 2, ## have 1 + 1 new
    'highPUBLIC' = 5, ## all new + 1 extra
    'medPUBLIC' = 2 # old 1 + 1 new
    ## 'unburnedC' = 6 ## already have ##
    ## choose 2
)
