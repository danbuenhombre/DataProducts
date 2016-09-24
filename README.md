# DataProducts
## Introduction

Every five or six years, the United States Energy Information Administration (EID) publishes the results of a very detailed survey of residential energy consumption (RECS).  

This data product is a tool to be used to browse only a very small subset of this data.  The tool allows the user to filter the data set by different geographic regions as well as by some demographic variables such as house type, income level, etc.  The tool has two different chart types: bar chart and scatterplot.  Future enhancements could be allowing for chart facets by demographics and to break down the energy usage by end use category.   

Because I have not yet completed all of the Coursera Data Science statistical courses and the fact that I have no background in statistics, the calculations in this tool are rather simple.  The bar chart will show a weighted mean by demographic and the scatterplot will show any possible relationship energy usage/cost and size of house.  The scatterplot will represent a linear model line using ggplot2's stat_smooth(model=lm) function.   
   
This dataset took a fair amount of data wrangling to make a reproducible product.  I give a high level overview on the last slide.  I hope to use this dataset for my Capstone project.
