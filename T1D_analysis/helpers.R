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
  home <- file.path("/", "mnt", "central_nas", "projects", 
                     "type1_diabetes", "nathan", "BlockCourse")

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
    folder_script = folder_script
  )

  return(paths)
}

#' Parameters to save plots
plotsave_param <- list(
  device = "png", units = "mm",
  width = 300, height = 200, dpi = 300
)

plotsave_param_large <- list(
  device = "png", units = "mm",
  width = 600, height = 400, dpi = 300
)



#' Color palettes for plotting
palettes <- list(
  colors = c("#DC050C", "#FB8072", "#1965B0", "#7BAFDE", "#882E72",
             "#B17BA6", "#FF7F00", "#FDB462", "#E7298A", "#E78AC3",
             "#33A02C", "#B2DF8A", "#55A1B1", "#8DD3C7", "#A6761D",
             "#E6AB02", "#7570B3", "#BEAED4", "#666666", "#999999",
             "#aa8282", "#d4b7b7", "#8600bf", "#ba5ce3", "#808000",
             "#aeae5c", "#1e90ff", "#00bfff", "#56ff0d", "#ffff00"),

  colors50 = c("#C4625D", "#DE7390", "#B35A77", "#87638F", "#B65E46",
               "#3A7BB4", "#CDA12C", "#D46A42", "#93539D", "#56A354",
               "#F67A0D", "#C78DAB", "#D06C78", "#A9572E", "#B06A29",
               "#4CAD4E", "#419584", "#BF862B", "#735B81", "#449D72",
               "#7A7380", "#8F4A68", "#FFC81D", "#566B9B", "#48A460",
               "#999999", "#FFDD25", "#EB7AA9", "#E585B8", "#F9F432",
               "#AB3A4E", "#3A85A8", "#E41A1C", "#3D8D96", "#E57227",
               "#B791A5", "#629363", "#C72A35", "#FFF12D", "#F581BE",
               "#6E8371", "#D689B1", "#FF9E0C", "#C3655F", "#EBD930",
               "#DCBD2E", "#A25392", "#FF8904", "#FFB314", "#A8959F"),
  
  colorsfull = grDevices::colors()[grep("gr(a|e)y", grDevices::colors(), invert = TRUE)],

  stages = c(
    "NoDiabetes" = "#3182BD", 
    "RecentOnset" = "#E31A1C"
  ),

  cases = c(
    "6227" = "#ff996c", "6396" = "#5e4395"
  ),

  casestages = c(
    "6227" = "#3182BD", "6396" = "#E31A1C"
))


#' Plotting themes for ggplot2
mytheme <- list(
  standard = function(base_size = 16, base_family = "Arial") {
    theme(
      plot.title = element_text(size = 24),

      legend.title = element_text(size = 14),
      legend.text = element_text(size = 14),

      axis.title = element_text(size = 12),
      axis.text = element_text(size = 10),
      axis.line  = element_line(linewidth = 0.3),
      axis.ticks = element_line(linewidth = 0.3),

      strip.text = element_text(size = 12),
      strip.background = element_blank(),

      panel.background = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.spacing.x = unit(0.1, "line")
    )
  },
  standard_new = function(base_size = 22, base_family = "Arial") {
    theme(
      plot.title = element_text(size = 28),

      legend.title = element_text(size = 25),
      legend.text = element_text(size = 22),

      axis.title = element_text(size = 22),
      axis.text = element_text(size = 22),
      axis.line  = element_line(linewidth = 0.4),
      axis.ticks = element_line(linewidth = 0.4),

      strip.text = element_text(size = 25),
      strip.background = element_blank(),

      panel.background = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.spacing.x = unit(0.3, "line")
    )
  },
  large = function(base_size = 24, base_family = "Arial") {
    theme(
      plot.title = element_text(size = 32),

      legend.title = element_text(size = 24),
      legend.text = element_text(size = 24),

      axis.title = element_text(size = 20),
      axis.text = element_text(size = 16),
      axis.line  = element_line(linewidth = 0.5),
      axis.ticks = element_line(linewidth = 0.5),

      strip.text = element_text(size = 20),
      strip.background = element_blank(),

      panel.background = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.spacing.x = unit(0.5, "line")
    )
  })




