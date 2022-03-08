## Overview
My most commonly used matlab function files are in these directories.
To use them, simply download as zip file or if you are using git, clone them your local directory. 

Then, either add them to your Matlab path "globally" by going to Home -> Set Path. 
Then click on "add with subfolders" and locate the "db.toolbox" directory that you just downloaded. 

Or simply do an addpath(genpath( path-2-db.toolbox )) call where path-2-db.toolbox is the path/directory where the toolbox was downloaded and unzipped to.
For instance, if you have the toolbox in your d: drive, then put addpath(genpath('d:/db.toolbox')) at the beginning of your script.

db, Stockholm 08.03.2022
