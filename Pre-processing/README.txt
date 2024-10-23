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