#' #' summarize_heatmap
#' #' Returns median counts by cluster and by channel.
#' #'
#' #' @param x A `SingleCellExperiment` or `SpatialExperiment` object.
#' #' @param expr_values A string corresponding to an assay in x, should be in `assayNames(x)`.
#' #' @param cluster_by Name of the column containing the clusters.
#' #' @param channels Channels to include, should be in `rownames(x)`. If `NULL`, all channels will be summarized.
#' #' @param fun c("median","mean") chose if the median or the mean should be returned (default:"median") (optional).
#' #'
#' #' @return summarized data as a matrix.
#' #' @export
#'
summarize_heatmap <- function(x, expr_values, cluster_by, channels = NULL, fun = "median") {
  require(data.table)
  # Argument checks
  if (is.null(expr_values) || !(expr_values %in% SummarizedExperiment::assayNames(x))) {
    expr_values <- SummarizedExperiment::assayNames(x)[1]
    print(paste0("Warning: Assay type not provided or assay type not in 'assayNames(x)', '", expr_values, "' used."))
  }
  if (is.null(channels)) {
    channels <- rownames(x)
  }
  if (!all(channels %in% rownames(x))) {
    stop("Channel names do not correspond to the rownames of the assay")
  }
  if (is.null(cluster_by)) {
    stop("Cluster column not provided")
  }
  if (!(cluster_by %in% colnames(SummarizedExperiment::colData(x)))) {
    stop("The 'cluster_by' argument should correspond to a colData(x) column")
  }
  if (length(cluster_by) > 1) {
    stop("'cluster_by' takes only one argument")
  }

  if (length(expr_values) > 1) {
    stop("'expr_values' takes only one argument")
  }
  if (!(fun %in% c("median", "mean"))) {
    stop("'fun' takes either 'median' or 'mean' as an argument")
  }

  # Convert the data to a melted format
  if (expr_values %in% SummarizedExperiment::assayNames(x)) {
    dat <- as.data.table(t(SummarizedExperiment::assay(x, expr_values)[channels, ]))
  } else if (expr_values %in% SummarizedExperiment::reducedDimNames(x)) {
    dat <- as.data.table(t(SummarizedExperiment::assay(x, "exprs")[channels, ]))
  }
  dat[, id := colnames(x)]
  dat[, cluster := SummarizedExperiment::colData(x)[, cluster_by]]
  dat <- melt.data.table(dat,
                         id.vars = c("id", "cluster"),
                         variable.name = "channel",
                         value.name = expr_values)

  # Summarize the data
  # Get mean/median for each cluster and channel combination
  if (fun == "median") {
    dat_summary <- dat[, list(
      summarized_val = median(get(expr_values)),
      cellspercluster = .N),
      by = c("channel", "cluster")]
  } else if (fun == "mean") {
    dat_summary <- dat[, list(
      summarized_val = mean(get(expr_values)),
      cellspercluster = .N),
      by = c("channel", "cluster")]
  }
  # Decast the summarized data and convert to a matrix
  hm_cell <- dcast.data.table(dat_summary,
                              formula = "cluster ~ channel",
                              value.var = "summarized_val")
  hm_clusters <- hm_cell$cluster
  hm_cell <- as.matrix(hm_cell[, -1, with = FALSE])

  # Add rownames
  rownames(hm_cell) <- hm_clusters
  # Return the summarized values
  return(as.matrix(hm_cell))
}



#' plot_dim_red
#' Plot a variable on reduced dimensions
#'
#' @param dat A `data.frame`.
#' @param dimred the name of the reduced dimensions to use.
#' @param color_by Name of the `colData(sce)`column containing the variable to color by.
#' @param sample (boolean) should the rows of `dat` be randomly sampled.
#' @param size point size.
#' @param alpha point alpha.
#' @param axes.label vector indicating the labels of the x and y axes.
#' @param palette vector indicating the color values to use.
#' @param palette_continuous (boolean) should a continuous (rather than discrete) color palette by used.
#'
#' @return a `ggplot` object
#' @export

