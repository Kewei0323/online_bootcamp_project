# Installing libraries for initial load in order to run
# all required built-in functions
rm(list=ls())
library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(ggplot2)
library(reshape2)
library(maps)
library(mapproj)
library(zoo)
library(RColorBrewer)

# Running files in order to give access
# to the different data types - Refugee, 
# Defensive Asylum and Affirmative Asylum and functions
# accessing those datas
source("Project2/proj2_be.R")
source("Project2/proj2_Def_be.R")
source("Project2/proj2_Aff_be.R")

# Function created for summary page of UI/Server of Shiny
# application. It will display a bar plot and trends comparing
# the different refugee types and amount from 2006-2015

summaryplot.plotly = function(data1 = Continent_data, data2 = Cont_Aff_data, data3 = Cont_Def_data) {
  t1 = data1 %>% mutate(type = 'Refugees') %>% rename(Total = Refugee.Status)
  t2 = data2 %>% mutate(type = 'Affirmative') %>% rename(Total = Affirmative.Asylum)
  t3 = data3 %>% mutate(type = 'Defensive') %>% rename(Total = Defensive.Asylum)
  t4 = bind_rows(t1,t2,t3)
  t5 = t4 %>% group_by(Year, type) %>% summarise(sum = sum(Total))
  t6 = t5 %>% dcast(Year ~ type)
  plot_ly(data = t6, x = ~Year) %>% add_trace(y = ~Affirmative, type = 'scatter', mode = 'lines',opacity = 0.5, name = "Affirmative Asylum", hoverinfo = "none",
                                              line = list(color = 'rgb(255, 0,0)', width = 5)) %>% add_trace(y = ~Defensive, name = 'Defensive Asylum',
                                                             hoverinfo = "none", type = 'scatter', mode = 'lines',opacity = 0.5, line = list(color = 'rgb(0,0,204)', width = 5)) %>% 
    add_trace(y = ~Refugees, type = 'scatter', name = "Refugee Total", mode = 'lines',hoverinfo = "none", opacity = 0.5, line = list(color = 'rgb(32,32,32)',
           width = 5)) %>% add_trace(data = t5, x = ~Year, y = ~sum, color = ~type, type = 'bar', text = ~paste(type,"<br />Total:", sum), 
                                     hoverinfo = "text") %>% layout(barmode = 'stack', 
             xaxis = list(title = ''), yaxis = list(title = 'Total Amount of People seeking Refuge in the US'))
}

# Run Shiny APP
runApp("Project2")


