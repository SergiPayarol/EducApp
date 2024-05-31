source('dependencies.R')


north_arrow <- "<img src='https://upload.wikimedia.org/wikipedia/commons/8/84/North_Pointer.svg' style='width:40px;height:60px;'>"
centres <- read.csv2("www/centres.csv", sep = ',')
centres$lon <- as.numeric(centres$lon)
centres$lat <- as.numeric(centres$lat)
names(centres)[names(centres) == "lon"] <- "longitude"
names(centres)[names(centres) == "lat"] <- "latitude"
alumnes <- read.csv2("www/alumnes.csv", sep = ',')
comarques <- st_read(dsn = "www/comarques_w_metriques.geojson")
comarques <- st_transform(comarques, crs = st_crs(4326))

makePopupPlot <- function (codi) {
  
  popupPlot <- ggplot(alumnes[alumnes$codi == codi,], aes(x = Any, y = value, color = variable)) +
    geom_line() +
    geom_point() +
    labs(title = paste0("Evolució de les matrícules", codi),
         x = "Any",
         y = "Matriculats",
         color = "Serie") +
    scale_color_discrete(name = NULL, labels = c("total" = "Total", 
                                                 "total_homes" = "Homes",
                                                 "total_dones" = "Dones")) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5), 
          plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm"))
  
  return (popupPlot)
}

updateMap <- function(clicked_point) {
  popup_content <- paste(
    "Valor de clicked_point:",
    clicked_point,
    "<br>",
    popupGraph(makePopupPlot(clicked_point),
               type = "png",
               width = 600,
               height = 600)
  )
  
  leafletProxy("demo_map") %>%
    addPopups(
      lng = centres$longitude[centres$codi == clicked_point], 
      lat = centres$latitude[centres$codi == clicked_point], 
      popup = popup_content
    )
}



source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)