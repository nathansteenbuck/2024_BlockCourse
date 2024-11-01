import os
import re
from ij import IJ
from register_virtual_stack import Register_Virtual_Stack_MT


# Parameters

## Change the input directory ("BASE" folder), and the case and panel lists if needed
input_dir = "/Users/nathan/BlockCourse/"
p = re.compile("^\d{4}$")
## List directory
cases = os.listdir(input_dir)
caseList = [x for x in cases if p.match(x)]

#

# # Use this format to process multiple cases: ("6289", "6310", "6328") # Use this format to process a single case: (["6450"])
panels = (["Compressed"])  # Use this format to process multiple panels (do not include the base panel): ("Islet2", "Lympho", "Myelo")  # Use this format to process a single panel: (["Immune"])
panel_base = "Uncompressed" # Base panel (used to define the ROIs)
img_ext = ".tif" # Image extension

###############

# Registration settings

## Shrinkage option (False = 0)
use_shrinking_constraint = 0

## Save transforms
save_transforms = 1
		 
p = Register_Virtual_Stack_MT.Param()

## SIFT parameters:
p.sift.maxOctaveSize = 1024
p.sift.fdSize = 8
p.sift.initialSigma = 1.6
p.sift.steps = 3	
p.maxEpsilon = 25

## 0=TRANSLATION, 1=RIGID, 2=SIMILARITY, 3=AFFINE
p.featuresModelIndex = 3
## 0=TRANSLATION, 1=RIGID, 2=SIMILARITY, 3=AFFINE, 4=ELASTIC, 5=MOVING_LEAST_SQUARES
p.registrationModelIndex = 3

## The "inlier ratio":
p.minInlierRatio = 0.05

###############

# MAIN

for case in caseList:
	dir_case = os.path.join(input_dir, case + os.sep)
	dir_input = os.path.join(dir_case, "original")
	dir_output = os.path.join(dir_case, "registered")
	
	for panel in panels:
		if (str(panel) != str(panel_base)):	
			subdir_input = os.path.join(dir_input, panel + os.sep)
			subdir_output = os.path.join(dir_output, panel + os.sep)
			dir_transf = subdir_input
			if not os.path.exists(subdir_output):
				os.mkdir(subdir_output)
				
			print("Processing case: " + str(case) + " - Panel " + str(panel))
			input_files = [fl for fl in os.listdir(subdir_input) if os.path.isfile(os.path.join(subdir_input, fl))]

			# Select the reference image (not the image corresponding to the base panel)
			for cur_file in input_files:
				if (((panel_base + "-DAPI.") not in cur_file) and (cur_file.endswith(img_ext))):
					reference_image = cur_file
					print(reference_image)

			# Execute alignment.
			print ("Aligning..." + reference_image)
			Register_Virtual_Stack_MT.exec(subdir_input, subdir_output, dir_transf, reference_image, p, use_shrinking_constraint)

			# Close the alignment window (comment out to check the alignment)
			IJ.run("Close")

print("done")
