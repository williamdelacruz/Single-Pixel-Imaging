# Single Pixel Imaging
Sorting of the Hadamard basis for Single Pixel Imaging

This repository contains the source code of a sorting method of the Hadamard basis applied for single pixel imaging (SPI). The sorting method is based on generalized orthogonal basis vectors which can be represented as a two-dimensional structure of Hadamard patterns. By taken advantage of the energy concentration of the Hadamard patterns at the left upper corner of the 2D structure, it is used a zigzag traversal in order to sort the patterns in descending order of importance. The obtained ordering of the patterns, within the framework of SPI, allows to reconstruct a given target image using a small number of patterns.

The source code was written in Matlab on Windows operating system.

This repository contains the following folders and files:

## Structure
Files and folders:
- \TVAL3_beta2.4
- \coco-train2014
- \misc
- \data
- demo1.m
- demo2.m
- ...

## Configuration and data request

Initially, the folders \coco-train2014 and \misc are empty since it requires externals image reporsitories which can be downloaded by permission of the creators.

### Image Databases
Link to the images:
* [COCO dataset] (http://images.cocodataset.org/zips/train2014.zip)
* [The USC-SIPI Image Database] (https://sipi.usc.edu/database/misc.zip)

Please note that the previous links to the datasets might change with time, it is advisable to visit the web page of the providers, namely,  https://cocodataset.org/ and
https://sipi.usc.edu/database/. Once the .zip files have been downloaded, they must be uncompressed into the main directory, replacing the existing folders.

### TVL3 Tool
Link to the tool:
* [TVL3] (https://github.com/liuyang12/3DCS.git)

In the previous link, go to packages and download the folder \TVL3_beta2.4, then move it to the main directory.


## Simulation and execution

To test the Matlab library, run the demo1, demo2, demo3, demo4, or demo5 script.
