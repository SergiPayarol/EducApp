server <- function(input, output, session) {
  
  output$demo_map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron, group = "Topogràfic") %>%
      addProviderTiles(providers$Esri.WorldImagery , group = "Satèl·lit") %>%
      setView(1.683105, 41.699561, zoom = 8) %>%
      addMiniMap() %>%
      addScaleBar(position = "bottomleft") %>%
      clearShapes() %>%
      addSimpleGraticule() %>%
      addControl( html = north_arrow,
                  position = "bottomleft",
                  className = "fieldset {border: 0;}"
      )  %>%
      addLayersControl(
        baseGroups = c("Topogràfic", "Satèl·lit"),
        options = layersControlOptions(collapsed = FALSE)
      ) 
  })

  observeEvent(input$info_comarques, {
    paleta <- colorRampPalette(c("#EDD8D9", "#D27779", "#AA4648", "#710000"))
    
    mi_paleta_roja <- paleta(100)  
    
    intervalos <- cut(comarques$privat, 
                      breaks = c(0, 250, 500, 2000, Inf), 
                      labels = FALSE, 
                      include.lowest = TRUE)
    palette <- colorFactor(mi_paleta_roja, levels = unique(intervalos))
    etiquetas <- c('< 250', '> 250 - < 500', '> 500 - < 2000', '> 2000')
    colors <- c('#EDD8D9', '#E2A6A7', '#D19091', '#964549')
    
    leafletProxy("demo_map", data = comarques) %>%
      setView(1.683105, 41.699561, zoom = 8) %>%
      clearMarkerClusters() %>%
      clearControls() %>%
      addControl(html = north_arrow,
               position = "bottomleft",
               className = "fieldset {border: 0;}"
    ) %>%
      addPolygons(fillColor = ~palette(intervalos),
                  fillOpacity = 0.5,
                  color = "black",
                  weight = 1,
                  popup = ~paste0("<div style='width: 100%;'>",
                                  "<div style='display: inline-block; width: 60%;'><img src='evocom/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                  "<div style='display: inline-block; width: 40%;'><img src='piechart/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                  "</div>",
                                  "<br>",
                                  "<b>Nom comarca: </b>", comarques$NOMCOMAR, "<br>",
                                  "<b>Nombre d'analfabets: </b>", comarques$Analfabets, ". Un ", comarques$ana_prop_cat, "% del total de CAT.<br>",
                                  "<b>Nº persones sense Educació Primària: </b>", comarques$EP_incompleta, ". Un ", comarques$ep_prop_cat, "% del total de CAT.<br>"
                  )) %>%  
      addLegend(position = "bottomright", 
                colors = colors,
                labels= etiquetas,
                title = "Total") 
    updateRadioGroupButtons(session, "Id004", selected = "Centres privats")
  })
  observe({
    if(input$Id004 == "Centres privats"){
      paleta <- colorRampPalette(c("#EDD8D9", "#D27779", "#AA4648", "#710000"))
      
      mi_paleta_roja <- paleta(4)  
      
      intervalos <- cut(comarques$privat, 
                        breaks = c(0, 250, 500, 2000, Inf), 
                        labels = FALSE, 
                        include.lowest = TRUE)

    palette <- colorFactor(mi_paleta_roja, levels = 1:4) 
    etiquetas <- c('< 250', '> 250 - < 500', '> 500 - < 2000', '> 2000')
    colors <- c('#EDD8D9', '#D27779', '#AA4648', '#710000')

    leafletProxy("demo_map", data = comarques) %>%
      clearShapes() %>%
      clearControls() %>%
      addControl(html = north_arrow,
                 position = "bottomleft",
                 className = "fieldset {border: 0;}"
      ) %>%
      addPolygons(fillColor = ~palette(intervalos),
                  fillOpacity = 0.5,
                  color = "black",
                  weight = 1,
                  popup = ~paste0("<div style='width: 100%;'>",
                                  "<div style='display: inline-block; width: 60%;'><img src='evocom/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                  "<div style='display: inline-block; width: 40%;'><img src='piechart/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                  "</div>",
                                  "<br>",
                                  "<b>Total: </b>", comarques$privat, " centres privats<br>",
                                  "<b>Nom comarca: </b>", comarques$NOMCOMAR, "<br>",
                                  "<b>Nombre d'analfabets: </b>", comarques$Analfabets, ". Un ", comarques$ana_prop_cat, "% del total de CAT.<br>",
                                  "<b>Nº persones sense Educació Primària: </b>", comarques$EP_incompleta, ". Un ", comarques$ep_prop_cat, "% del total de CAT.<br>"
                  )) %>%  
      addLegend(position = "bottomright", 
                colors = colors,
                labels= etiquetas,
                title = "Total") 
    }
  })
  observe({
    if(input$Id004 == "Centres públics"){
      paleta <- colorRampPalette(c("#EDD8D9", "#D27779", "#AA4648", "#710000"))
      
      mi_paleta_roja <- paleta(4)  
      
      intervalos <- cut(comarques$public, 
                        breaks = c(0, 1000, 5000, 10000, Inf), 
                        labels = FALSE, 
                        include.lowest = TRUE)
      
      palette <- colorFactor(mi_paleta_roja, levels = 1:4)      
      etiquetas <- c('< 1000', '> 1000 - < 5000', '> 5000 - < 10000', '> 10000')
      colors <- c('#EDD8D9', '#D27779', '#AA4648', '#710000')
      
      leafletProxy("demo_map", data = comarques) %>%
        clearShapes() %>%
        clearControls() %>%
        addControl(html = north_arrow,
                   position = "bottomleft",
                   className = "fieldset {border: 0;}"
        ) %>%
        addPolygons(fillColor = ~palette(intervalos),
                    fillOpacity = 0.5,
                    color = "black",
                    weight = 1,
                    popup = ~paste0("<div style='width: 100%;'>",
                                    "<div style='display: inline-block; width: 60%;'><img src='evocom/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                    "<div style='display: inline-block; width: 40%;'><img src='piechart/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                    "</div>",
                                    "<br>",
                                    "<b>Total: </b>", comarques$public, " centres públics<br>",
                                    "<b>Nom comarca: </b>", comarques$NOMCOMAR, "<br>",
                                    "<b>Nombre d'analfabets: </b>", comarques$Analfabets, ". Un ", comarques$ana_prop_cat, "% del total de CAT.<br>",
                                    "<b>Nº persones sense Educació Primària: </b>", comarques$EP_incompleta, ". Un ", comarques$ep_prop_cat, "% del total de CAT.<br>"
                    )) %>%  
        addLegend(position = "bottomright", 
                  colors = colors,
                  labels= etiquetas,
                  title = "Total") 
    }
  })
  observe({
    if(input$Id004 == "Total de matrícules"){
      paleta <- colorRampPalette(c("#EDD8D9", "#D27779", "#AA4648", "#710000"))
      
      mi_paleta_roja <- paleta(4)  
      
      intervalos <- cut(comarques$total, 
                        breaks = c(0, 10000, 50000, 100000, Inf), 
                        labels = FALSE, 
                        include.lowest = TRUE)
      
      palette <- colorFactor(mi_paleta_roja, levels = 1:4) 
      etiquetas <- c('< 10000', '> 10000 - < 50000', '> 50000 - < 100000', '> 100000')
      colors <- c('#EDD8D9', '#D27779', '#AA4648', '#710000')
      
      leafletProxy("demo_map", data = comarques) %>%
        clearShapes() %>%
        clearControls() %>%
        addControl(html = north_arrow,
                   position = "bottomleft",
                   className = "fieldset {border: 0;}"
        ) %>%
        addPolygons(fillColor = ~palette(intervalos),
                    fillOpacity = 0.5,
                    color = "black",
                    weight = 1,
                    popup = ~paste0("<div style='width: 100%;'>",
                                    "<div style='display: inline-block; width: 60%;'><img src='evocom/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                    "<div style='display: inline-block; width: 40%;'><img src='piechart/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                    "</div>",
                                    "<br>",
                                    "<b>Total: </b>", comarques$total, " matrícules<br>",
                                    "<b>Nom comarca: </b>", comarques$NOMCOMAR, "<br>",
                                    "<b>Nombre d'analfabets: </b>", comarques$Analfabets, ". Un ", comarques$ana_prop_cat, "% del total de CAT.<br>",
                                    "<b>Nº persones sense Educació Primària: </b>", comarques$EP_incompleta, ". Un ", comarques$ep_prop_cat, "% del total de CAT.<br>"
                    )) %>%  
        addLegend(position = "bottomright", 
                  colors = colors,
                  labels= etiquetas,
                  title = "Total") 
    }
  })
  observe({
    if(input$Id004 == "Analfabets"){
      paleta <- colorRampPalette(c("#EDD8D9", "#D27779", "#AA4648", "#710000"))
      
      mi_paleta_roja <- paleta(4)  
      
      intervalos <- cut(comarques$ana_prop_cat, 
                        breaks = c(0, 1, 10, 20, Inf), 
                        labels = FALSE, 
                        include.lowest = TRUE)
      
      palette <- colorFactor(mi_paleta_roja, levels = 1:4) 
      etiquetas <- c('< 1%', '> 1% - < 10%', '> 10% - < 20%', '> 20%')
      colors <- c('#EDD8D9', '#D27779', '#AA4648', '#710000')
      
      leafletProxy("demo_map", data = comarques) %>%
        clearShapes() %>%
        clearControls() %>%
        addControl(html = north_arrow,
                   position = "bottomleft",
                   className = "fieldset {border: 0;}"
        ) %>%
        addPolygons(fillColor = ~palette(intervalos),
                    fillOpacity = 0.5,
                    color = "black",
                    weight = 1,
                    popup = ~paste0("<div style='width: 100%;'>",
                                    "<div style='display: inline-block; width: 60%;'><img src='evocom/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                    "<div style='display: inline-block; width: 40%;'><img src='piechart/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                    "</div>",
                                    "<br>",
                                    "<b>Total: </b>", comarques$ana_prop_cat, "%<br>",
                                    "<b>Nom comarca: </b>", comarques$NOMCOMAR, "<br>",
                                    "<b>Nombre d'analfabets: </b>", comarques$Analfabets, ". Un ", comarques$ana_prop_cat, "% del total de CAT.<br>",
                                    "<b>Nº persones sense Educació Primària: </b>", comarques$EP_incompleta, ". Un ", comarques$ep_prop_cat, "% del total de CAT.<br>"
                    )) %>%  
        addLegend(position = "bottomright", 
                  colors = colors,
                  labels= etiquetas,
                  title = "Total") 
    }
  })
  observe({
    if(input$Id004 == "Educació Primària incompleta"){
      paleta <- colorRampPalette(c("#EDD8D9", "#D27779", "#AA4648", "#710000"))
      
      mi_paleta_roja <- paleta(4)  
      
      intervalos <- cut(comarques$ep_prop_cat, 
                        breaks = c(0, 1, 10, 20, Inf), 
                        labels = FALSE, 
                        include.lowest = TRUE)
      
      palette <- colorFactor(mi_paleta_roja, levels = 1:4) 
      etiquetas <- c('< 1%', '> 1% - < 10%', '> 10% - < 20%', '> 20%')
      colors <- c('#EDD8D9', '#D27779', '#AA4648', '#710000')
      
      leafletProxy("demo_map", data = comarques) %>%
        clearShapes() %>%
        clearControls() %>%
        addControl(html = north_arrow,
                   position = "bottomleft",
                   className = "fieldset {border: 0;}"
        ) %>%
        addPolygons(fillColor = ~palette(intervalos),
                    fillOpacity = 0.5,
                    color = "black",
                    weight = 1,
                    popup = ~paste0("<div style='width: 100%;'>",
                                    "<div style='display: inline-block; width: 60%;'><img src='evocom/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                    "<div style='display: inline-block; width: 40%;'><img src='piechart/i", comarques$CODICOMAR, ".png' width='100%' height='auto'></div>",
                                    "</div>",
                                    "<br>",
                                    "<b>Total: </b>", comarques$ep_prop_cat, "%<br>",
                                    "<b>Nom comarca: </b>", comarques$NOMCOMAR, "<br>",
                                    "<b>Nombre d'analfabets: </b>", comarques$Analfabets, ". Un ", comarques$ana_prop_cat, "% del total de CAT.<br>",
                                    "<b>Nº persones sense Educació Primària: </b>", comarques$EP_incompleta, ". Un ", comarques$ep_prop_cat, "% del total de CAT.<br>"
                    )) %>%  
        addLegend(position = "bottomright", 
                  colors = colors,
                  labels= etiquetas,
                  title = "Total") 
    }
  })
  
  observeEvent(input$centres_estudis, {
      leafletProxy("demo_map", data = centres) %>%
      setView(1.683105, 41.699561, zoom = 8) %>%
      clearShapes() %>%
      clearMarkers() %>%
      clearControls() %>%
      addControl(html = north_arrow,
                 position = "bottomleft",
                 className = "fieldset {border: 0;}"
      ) %>%
      addAwesomeMarkers(
        lng = centres$longitude, 
        lat = centres$latitude, 
        clusterOptions = markerClusterOptions(),
        popup = ~paste0("<img src= images/i", centres$codi,".png width = 300 heigth = 300>",
                        "<br>", "<br>",
                        "<b>Centre: </b>", centres$nom, "<br>",
                        "<b>Naturalesa: </b>", centres$naturalesa, "<br>",
                        "<b>URL: </b> <a href='", centres$url, "'>", centres$url, "</a>"
                        )
      )
  })

}