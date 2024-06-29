# Load packages
library(biblio)
library(sf)
library(markdown)

# Set variables
File <- "data-raw/georeferenced-papers.kml"
Layers <- st_layers(File)$name[-1]

# Read KML layer-wise
Localities <- list()
for (i in Layers) {
  Localities[[i]] <- (st_read(File, i))
  Localities[[i]]$bibtexkey <- i
}

# Compact
Localities <- do.call(rbind, Localities)["bibtexkey"]
Localities <- st_zm(Localities) # Drop Z dimension
Localities

# Read references
Bib <- read_bib("data-raw/references.bib")
Bib

Refs <- list()
for (i in 1:nrow(Bib)) {
  Refs[[Bib$bibtexkey[i]]] <- data.frame(
      bibtexkey = Bib$bibtexkey[i],
      citation = markdownToHTML(paste(capture.output(print(as(Bib[i, ],
                          "bibentry"))),
              collapse = " "), fragment.only = TRUE))
}
Refs <- do.call(rbind, Refs)

Localities <- merge(Localities, Refs)
Localities

# Test Mapping options
library(leaflet)

leaflet(Localities) %>%
    addTiles() %>%
    addCircleMarkers(radius = 5, color = "red", popup = ~citation)

# Save localities
saveRDS(Localities, "data/Localities.rds")
