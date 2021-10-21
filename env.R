#!/usr/bin/R

# Author: Ciro Ramírez-Suástegui
# Date: 2021-10-21

# Source: https://github.com/business-science/free_r_tips/tree/master/028_esquisse_ggplot

output_dir = "~/Downloads/esquisse"
dir.create(output_dir); setwd(output_dir); system("ls -hol")

if (!requireNamespace("remotes", quietly = TRUE))
  install.packages("remotes", repos = "https://cloud.r-project.org")
if (!requireNamespace("renv", quietly = TRUE)) remotes::install_github("rstudio/renv")
if(!file.exists("renv.lock")) renv::init(bare = TRUE)
renv::snapshot(prompt = FALSE); renv::activate()

install_pckgs <- c("esquisse", "tidyverse", "shiny")
for (i in setdiff(install_pckgs, installed.packages()[, "Package"]))
  install.packages(i, repos = "https://cloud.r-project.org")

# If some installation fails
# renv::restore()

suppressPackageStartupMessages({
   tmp <- lapply(install_pckgs, library, character.only = TRUE)
})

esquisse::esquisser(iris)
