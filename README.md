# CreatParallelScript
This R script will help you to create a parallel script.

1.Requirements

GNU Parallel and R packages "optparse" are needed to run this script

	you can install Parallel by command: yum install parallel

	you can install Parallel by command in your R: install.packages("optparse")

2.USAGE

	Rscript /path_Rscript/parallel.R -h/--help

	Options:
        -i INPUT, --input=INPUT
                the *.sh that need to split

        -d DIR, --dir=DIR
                a folder that stores files after spliting *.sh

        -l LINE, --line=LINE
                how many lines to split into a file

        -m MAXJOB, --maxjob=MAXJOB
                how many jobs are parallel at a time, maxjob must be less than line

        -o OUTPUT, --output=OUTPUT
                final output to run later

        -p PFILE, --pfile=PFILE
                parallel dir

        -r, --rep
                ifelse need report

        -h, --help
                Show this help message and exit
For example, if test.sh has A, B, C, D, E, F, G script or command line.

The parameter -l 3 will generate the work_001.sh including A,B,C, the work_002.sh including D,E,F, and the work_003.sh including G.

The parameter -m 2 will make the above work_001.sh and work_002.sh run parallel, work_003.sh will run automatically after work_001.sh and work_002.sh were completed. 

example:

	Rscript /path_Rscript/parallel.R -i /path_script/test.sh -d /dir_split/job/ -l 3 -m 2 -o /path_output/run.sh -p    
	/usr/bin/parallel #first we need to creat a pre-run run.sh
	
	nohup sh /path_output/run.sh & #later we run run.sh by nohup
