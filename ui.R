shinyUI(
    fluidPage(
        titlePanel("EIA RECS Data Browser"),
        fluidRow(
            column(3, 
                   wellPanel(
                       h4("Geography"),
                       selectInput("geography", label = "Filter Category", choices = GetCatList(recs.list,"geography")), 
                       selectInput("geogFilter", label = "Filter", choices = "All") 
                   ),
                   wellPanel(
                       h4("Demographics"),
                       selectInput("demographic", label = "Filter Category", choices = GetCatList(recs.list,"demographic")), 
                       selectInput("demoFilter", label = "Filter", choices = "All")
                   ),
                   wellPanel(
                       h4("Graph Choices"),
                       radioButtons("meanSqFt", "Bar: Weighted Mean or Scatter: usage compared to house size (SqFt)", choices=c("Bar","Scatter"), selected = "Bar"),
                       radioButtons("elecNG", "Electricity or Natural Gas", choices=c("Electricity","Natural Gas"), selected = "Electricity"),
                       radioButtons("energyCost", "Energy Usage or Cost", choices=c("Energy Usage","Cost in USD"), selected = "Energy Usage")
                   )
                  ),
            column(9,
                   plotOutput("recsPlot")
            )
        )
    )
)