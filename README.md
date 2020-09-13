# DataTransformationSourceSet
Hello world! 
Brief introduction and usage explanation of this project.


Contains: 2 folders, 2 .R files

Folder "Bodies": contains the cores of the procedures for 
each transformation
Folder "Loops": contains the loops calling the bodies

File "poisson_data_gen.R": generates Poisson data
File "main.R": wrapper and main file of the project


USAGE:
> setwd('~/Your/Path/to/Folder/SourceSet_Loop')
> source('./main.R')


OUTPUT
1 "ps*TRANSFORMATION*.csv" file for each transformation: 
contains the collected primary sets

1 "*TRANSFORMATION*.csv" file for each transformation:
contains the 5000x13 matrix of results

1 "collapsed*TRANSFORMATION*_counts.csv" file for each
transformation: contains the final 1x14 matrix of counts

1 "collapsed*TRANSFORMATION*_percent.csv" file for each
transformation: contains the final 1x14 matrix of 
percentages

1 "DataNoise01_counts.csv" file: contains the very final
matrix of counts of all transformations

1 "DataNoise01_percent.csv" file: contains the very final
matrix of percentages of all transformations


++NOTES++: 
-Parameters n, lambda_true, lambda_noise already set
-Permutations set to TRUE
-If wanting to include results for NEGATIVE BINOMIAL 
residuals must uncomment all the commented lines