plot_dim_red <- function(dat, dimred, color_by, sample = TRUE,
                         size = 0.1, alpha = 0.5, axes_labels = c("Reduced dim 1", "Reduced dim 2"),
                         palette = NULL, palette_continuous = FALSE) {
  if (sample == TRUE)
    dat <- dat[sample(nrow(dat)), ]

  p <- dat |>
    ggplot2::ggplot(ggplot2::aes(x = get(paste0(dimred, ".1")),
                                 y = get(paste0(dimred, ".2")))) +
    ggplot2::ggtitle(paste(dimred, color_by, sep = "-")) +
    ggplot2::guides(color = ggplot2::guide_legend(title = color_by, override.aes = list(size = 2, alpha = 1))) +
    ggplot2::labs(x = axes_labels[1], y = axes_labels[2]) +
    mytheme$standard() +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
    )

  nval <- nrow(unique(dat[, color_by]))
  if (is.null(nval)) { 
    nval <- length(unique(dat[, color_by]))
  }
  # nval.pal <- ifelse(is.null(palette), nval, length(palette))


  if (isFALSE(palette_continuous)) {
    p <- p +
      ggplot2::geom_point(ggplot2::aes(color = as.factor(get(color_by))),
                          size = size, alpha = alpha)
    if (is.null(palette) && nval > 200) {
      stop("Please provide a palette with enough colors or set `palette_continuous` as `TRUE`")
    } else if (!is.null(palette)) {
      p <- p + ggplot2::scale_colour_manual(values = palette)
    } else if (nval <= 15) {
      p <- p + ggplot2::scale_colour_manual(values = palettes$colors[c(FALSE, TRUE)])
    } else if (nval <= 30) {
      p <- p + ggplot2::scale_colour_manual(values = palettes$colors)
    } else if (nval <= 50) {
      p <- p + ggplot2::scale_colour_manual(values = palettes$colors50)
    } else {
      p <- p + ggplot2::scale_colour_manual(values = palettes$colorsfull)
    }  
  } else {
    p <- p +
      ggplot2::geom_point(ggplot2::aes(color = get(color_by)),
                          size = size, alpha = alpha)
    if (!is.null(palette)) {
      p <- p + ggplot2::scale_color_continuous(type = palette)
    } else {
      require(viridis)
      p <- p + scale_color_viridis(option = "viridis")
    }
  }
  return(p)
}


#' plot_dim_red_channels
#' Plot markers on reduced dimensions
#'
#' @param dat A `data.frame`.
#' @param dimred the name of the reduced dimensions to use.
#' @param expr_values the name of the assay to use.
#' @param channels a vector containing the channels to use.
#' @param censor_val counts censor value (percentile clipping).
#' @param ncol number of column in facetted plot.
#' @param size point size (only used if data is displayed as points).
#' @param alpha point alpha (only used if data is displayed as points).
#' @param axes.label vector indicating the labels of the x and y axes.
#' @param force_points (boolean) force display of points rather than summary statistics.
#'
#' @return a `ggplot` object
#' @export

plot_dim_red_channels <- function(
    dat, dimred, expr_values, channels, censor_val = 0.95,
    axes_labels = c("Reduced dim 1", "Reduced dim 2"),
    ncol = ceiling(sqrt(length(channels))), size = 0.5, alpha = 1,
    force_points = FALSE) {

  p <- dat[dat$channel %in% channels & sample(nrow(dat)), ] |>
    ggplot2::ggplot(ggplot2::aes(x = get(paste0(dimred, ".1")),
                                 y = get(paste0(dimred, ".2")))) +
    ggplot2::facet_wrap(~channel, ncol = ncol) +
    ggplot2::ggtitle(paste(dimred, expr_values, sep = "-")) +
    ggplot2::labs(x = axes_labels[1], y = axes_labels[2]) +
    mytheme$large() +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
    )

  if (isTRUE(force_points)) {
    p <- p + ggplot2::geom_point(ggplot2::aes(color = censor_dat(get(expr_values), censor_val)),
                                 size = size, alpha = alpha) +
      viridis::scale_color_viridis(name = expr_values, option = "viridis")
  } else {
    p <- p + ggplot2::stat_summary_2d(ggplot2::aes(z = censor_dat(get(expr_values), censor_val)),
                                      bins = 500, fun = sample_one) +
      viridis::scale_fill_viridis(name = expr_values, option = "viridis")
  }

  return(p)
}


