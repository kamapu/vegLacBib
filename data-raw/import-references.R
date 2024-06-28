library(biblio)

Bib <- read_bib("../../db-dumps/literatur_db/bib/MiguelReferences.bib")
Sel <- read.csv("data-raw/references.csv")

Bib <- subset(Bib, bibtexkey %in% Sel$bibtexkey)
Bib$journal <- Bib$journaltitle
Bib

write_bib(Bib, "data-raw/references.bib")
