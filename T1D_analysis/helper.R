library(ggplot2)
library(dplyr)
library(SpatialExperiment)
library(SummarizedExperiment)

# Helper functions for T1D analysis
#' List of functions
#' - `getPaths`: get default paths for the analysis (change the values if needed).
#' - `censor_dat`: removes the outliers on the upper side by capping the values at the provided quantile (copied from bbRtools).
#' - `summarizeHeatmap`: function to return mean or median counts by cluster and by channel from a `SingleCellExperiment` object.
#' - `plotDimRed`: plot reduced dimension and color by variable.
#' - `plotDimRedchannels`: plot markers on reduced dimensions.
#' - `plotBoxes`: plot boxplots.
#' - `plotViolins`: plot violin plots.
#' - `plotDensity`: plot density plots.
#' - `calcCompo` : calculate cell type composition.
#' - `YOLOader` : there are two ways to build `CytoImageList` objects: the proper way and YOLOader.
#' - `sample_one`: sample exactly one element (copied from bbsnippets, heatscatter).
#' - `mytheme`: Plotting theme for ggplot2

#' getPaths
#' @return paths of data, git and output folders
getPaths <- function(script_name) {
  home <- file.path("/Users/nathan/Downloads/2024_BlockCourse")

  home_data <- file.path(home)

  home_analysis <- file.path(home, "T1D_analysis")

  script_name <- gsub(".Rmd", "", script_name)
  panel_type <- gsub("[^_]*_[^_]*_[^_]*_", "", script_name)
  object_type <- gsub(paste0("_", panel_type), "", script_name)
  object_type <- gsub("[^_]*_[^_]*_", "", object_type)


  folder_in <- file.path(home_data, "processing")
  
  folder_out <- file.path(home_data, "results")
  if (!dir.exists(folder_out)) dir.create(folder_out)

  folder_script <- file.path(folder_out, script_name)
  if (!dir.exists(folder_script)) dir.create(folder_script)
  
  paths <- list(
    panel_type = panel_type,
    home = home,
    object_type = object_type,
    home_git = home_analysis,
    home_data = home_data,
    folder_in = folder_in,
    folder_out = folder_out,
    folder_script = folder_script,
  )

  return(paths)
}

