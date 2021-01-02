try(require("shiny")||install.packages("shiny"))
try(require("nFactors")||install.packages("nFactors"))
try(require("qgraph")||install.packages("qgraph"))
try(require("corrplot")||install.packages("corrplot"))

library("shiny")
library("nFactors")
library("qgraph")
library("corrplot")

if (!require(udpipe)){install.packages("udpipe")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}

library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)
getwd()

