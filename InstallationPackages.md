# Install Computational Packages and Applications

## Conda and Python

### Setup Conda:
Go to this link and follow the instruction: 
https://docs.anaconda.com/miniconda/miniconda-install/

Make a new conda environment using the following command:

```{bash}
conda create -n BlockCourse python=3.10
```
When prompted to install further packages, press "y".

Then, activate the newly created Conda environment 
and install the appropriate packages required to run the two Juypter notebooks. 

```{bash}
conda activate BlockCourse
conda install -c conda-forge jupyter path pandas notebook scikit-image
```

Start the notebook from your command line:
```{bash}
jupyter notebook 
```

## Install R

### Download R 

Download R version **4.4.1**!

Go to this website: https://cran.rstudio.com/.
Select the appropriate Version for your operating system (macOS/Windows/Linux).

As suggested on the website, for macOS/Windows select the **binaries and NOT the source code**. 
Download the binaries, execute them, and follow the instructions of the installer. 

After installation, you should be able now to either: 
- open the R application 
- OR open R from your command line, just by typing:

```{bash}
R
```

### Verify R installation

Test that R was successfully installed by running:

```{bash}
R --version
```

### Install R packages

First: Open R, by typing "R" in your command line or opening the R application.

Then, install the following packages from Bioconductor.
When prompted, select the Switzerland mirror to download the R-packages. 
This will significantly speed up the download process.

```{R}
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
```

```{r}
BiocManager::install("CATALYST")
BiocManager::install("SpatialExperiment")
BiocManager::install("imcRtools")
BiocManager::install("batchelor")
```

FIXME: ADD other packages here.

## Install R-Studio

RStudio is the IDE of choice to work with R. 
In other words, R-Studio is a graphical interface from within it is easier to run R code and develop R-scripts.

### Installation R-Studio
Go to: https://posit.co/download/rstudio-desktop/
Download + Install + Open the R-Studio application.
