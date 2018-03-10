library(tidyverse)
library(DT)
# natl_hcpcs_15 <- read_excel("../data_raw/Medicare-National-HCPCS-Aggregate-CY2015.xlsx", sheet = "Data", skip = 1)

load("data/hcpcs_desc.Rds")
load("data/cpt_data_o.Rds")
load("data/cpt_data_top_100_o.Rds")

filter_paid <- function(df, boolvar,  year = 2015, ...){
  groupvars <- quo(...)
  year_quo <- enquo(year)
  bool_quo <- rlang::sym(boolvar) 
  
  df %>% 
    filter(puf_year == (!!year_quo), (!!bool_quo) == TRUE) %>% 
    group_by(!!!groupvars) %>% 
    summarise(
      cpt_alwd = sum(avg_mdcr_allowed_amt * line_srvc_cnt ), 
      srvcs = sum(line_srvc_cnt), 
      avg_alwd = cpt_alwd / srvcs,
      prov_avg_alwd = sum(providers * avg_mdcr_allowed_amt  ) / sum(providers), 
      provs = sum(providers)
    )
}



filter_unpaid <- function(df, boolvar,  year = 2015, ...){
  groupvars <- quo(...)
  year_quo <- enquo(year)
  bool_quo <- enquo(boolvar) 
  
  df %>% 
    filter(puf_year == (!!year_quo), (!!bool_quo) == FALSE) %>% 
    group_by(!!!groupvars) %>% 
    summarise(
      cpt_alwd = sum(avg_mdcr_allowed_amt * line_srvc_cnt ), 
      srvcs = sum(line_srvc_cnt), 
      avg_alwd = cpt_alwd / srvcs,
      prov_avg_alwd = sum(providers * avg_mdcr_allowed_amt  ) / sum(providers), 
      provs = sum(providers)
    )
}