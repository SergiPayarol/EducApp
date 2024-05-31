ui <- dashboardPage(
  skin = "red",
  title = "EducApp",
  
  dashboardHeader(
    title = span(img(src = "mobility.png", height = 35), "EducApp"),
    titleWidth = 300
  ),
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      div(class = "inlay", style = "height:15px;width:100%;background-color: #ecf0f5;"),
      menuItem("Informació per comarques",
               tabName = "informacio",
               icon = icon("info-sign", lib = "glyphicon"),
               startExpanded = TRUE,
               radioGroupButtons(inputId = "Id004",
                                 choices = c("Centres privats", "Centres públics", "Total de matrícules", "Analfabets", "Educació Primària incompleta"),
                                 selected = "Centres privats",
                                 status = "warning",
                                 size = "xs"
               ),
               h5(HTML("Podeu obtenir més informació per comarques", "<br>",
                       "clicant-hi a sobre de cada element"))
      ),
      h5(HTML("<br><br><br><br>")),
      div(style = "text-align: center;",
          img(src = "uoc.png", width = "95%", height = "auto")),
      div(style = "text-align: center;",
          h5(HTML("<br><br><br><br><br>Aquest dashboard s'ha generat per la pràctica 2 ", "<br>",
      "de l'assignatura de Visualització de dades del", "<br>",
      "màster en Ciència de dades de la UOC. Les dades", "<br>", 
      "han sigut extretes de l'ICGC, del", "<br>",
      "Departament d'Educació i de l'IDESCAT.")),
        h5(HTML("<br>Autor: Sergi payarol")),
        h5(HTML("<br>Última actualització: 30/05/2024")))
    )
  ),
  dashboardBody(
    tags$head(
      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "mobility_style.css")
    ),
    fluidRow(
      column(
        width = 12,
        div(style = "text-align: center;",
          bsButton("centres_estudis", 
                   label = "Centres Educatius", 
                   icon = icon("user", class = "glyphicon glyphicon-screenshot black", lib = "glyphicon"), 
                   style= "success"
          ),
          bsButton("info_comarques", 
                   label = "Informació per Comarques", 
                   icon = icon("info-sign", class = "glyphicon glyphicon-user green", lib = "glyphicon"), 
                   style= "success"
          )
        )
      )
      
    ),
    fluidRow(
      column(
        width = 12,
        box(
          width = 12,
          leafletOutput("demo_map",
                        height = "600px",
                        width = "100%"
          )

        )
      )
    )
  )
)