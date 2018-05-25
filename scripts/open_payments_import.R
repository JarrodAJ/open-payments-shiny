library(MonetDBLite)        # load the MonetDB.R package (connects r to a monet database)
library(tidyverse)
library(DBI)

# File locations
op_gnrl_path <- "c:/projects/DSBC/Shiny_app/data_raw/OP_DTL_GNRL_PGYR20"
op_gnrl_suffix <- "_P01172018_fixed.csv"
op_gnrl_16_csv <- paste0(op_gnrl_path, "16",  op_gnrl_suffix)
op_gnrl_15_csv <- paste0(op_gnrl_path, "15",  op_gnrl_suffix)
op_gnrl_14_csv <- paste0(op_gnrl_path, "14",  op_gnrl_suffix)
op_gnrl_13_csv <- paste0(op_gnrl_path, "13",  op_gnrl_suffix)
#op_gnrl_15_csv <- "c:/projects/DSBC/Shiny_app/data_raw/OP_DTL_GNRL_PGYR2015_P01172018_fixed.csv"

# Get names for two file formats - 2016, and 2013-2015
op_gnrl_csv_names_16 <- names(read_csv(op_gnrl_16_csv, n_max = 1))
op_gnrl_csv_names_15 <- names(read_csv(op_gnrl_15_csv, n_max = 1))

# Check before borrowing new field names from 2016 file, since the format changed
all.equal(op_gnrl_csv_names_15[1:47], op_gnrl_csv_names_16[1:47])
# New names 
op_gnrl_16_fields <- c(
  "change_type"
  , "covered_recip_type"
  , "hosp_ccn"
  , "hosp_id"
  , "hosp_name"
  , "phys_profile_id"
  , "phys_first_name"
  , "phys_middle_name"
  , "phys_last_name"
  , "phys_name_suffix"
  , "recip_primary_bus_add1"
  , "recip_primary_bus_add2"
  , "recip_city"
  , "recip_state"
  , "recip_zip_code"
  , "recip_country"
  , "recip_province"
  , "recip_postal_code"
  , "phys_primary_type"
  , "phys_specialty"
  , "phys_lic_st1"
  , "phys_lic_st2"
  , "phys_lic_st3"
  , "phys_lic_st4"
  , "phys_lic_st5"
  , "submitting_man_gpo_name"
  , "man_gpo_paying_id"
  , "man_gpo_paying_name"
  , "man_gpo_paying_state"
  , "man_gpo_paying_country"
  , "total_amt_of_payment"
  , "date_of_payment"
  , "number_of_payments_in_tot_amt"
  , "form_of_pay_or_tv"
  , "nature_of_pay_or_tv"
  , "city_of_travel"
  , "state_of_travel"
  , "country_of_travel"
  , "phys_own_ind"
  , "third_party_pay_recip_ind"
  , "name_of_third_party_receiving"
  , "charity_indicator"
  , "third_party_is_cov_recip_ind"
  , "contextual_information"
  , "delay_in_publication_indicator"
  , "record_id"
  , "dispute_status_for_publication"
  , "related_product_indicator"
  , "cov_flag_1"
  , "indicate_item_1"
  , "cat_or_tx_area_1"
  , "name_of_item_1"
  , "assoc_ndc_1"
  , "cov_flag_2"
  , "indicate_item_2"
  , "cat_or_tx_area_2"
  , "name_of_item_2"
  , "assoc_ndc_2"
  , "cov_flag_3"
  , "indicate_item_3"
  , "cat_or_tx_area_3"
  , "name_of_item_3"
  , "assoc_ndc_3"
  , "cov_flag_4"
  , "indicate_item_4"
  , "cat_or_tx_area_4"
  , "name_of_item_4"
  , "assoc_ndc_4"
  , "cov_flag_5"
  , "indicate_item_5"
  , "cat_or_tx_area_5"
  , "name_of_item_5"
  , "assoc_ndc_5"
  , "program_year"
  , "payment_publication_date"
)

op_gnrl_16_data_types <- c(
  "VARCHAR(20)",
  "VARCHAR(50)",
  "VARCHAR(6)",
  "VARCHAR(12)",
  "VARCHAR(100)",
  "VARCHAR(12)",
  "VARCHAR(20)",
  "VARCHAR(20)",
  "VARCHAR(35)",
  "VARCHAR(5)",
  "VARCHAR(55)",
  "VARCHAR(55)",
  "VARCHAR(40)",
  "CHAR(2)",
  "VARCHAR(10)",
  "VARCHAR(100)",
  "VARCHAR(20)",
  "VARCHAR(20)",
  "VARCHAR(100)",
  "VARCHAR(300)",
  "CHAR(2)",
  "CHAR(2)",
  "CHAR(2)",
  "CHAR(2)",
  "CHAR(2)",
  "VARCHAR(100)",
  "VARCHAR(12)",
  "VARCHAR(100)",
  "CHAR(2)",
  "VARCHAR(100)",
  "DECIMAL(12,2)",
  "DATE",
  "BIGINT",
  "VARCHAR(100)",
  "VARCHAR(200)",
  "VARCHAR(40)",
  "CHAR(2)",
  "VARCHAR(100)",
  "CHAR(3)",
  "VARCHAR(50)",
  "VARCHAR(50)",
  "CHAR(3)",
  "CHAR(3)",
  "VARCHAR(500)",
  "CHAR(3)",
  "VARCHAR(12)",
  "CHAR(3)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(12)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(12)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(12)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(12)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(100)",
  "VARCHAR(12)",
  "CHAR(4)",
  "DATE"
)
length(op_gnrl_16_fields) == length(op_gnrl_16_data_types)

