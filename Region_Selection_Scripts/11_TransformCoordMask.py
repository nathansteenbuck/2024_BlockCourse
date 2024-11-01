import os
import shutil
from ij import IJ
from register_virtual_stack import Transform_Virtual_Stack_MT


# Parameters

## Change the input directory ("BASE" folder), and the case and panel lists if needed
input_dir = "/Users/nathan/BlockCourse/"
caseList = (["6227"]) # ADJUST THIS.

# Use this format to process multiple cases: ("6289", "6310", "6328") 
# Use this format to process a single case: (["6450"])
panels = (["Compressed"])  # Use this format to process multiple panels (do not include the base panel): ("Islet2", "Lympho", "Myelo")  # Use this format to process a single panel: (["Immune"])
panel_base = "Uncompressed" # Base panel (used to define the ROIs)
img_ext = ".tif" # Image extension

###############

# MAIN

for case in caseList:
	print(case)
	dir_case = os.path.join(input_dir, case)
	dir_coord = os.path.join(dir_case, "coord" + os.sep)
	dir_transf = os.path.join(dir_case, "original" + os.sep)

	for panel in panels:
		subdir_coord = os.path.join(dir_coord, panel + os.sep)
		subdir_transf = os.path.join(dir_transf, panel + os.sep)
		if not os.path.exists(subdir_coord):
			os.mkdir(subdir_coord)
		
		# Transform the color mask
		print ("Transforming: " + dir_case + "..." + panel)
		Transform_Virtual_Stack_MT.exec(subdir_coord, subdir_coord, subdir_transf, True)
		IJ.run("Close")

		# Rename the transformed mask
		coord_base = os.path.join(subdir_coord, case + "_Merge_" + panel_base + img_ext)
		coord_panel = os.path.join(subdir_coord, case + "_Merge_" + panel + img_ext)
		os.remove(coord_panel)
		os.rename(coord_base, coord_panel)
		
print("done")