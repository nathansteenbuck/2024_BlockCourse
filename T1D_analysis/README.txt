# Analysis Block Course 2024.

This pipeline defines the major analysis pipeline for the Block Course 2024, and is directly adapted from Steenbuck/Damond et al 2024 (in preparation).

The pipeline defines 7 major steps, of which 6 are done separately per slide (i.e. either compressed or uncompressed).

These are:
- 01: Import Data: Import IMC data into Single-cell Containers.
- 02: Spillover: Perform Spillover correction on the cell-level using the acquired spillover slide.
- 03: TransformCorrect: Perform Normalization of IMC counts.
- 04: Quality Control: Perform Quality Control.
- 05: Annotation compartments: Annotation Compartments (immune, exocrine, ...)
- 06: Annotation cell Types: Annotate cell types (beta, alpha, ...)
- 07: Comparison compressed and uncompressed cell type annotation.


Major to dos:
- Simplify (esp. 02 & 04)
- Adjust paths for SPE saving -> save into same container (space)
- Adjust paths also in Region Selection scripts -> Uncompressed/Compressed.
- Adjust helper.R
- 01 - remove stuff for graphs.