op_gnrl_15_fields <- c(
  op_gnrl_16_fields[1:47], 
  "product_indicator", 
  "name_of_drugbio_1", 
  "name_of_drugbio_2", 
  "name_of_drugbio_3", 
  "name_of_drugbio_4", 
  "name_of_drugbio_5", 
  "assoc_ndc_1", 
  "assoc_ndc_2", 
  "assoc_ndc_3", 
  "assoc_ndc_4", 
  "assoc_ndc_5", 
  "name_of_devsup1", 
  "name_of_devsup2", 
  "name_of_devsup3", 
  "name_of_devsup4", 
  "name_of_devsup5", 
  "program_year", 
  "payment_publication_date"
)

op_gnrl_15_data_types <- c(
  op_gnrl_16_data_types[1:47], 
  "VARCHAR(50)", 
  rep("VARCHAR(100)", 5), 
  rep("VARCHAR(12)", 5), 
  rep("VARCHAR(100)", 5), 
  "CHAR(4)",
  "DATE"
) 

length(op_gnrl_15_fields) == length(op_gnrl_15_data_types)
op_gnrl_14_fields <- op_gnrl_15_fields
op_gnrl_14_data_types <- op_gnrl_15_data_types
op_gnrl_13_fields <- op_gnrl_15_fields
op_gnrl_13_data_types <- op_gnrl_15_data_types


# Function to create SQL from field names and data types
create_tbl_sql <- function(table_name, field_names, data_types){
  paste0("CREATE TABLE ", table_name, " (", 
         paste0(field_names[-length(field_names)], " ", 
                data_types[-length(data_types)], 
                ",", collapse = " "), " ",
         field_names[length(field_names)], " ", 
         data_types[length(data_types)], ")", collapse = " ")
}
ddl_op_gnrl_16 <- create_tbl_sql("op_gnrl_16", op_gnrl_16_fields, op_gnrl_16_data_types) 
ddl_op_gnrl_15 <- create_tbl_sql("op_gnrl_15", op_gnrl_15_fields, op_gnrl_15_data_types) 
ddl_op_gnrl_14 <- create_tbl_sql("op_gnrl_14", op_gnrl_14_fields, op_gnrl_14_data_types) 
ddl_op_gnrl_13 <- create_tbl_sql("op_gnrl_13", op_gnrl_13_fields, op_gnrl_13_data_types) 

# Set up database directory and DBI connection
dbdir <- "C:/Data/MonetDB/dbfarm/op"
con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)
dbListTables(con)

#Import Open Payments 2016 data
dbBegin(con)

dbSendQuery(con, ddl_op_gnrl_16)
message('Finished op_gnrl_16 DDL')
dbSendQuery(con, paste0("COPY 11298353 OFFSET 2 RECORDS INTO op_gnrl_16 FROM '", op_gnrl_16_csv, "' USING DELIMITERS ',','\n','\"' NULL as ''"))
dbCommit(con)

message('Finished op_gnrl_16 import')
# Add tx_cat column to op_gnrl_16 data
dbSendQuery(con, "ALTER TABLE op_gnrl_16 ADD tx_cat VARCHAR(100)")
dbDisconnect(con)
gc(verbose = TRUE)
print(Sys.time())

#Import Open Payments 2015 data
con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)
dbBegin(con)
dbSendQuery(con, ddl_op_gnrl_15)
message('Finished op_gnrl_15 ddl')
dbSendQuery(con, paste0("COPY 11467884 OFFSET 2 RECORDS INTO op_gnrl_15 FROM '", op_gnrl_15_csv, "' USING DELIMITERS ',','\n','\"' NULL as ''"))
dbCommit(con)
message('Finished op_gnrl_15 import')
dbDisconnect(con)
gc(verbose = TRUE)
print(Sys.time())
#Import Open Payments 2014 data
con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)
dbBegin(con)
dbSendQuery(con, ddl_op_gnrl_14)
message('Finished op_gnrl_14 ddl')

dbSendQuery(con, paste0("COPY 11300995 OFFSET 2 RECORDS INTO op_gnrl_14 FROM '", op_gnrl_14_csv, "' USING DELIMITERS ',','\n','\"' NULL as ''"))
dbCommit(con)
message('Finished op_gnrl_14 import')
dbDisconnect(con)
gc(verbose = TRUE)
print(Sys.time())
#Import Open Payments 2013 data
con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)

dbBegin(con)
dbSendQuery(con, ddl_op_gnrl_13)
message('Finished op_gnrl_13 ddl')

dbSendQuery(con, paste0("COPY 4164323 OFFSET 2 RECORDS INTO op_gnrl_13 
                        FROM '", op_gnrl_13_csv, "' USING DELIMITERS ',','\n','\"' NULL as ''"))
dbCommit(con)
message('Finished op_gnrl_13 import')
dbDisconnect(con)
gc(verbose = TRUE)
print(Sys.time())
#Create open payments table with multiple years 
con <- dbConnect(MonetDBLite::MonetDBLite(), dbdir)
dbBegin(con)
dbSendQuery(con, "CREATE TABLE op_gnrl_13_to_15 AS (
            SELECT 
            CAST(2015 AS INTEGER) AS op_year, 
            a.* 
            FROM op_gnrl_15 AS a 
            UNION 
            SELECT 
            CAST(2014 AS INTEGER) AS op_year, 
            b.* 
            FROM op_gnrl_14 AS b 
            UNION 
            SELECT 
            CAST(2013 AS INTEGER) AS op_year, 
            c.*
            FROM op_gnrl_13 AS c )")
dbCommit(con)

dbDisconnect(con)
gc()
print(Sys.time())