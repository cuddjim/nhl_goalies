hr_goalie = purrr::map_df(2000:2022,  # seasons are end of the season year (e.g. 2019-20 = 2020)
                          ~ rvest::read_html(paste0('https://www.hockey-reference.com/leagues/NHL_',.x,'_goalies.html')) %>% 
                            rvest::html_nodes(.,'table') %>% 
                            rvest::html_table(fill = T) %>% .[[1]] %>% 
                            janitor::row_to_names(.,1) %>% 
                            janitor::clean_names() %>% 
                            dplyr::mutate(season = .x,
                                          player = gsub('*','',player,fixed = T)) %>% 
                            dplyr::select(season,everything(),-rk) %>% 
                            dplyr::mutate(across(-matches('player|tm'), ~ as.numeric(.))) %>% 
                            tidyr::drop_na(age) %>% 
                            dplyr::filter(tm != 'TOT'))
