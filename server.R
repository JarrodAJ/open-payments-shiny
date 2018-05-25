server <- function(input, output){
  
  # Return the requested dataset ----
  # Note that we use eventReactive() here, which depends on
  # input$update (the action button), so that the output is only
  # updated when the user clicks the button
  data_paid <- eventReactive(input$update, {
    filter_paid(df = cpt_data_o, 
                input$pay_thresh,
                input$data_year,
                hcpcs_code) 
  }, ignoreNULL = FALSE)
  
  data_unpaid <- eventReactive(input$update, {
    filter_unpaid(df = cpt_data_o, 
                  p_any,
                  input$data_year,
                  hcpcs_code)
  }, ignoreNULL = FALSE)
  
  cleveland_plot_data <- eventReactive(input$update, {
    data_paid() %>% 
    inner_join(data_unpaid(), by = "hcpcs_code", suffix = c("paid", "unpaid"))%>% 
    select(hcpcs_code, prov_avg_alwdpaid, prov_avg_alwdunpaid ) %>%
    mutate(
      avg_diff = round(prov_avg_alwdpaid - prov_avg_alwdunpaid, 2), 
      abs_diff = abs(avg_diff), 
      pct_diff = prov_avg_alwdpaid / prov_avg_alwdunpaid - 1, 
      abs_pct_diff = abs(pct_diff))  %>% 
    filter(abs_diff > 10 | abs_pct_diff > .15) %>% 
    arrange(desc(abs_diff)) %>%  
    head(n = 35) %>% 
    gather(key = paid_group, value = prov_avg_srvc_cost, 
           prov_avg_alwdpaid:prov_avg_alwdunpaid ) %>% 
    mutate(paid_group = gsub("prov_avg_alwd", "", paid_group), 
           prov_avg_srvc_cost = round(prov_avg_srvc_cost, 2)) %>% 
    # arrange(desc(avg_diff), desc(paid_group)) %>%  
    arrange(abs_diff, desc(paid_group)) %>%  
    mutate(hcpcs_code = factor(hcpcs_code, levels = .$hcpcs_code), 
           paid_group = factor(paid_group, levels = .$paid_group)  )
  }, ignoreNULL = FALSE)
  
  
  
  output$cleve_plot <- renderPlot({
    
       right_label <- cleveland_plot_data() %>%
      group_by(hcpcs_code) %>%
      arrange(desc(abs_diff)) %>%
      top_n(1, prov_avg_srvc_cost)
    
    left_label <- cleveland_plot_data() %>%
      group_by(hcpcs_code) %>%
      arrange(desc(abs_diff), desc(prov_avg_srvc_cost)) %>%
      slice(2)
    
    #Create plot
    # avg_max <- max(cleveland_plot_data$prov_avg_srvc_cost)
    # lim_max <- round()
    
    
      ggplot(cleveland_plot_data(), aes(prov_avg_srvc_cost, hcpcs_code)) +
      geom_line(aes(group = hcpcs_code)) +
      geom_point(aes(color = paid_group), size = 2) +
      geom_text(data = right_label, aes(color = paid_group, label = scales::dollar(round(prov_avg_srvc_cost, 0))),
                size = 4, hjust = -.5) +
      geom_text(data = left_label, aes(color = paid_group, label = scales::dollar(round(prov_avg_srvc_cost, 0))),
                size = 4, hjust = 1.5) +
      scale_color_discrete(labels = c("No payments documented", "Payments above selected threshold")) +
      scale_x_continuous(labels = scales::dollar, expand = c(0.05, 0), 
                         limits = c(-500, 18000),
                         breaks = seq(0, 18000, by = 2000)) +
      scale_y_discrete(expand = c(.02, 0)) +
      labs(subtitle = "Cost per service as calculated by Centers for Medicare & Medicaid Services" ) + 
      theme_minimal() +
      theme(axis.title = element_blank(),
            panel.grid.major.x = element_blank(),
            panel.grid.minor = element_blank(),
            legend.title = element_blank(),
            legend.justification = c(0, 1), 
            legend.position = c(.1, 1.075),
            legend.background = element_blank(),
            legend.direction="horizontal",
            text = element_text(family = "Georgia"),
            plot.title = element_text(size = 20, margin = margin(b = 10)),
            plot.subtitle = element_text(size = 10, color = "darkslategrey", margin = margin(b = 25)),
            plot.caption = element_text(size = 8, margin = margin(t = 10), color = "grey70", hjust = 0)
            )
  })
  
  output$cleve_table <- renderDT(cleveland_plot_data() %>% 
   inner_join(hcpcs_desc, by = c("hcpcs_code" = "HCPCS Code")) %>% 
   group_by(hcpcs_code) %>% 
     summarise(
       `HCPCS code` = first(hcpcs_code), 
       `HCPCS Description` = first(hcpcs_desc), 
       `Absolute Difference` = first(abs_diff)
     ) %>%  select(2:4 ) %>% 
      arrange(desc(`Absolute Difference`))
                                 )
  
}