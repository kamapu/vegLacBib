# Load packages
library(biblio)
library(sf)

# Set variables
File <- "data-raw/georeferenced-papers.kml"
Layers <- st_layers(File)$name[-1]

Localities <- list()
for (i in Layers) {
  Localities[[i]] <- (st_read(File, i))
  Localities[[i]]$bibtexkey <- i
}

Localities <- do.call(rbind, Localities)["source"]
Localities


