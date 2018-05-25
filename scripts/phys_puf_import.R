library(MonetDBLite)        # load the MonetDBLite package (connects r to a monet database)

# File locations
phys_puf_path <- "c:/projects/DSBC/Shiny_app/data_raw/Medicare_Provider_Util_Payment_PUF_CY20"
phys_puf_15_tsv <- paste0(phys_puf_path, "15.txt")
phys_puf_14_tsv <- paste0(phys_puf_path, "14.txt")
phys_puf_13_tsv <- paste0(phys_puf_path, "13.txt")