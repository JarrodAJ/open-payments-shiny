library(shinythemes)
ui <- fluidPage(theme = shinytheme("sandstone"),
  titlePanel("Exploring OpenPayments and Physician Services"),
  
  sidebarLayout(
    sidebarPanel(
      h5(tags$strong("Choose OpenPayments threshold for physicians")), 
      
      helpText("Physicians will be included in the \"Received 
Payments\" group if they received at least the amount you 
select. Note that all payment types are included. They will 
be compared to physicians for whom there were no reported payments."),
      
      selectInput("pay_thresh", 
                  label = "Choose a payment threshold",
                  choices = list("$1" = "p1", 
                                 "$10" = "p10", 
                                 "$50" = "p50", 
                                 "$100" = "p100", 
                                 "$500" = "p500", 
                                 "$1k" = "p1k", 
                                 "$5k" = "p5k", 
                                 "$10k" = "p10k", 
                                 "$20k" = "p20k", 
                                 "$50k" = "p50k",
                                 "$1 drug" = "drug_p1", 
                                 "$10 drug" = "drug_p10", 
                                 "$50 drug" = "drug_p50", 
                                 "$100 drug" = "drug_p100", 
                                 "$500 drug" = "drug_p500", 
                                 "$1k drug" = "drug_p1k", 
                                 "$5k drug" = "drug_p5k", 
                                 "$10k drug" = "drug_p10k", 
                                 "$20k drug" = "drug_p20k", 
                                 "$50k drug" = "drug_p50k", 
                                 "$1 devsup" = "devsup_p1", 
                                 "$10 devsup" = "devsup_p10", 
                                 "$50 devsup" = "devsup_p50", 
                                 "$100 devsup" = "devsup_p100", 
                                 "$500 devsup" = "devsup_p500", 
                                 "$1k devsup" = "devsup_p1k", 
                                 "$5k devsup" = "devsup_p5k", 
                                 "$10k devsup" = "devsup_p10k", 
                                 "$20k devsup" = "devsup_p20k", 
                                 "$50k devsup" = "devsup_p50k", 
                                 "$1 other" = "other_p1", 
                                 "$10 other" = "other_p10", 
                                 "$50 other" = "other_p50", 
                                 "$100 other" = "other_p100", 
                                 "$500 other" = "other_p500", 
                                 "$1k other" = "other_p1k", 
                                 "$5k other" = "other_p5k", 
                                 "$10k other" = "other_p10k", 
                                 "$20k other" = "other_p20k", 
                                 "$50k other" = "other_p50k"),
                  selected = "p100"),
      
      helpText("The data year represents both the calendar year in which 
               any reported payments were received and the year in 
               which the physician services were rendered."),
      
      selectInput("data_year", 
                  label = "Choose a data year",
                  choices = list(2013, 2014, 2015),
                  selected = 2015),
      
      actionButton("update", "Update View")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Header + summary of distribution ----
      h4("Physician Average Cost per Service by HCPCS Code and Receipt of Payment \nfrom Manufacturers or Group Purchasing Organizations"),
      p("CPT copyright 2014 American Medical Association. All Right Reserved. 
          This dataset is subject to the AMA click-agreement. If you have reached this dataset without the click through agreement, 
          please acknowledge your acceptance here:", 
          tags$a("https://data.cms.gov/use-agreement/cpt-code/medicare-provider-data-2015")
          ),
      plotOutput("cleve_plot"), 
      h4("CPT code definitions"),
      DTOutput('cleve_table')
      
      # Output: Header + table of distribution ----
      # h4("Observations"),
      # tableOutput("view")
    )
  )
  )