# Computational Setup

**Aim:** This markdown file outlines how to organize your code and data for the Block Course 2024.

## Directory Structure.
Go into your home directory and create your **Block Course directory**.
We will always work in this directory!

First navigate to your home directory:
Linux/macOS command line: 
```{shell}
cd ~
```

Check your current directory

```{shell}
pwd
```

Note: the absolute path to your home directory is likely something like this:
*/Users/nathan/*.

If you are in your home directory, then create the Block Course directory:

```{shell}
mkdir BlockCourse
```

The entire path into the Block-Course directory will be *~/BlockCourse"*
so e.g. something like: */Users/nathan/BlockCourse/*. 

## Github

On Github we have organized all code in one code repository.

Task: clone the github repository into your **Block Course directory** (~/BlockCourse).
**Important**: make sure that you are really within your Block Course directory, you can check this with:

```{shell}
pwd
```

Then actually clone the github repository.
```{shell}
git clone https://github.com/nathansteenbuck/2024_BlockCourse
```

The path should be:
*~/BlockCourse/2024_BlockCourse/*

Task: make yourself familiar with the directory structure. 
Brief summaries for the directories are provided in the README files.  

## IF data

Download the immuno-fluorescence data.
Ask your supervisors for the SwitchDrive link.
The directory is named RegionSelection and should contain the IF images.

The path should be:
*~/BlockCourse/region_selection/*

## IMC data

Download the IMC data.
Ask your supervisors for the SwitchDrive link.
The directory should be named: "processing" and should contain the raw IMC images.

The path should be:
*~/BlockCourse/processing/*

## Results

We will store results (plots, dataframes) in the "results" directory.

The path should be:
*~/BlockCourse/results/*


## Full directory structure:

BlockCourse
|_ results <- containing analysis results
|_ processing  <- containing IMC results
|_ region_selection <- containing IF Region Selection data + results
|_ 2024_BlockCourse <- cotaining all code