#' censor_dat
#' Function copied from [bbRtools](https://github.com/BodenmillerGroup/bbRtools).
#' Removes the outliers on the upper side by capping the values at the provided quantile.
#'
#' @param x values to censor
#' @param quant quantile to censor, i.e. how many percent of values are considered outliers
#' @param symmetric censor on both side. In this case the outliers are assumed to be symetric on both sides. For example if a quantile of 5\% (0.05) is choosen, in the symetric case 2.5\% (0.025) of values are censored on both sides.
#'
#' @return returns the percentile of each value of x
#' @export

censor_dat <- function(x, quant = 0.999, symmetric = FALSE) {
  if (symmetric) {
    lower_quant <- (1 - quant)/2
    quant <- quant + lower_quant
  }
  q <- stats::quantile(x, quant)
  x[x > q] <- q
  if (symmetric) {
    q <- stats::quantile(x, lower_quant)
    x[x < q] <- q
  }
  return(x)
}


#' plot_violins
#' Plot violin plots
#'
#' @param dat A `data.frame`.
#' @param x x axis variable.
#' @param y y axis variable.
#' @param fill_by Variable to fill by.
#' @param color_by (optional) Variable to color by.
#' @param facet_by (optional) Variable to facet by.
#' @param ncol number of column in facetted plot.
#' @param title Graph title.
#'
#' @return a `ggplot` object
#' @export

plot_violin <- function(dat, x, y, fill_by, color_by = NULL,
                        facet_by = NULL, ncol = NULL, title = NULL,
                        scales = "fixed") {

  p <- ggplot(dat, aes(x = get(x), y = get(y))) +
    viridis::scale_fill_viridis() +
    mytheme$standard() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      panel.background = element_rect(colour = "grey20")
    )

  if (is.null(color_by))
    p <- p + geom_violin(ggplot2::aes(fill = get(fill_by)),
                         draw_quantiles = 0.5, scale = "width", lwd = 0.3) +
      ggplot2::labs(x = x, y = y, fill = fill_by)
  else
    p <- p + geom_violin(ggplot2::aes(fill = get(fill_by), color = get(color_by)),
                         draw_quantiles = 0.5, scale = "width", lwd = 0.3) +
      ggplot2::labs(x = x, y = y, fill = fill_by, color = color_by)

  if (!is.null(facet_by))
    p <- p + facet_wrap(~get(facet_by), ncol = ncol, scales = scales)

  if (is.null(title))
    p <- p + ggtitle(paste(x, y, sep = " - "))
  else
    p <- p + ggtitle(title)

  return(p)
}

#' imgloader
#' Wrapper to load images and masks as `CytoImageList` objects for plotting with `cytomapper`.
#' No checks whatsoever so make sure the arguments and outputs are right.
#'
#' @param x a `SingleCellExperiment` or `SpatialExperiment` object.
#' @param image_dir directory containing the images to load
#' @param image_names names of the images to load.
#' @param suffix_rem suffix to remove from image names.
#' @param suffix_add suffix to add to image names.
#' @param bit.depth image bit depth.
#' @param type either "stacks" or "masks", depending on the object to return.
#' @param ... additional arguments to pass to the cytomapper::loadImages() function.
#' @return a `CytoImageList` object, containin either image stacks or masks.

imgloader <- function(x, image_dir, image_names,
                     suffix_rem = "", suffix_add = "",
                     bit_depth = 16, type, ...) {
  require(cytomapper)

  image_list <- file.path(image_dir, image_names)

  # Test if the image list exist
  test_exist <- which(!file.exists(image_list))
  if (length(test_exist) > 0) {
    stop(c("The following images were not found:\n",
           paste(image_list[test_exist], collapse = "\n")))
  } else {
    # Load and scale the images
    images <- loadImages(image_list, ...)
    # images <- scaleImages(images, (2 ^ bit.depth) - 1)

    # Add image names to metadata
    mcols(images)$ImageName <- gsub(suffix_rem, "", names(images))
    mcols(images)$ImageName <- paste0(mcols(images)$ImageName, suffix_add)

    # Add channel names
    if (type == "stacks") {
      channelNames(images) <- rownames(x)
    }

    return(images)
  }
}
