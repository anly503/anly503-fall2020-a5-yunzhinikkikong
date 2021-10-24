library(tidyverse)
library(plotly)


sum_plug1<- read.csv("sum_plug.csv")
sum_plug1$Date <- as.Date(sum_plug1$Date , format = "%Y-%m-%d")
sum_plug1$Plug_Category<-as.factor(sum_plug1$Plug_Category)
sum_plug1$Household<-as.factor(sum_plug1$Household)
df<-sum_plug1
fridge_annotations <- list(
  x=df$Date[df$Plug_Category=="Fridge"], 
  y=df$PowerPerDay[df$Plug_Category=="Fridge"],
  xref='x', yref='y',
  text=paste0('PowerPerDay: $',df$PowerPerDay[df$Plug_Category=="Fridge"]),
  ax=0, ay=-40
)

entertainment_annotations <- list(
  x=df$Date[df$Plug_Category=="Entertainment"], 
  y=df$PowerPerDay[df$Plug_Category=="Entertainment"],
  xref='x', yref='y',
  text=paste0('PowerPerDay: $',df$PowerPerDay[df$Plug_Category=="Entertainment"]),
  ax=0, ay=-40
)

house4_annotations <- list(
  x=df$Date[df$Household == "4"], 
  y=df$PowerPerDay[df$Household == "4"],
  xref='x', yref='y',
  text=paste0('PowerPerDay: $',df$PowerPerDay[df$Household == "4"]),
  ax=0, ay=-40
)

house5_annotations <- list(
  x=df$Date[df$Household == "5"], 
  y=df$PowerPerDay[df$Household == "5"],
  xref='x', yref='y',
  text=paste0('PowerPerDay: $',df$PowerPerDay[df$Household == "5"]),
  ax=0, ay=-40
)

house6_annotations <- list(
  x=df$Date[df$Household == "6"], 
  y=df$PowerPerDay[df$Household == "6"],
  xref='x', yref='y',
  text=paste0('PowerPerDay: $',df$PowerPerDay[df$Household == "6"]),
  ax=0, ay=-40
)

# updatemenus component
updatemenus <- list(
  list(
    y = 1,
    buttons = list(
      
      list(method = "restyle",
           args = list(list(visible = c(FALSE,FALSE,TRUE)),
                       list(
                         annotations = list(c(), c(),house6_annotations))),
           label = "Household 6"),
      list(method = "restyle",
           args = list(list(visible = c(FALSE, TRUE,FALSE)),
                       list(
                         annotations = list(c(),house4_annotations, c()))),
           label = "Household 4"),
      
      list(method = "restyle",
           args = list(list(visible = c(TRUE,FALSE, FALSE)),
                       list(
                         annotations = list(house5_annotations,c(), c()))),
           label = "Household 5"))),
  list(method = "restyle",
       args = list(list(visible = c(TRUE,FALSE, FALSE)),
                   list(
                     annotations = list(house5_annotations,c(), c()))),
       label = "Household 5"))


fig <- df %>% plot_ly(type = 'scatter', mode = 'lines',fill = 'tozeroy',
                      line = list(width = 0.5)) 
fig <- fig %>% layout(autosize = F, width = 1200, height = 600, margin = list(
  l = 200,
  r = 50,
  b = 50,
  t = 200,
  pad = 20
))
fig <- fig %>% add_lines(x=~Date[df$Plug_Category=="Fridge"&df$Household == "4"], y=~PowerPerDay[df$Plug_Category=="Fridge"&df$Household == "4"], name="Fridge",
                         line=list(color="#33CFA5")) 
fig <- fig %>% add_lines(x=~Date[df$Plug_Category=="Fridge"&df$Household == "6"], y=~PowerPerDay[df$Plug_Category=="Fridge"&df$Household == "6"], name="Fridge",
                         line=list(color="#33CFA5")) 
fig <- fig %>% add_lines(x=~Date[df$Plug_Category=="Fridge"&df$Household == "5"], y=~PowerPerDay[df$Plug_Category=="Fridge"&df$Household == "5"], name="Fridge",
                         line=list(color="#33CFA5")) 
fig <- fig %>% add_lines(x=~Date[df$Plug_Category=="Entertainment"&df$Household == "4"], y=~PowerPerDay[df$Plug_Category=="Entertainment"&df$Household == "4"], name="Entertainment",
                         line=list(color="#F06A6A")) 
fig <- fig %>% add_lines(x=~Date[df$Plug_Category=="Entertainment"&df$Household == "6"], y=~PowerPerDay[df$Plug_Category=="Entertainment"&df$Household == "6"], name="Entertainment",
                         line=list(color="#F06A6A")) 

fig <- fig %>% add_lines(x=~Date[df$Plug_Category=="Entertainment"&df$Household == "5"], y=~PowerPerDay[df$Plug_Category=="Entertainment"&df$Household == "5"], name="Entertainment",
                         line=list(color="#F06A6A")) 
fig <- fig %>% layout(title = list(text = "        
                      Fridge and Entertainment Electricity Consumption per Day", y = 0.8), showlegend=FALSE,
                      xaxis=list(title="Date"),
                      yaxis=list(title="Power(Hz)"),updatemenus=updatemenus)
fig