# **IMC data processing pipeline**

## **Introduction**

This pipeline extracts image data from Imaging Mass Cytometry aquisitions, performs cell-level image segmentation and extracts measurements from the segmented objects.  
This pipeline is designed to work with two antibody panels applied to two consecutive tissue sections.

As input, the user should provide zipped folders containing IMC acquisition (one `.mcd` file with the associated `.txt` files), 
and a panel file (`panel.csv`) for each antibody panel that indicates the channels that were measured 
and the channels that should be used for segmentation. 

This pipeline is based on functions from the [steinbock package](https://github.com/BodenmillerGroup/steinbock), 
full steinbock documentation can be found here: https://bodenmillergroup.github.io/steinbock.


### **Steps**

The original pipeline contains three notebooks that should be run sequentially:
  
** 1. Preprocessing** *(current notebook)*
- Process zipped folders.
- Extract images from IMC acquisitions.
- Catch unmatched images.
  
** 2. Cell segmentation**
- Prepare cell segmentation.
- Segment cells.
  
** 3. Measurements**
- Measure cell intensities.
- Measure region properties.
- Measure cell neighbors.
- Catch unmatched data files.

### Run the Docker container

With this command you can run a Docker container interactively.

`docker run -it -p <local_PORT>:<container_PORT> -v </LOCAL_path/to/t1d_preprocessing/repo/>:</path_in/DOCKER/> -v </LOCAL_path/to_raw_files/>:</path_in/DOCKER> <DOCKER_IMAGE>`

Let's break the options down:
`-it`: Runs the Docker container interactively.  
`-v` : Lets you interact with LOCAL files in the DOCKER file system via so-called volumes.  
       Thereby, you can interact with the raw IMC data in the Docker container.  
       Make sure to provide the LOCAL paths to **(a)** the raw IMC data and **(b)** to this Github repository.  
`-p` : Specifying a port name. 

For example:  
`docker run -it -p 8080:8080 -v /mnt/central_nas/projects/type1_diabetes/nathan/BlockCourse/2024_BlockCourse/Pre-processing/:/home/T1D_preprocessing -v /mnt/central_nas/projects/type1_diabetes/nathan/BlockCourse/processing/:/home/processing/ nathanste/t1d_preprocess:latest`
