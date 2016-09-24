library(shiny)
library(ggplot2)
library(dplyr)
library(lazyeval)
shinyServer(function(input, output, session) { 
    
    observe({
        # When geography select is changed, update geography filter list
        g <- input$geography 
        if (g=="All") {
            gl <- "All"
        } else {
            gl <- GetFilterList(recs.list, g)
        }
        updateSelectInput(session, "geogFilter", choices = gl)
    })

    observe({
        # When demographic select is changed, update the demographic filter list
        d <- input$demographic 
        dl <- GetFilterList(recs.list, d)
        updateSelectInput(session, "demoFilter", choices = dl, selected = "All")
    })
    
    observe({
        input$geogFilter
        input$demoFilter
    })
    
    output$recsPlot <- renderPlot({
        
        # Figure out which variable to use for the X axis
        #  Electric energy usage KWH
        #  Nat Gas energy usage CUFEETNG
        #  Electric cost in USD DOLLAREL
        #  Nat Gas cost in USD DOLLARNG
        if (input$energyCost=="Energy Usage") {
            if (input$elecNG=="Electricity") {
                xAxis <- "KWH"
            } else {
                xAxis <- "CUFEETNG"
            }
        } else {
            if (input$elecNG=="Electricity") {
                xAxis <- "DOLLAREL"
            } else {
                xAxis <- "DOLLARNG"
            }
        }
        
        g <- input$geography
        gf <- input$geogFilter
        d <- input$demographic
        df <- input$demoFilter
        
        # Bar plot calculates weighted mean by demographic
        if (input$meanSqFt=="Bar") {
            plotDF <- CalcMean(recs.list, g, gf, d, df, xAxis)
            
            # Remove parentheticals from variable descriptions for labels
            xAxisLabel <- recs.list$recs.codebook[recs.list$recs.codebook$variable_name==xAxis,]$variable_description
            xAxisLabel <- unlist(strsplit(xAxisLabel,"\\("))[1]
            xAxisLabel <- paste("Average:", xAxisLabel)
            yAxisLabel <- recs.list$recs.codebook[recs.list$recs.codebook$variable_name==input$demographic,]$variable_description
            yAxisLabel <- unlist(strsplit(yAxisLabel,"\\("))[1]
            
            p <- ggplot(plotDF, aes(x=xAxis, y=yAxis))
            p <- p + geom_bar(stat="identity")
            p <- p + coord_flip()
            p <- p + xlab(yAxisLabel) + ylab(xAxisLabel)
            p
        } else {
            yAxis <- "TOTSQFT"
            
            plotDF <- GenerateScatterDF(recs.list, g, gf, d, df, xAxis, yAxis)
            
            if (nrow(plotDF)>0) {
                maxX <- max(plotDF$xAxis)
                
                # Remove parentheticals from variable descriptions for labels
                xAxisLabel <- recs.list$recs.codebook[recs.list$recs.codebook$variable_name==xAxis,]$variable_description
                xAxisLabel <- unlist(strsplit(xAxisLabel,"\\("))[1]
                yAxisLabel <- recs.list$recs.codebook[recs.list$recs.codebook$variable_name==yAxis,]$variable_description
                yAxisLabel <- unlist(strsplit(yAxisLabel,"\\("))[1]
                
                # plot
                p <- ggplot(plotDF, aes(x=xAxis, y=yAxis))
                p <- p + geom_point()
                p <- p + scale_x_continuous(limits = c(0,maxX), 
                                            breaks = seq(0, maxX, round(maxX/10,0)), 
                                            labels=scales::comma)
                p <- p + stat_smooth(method=lm)
                p <- p + xlab(xAxisLabel) + ylab(yAxisLabel)
                p <- p + theme(axis.text.x = element_text(angle = 45, hjust = 1))
                p
            }
        }
    })
    
})