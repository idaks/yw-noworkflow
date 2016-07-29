<style type="text/css">
.centerImage
{
text-align:center;
display:block;
}
</style>

YesWorkflow-NoWorkflow Bridge
=============================

# Overview

The yw-noworkflow repository contains experimental code that explores how the complementary provenance 
information provided by [YesWorkflow](https://github.com/yesworkflow-org/yw-prototypes/tree/master) and [NoWorkflow](https://github.com/gems-uff/noworkflow) can be used together to yield visualizations and 
query results that neither can provide on its own.

# Installation

YesWorkflow-NoWorkflow Bridge requires the installation of both YesWorkflow and NoWorkflow, in order to perform XSB Prolog and SQL queries.

## YesWorkflow

YesWorkflow is a scientific workflow management system that extracts YW commends that users add to scripts that reveal the computational modules and dataflows, render graphical output that reveals the stages of computation and the flow of data in the script, and store the prospective provenance of the data products of scripts. 

YesWorkflow installation details and instructions can be found in [yw-prototype repository](https://github.com/yesworkflow-org/yw-prototypes).

Note that this demonstration requires **YesWorkflow 0.2.1**.The latest version of YesWorkflow can be obtained from:
```
    https://opensource.ncsa.illinois.edu/bamboo/browse/KURATOR-YSF/latestSuccessful
```
Click the Artifacts tab, then download the executable jar. The file will be named yesworkflow-0.2.1-SNAPSHOT-jar-with-dependencies.jar. You can also find the executable jar in the [releases page](https://github.com/idaks/yw-noworkflow/releases).

You may also want to define an alias to simplify running YesWorkflow at the command line.

If you have saved yesworkflow-0.2.1-SNAPSHOT-jar-with-dependencies.jar to the bin subdirectory of your home directory, the following command will create a bash alias for running YesWorkflow simply by typing yw:
```
alias yw='java -jar ~/bin/yesworkflow-0.2.1-SNAPSHOT-jar-with-dependencies.jar'
```
On Windows the command to create the yw macro is:

```
doskey yw=java -jar %USERPROFILE%\bin\yesworkflow-0.2.1-SNAPSHOT-jar-with-dependencies.jar $*
```

## NoWorkflow

NoWorkflow collects provenance for Python scripts into SQLite database. It could show provenance of a trial, compare the collected provenance of different trials, visualize the dataflow, and perform Prolog and SQL queries.

NoWorkflow installation details and instructions can be found in [noWorkflow repository](https://github.com/gems-uff/noworkflow).

## XSB Prolog and SQLite

XSB is a Logic Programming system for Unix and Windows-based platforms. SQLite is a relational database management system contained in a C programming library, and is an embedded SQL database engine. YesWorkflow-NoWorkflow Bridge will use XSB and SQLite to define rules for YesWorkflow, NoWorkflow, and the bridge, and perform queries for them. 

You can find instructions for installing XSB at [XSB Website](http://xsb.sourceforge.net/), or on [the Github page](https://github.com/flavioc/XSB).

Go to [SQLite download page](http://www.sqlite.org/download.html), and download precompiled binaries.

If you are on a Linux or Mac OS X machine, it probably is pre-installed with SQLite. Check if you already have SQLite installed on your machine or not.
```
$ sqlite3
SQLite version 3.8.10.2 2015-05-20 18:17:19
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite>
```

# Repository organization

Overall structure of the repository: 

Directory                                  | Description
-------------------------------------------|------------
./**Docker**                               | Docker file and Makefile for Docker image.
./**rules**                                | Rules for YW, NW, YW-NW bridge.
./**scripts**                              | Files that generate views and graphs for examples.
./**examples**                             | Examples that show how to use YesWorkflow-NoWorkflow Bridge.
./examples/**[exampleFolder]**             | Python scripts and output files.
./examples/[exampleFolder]/**csv**         | SQLite facts in CSV.
./examples/[exampleFolder]/**facts**       | Facts that generated by Yesworkflow and NoWorkflow, and views 
./examples/[exampleFolder]/**views**       | Views that generated from facts of Yesworkflow and NoWorkflow.
./examples/[exampleFolder]/**graph**       | Graphs that generated by YesWorkflow, NoWorkflow and YW-NW.
./examples/[exampleFolder]/**query**       | Prolog and SQLite queries for YW, NW, YW-NW and their output files.

# Usage

We will use simulate_data_collection as an example to show how to use YesWorkflow-NoWorkflow Bridge. simulate_data_collection.py collects diffraction data from high quality crystals in a cassette. It takes two input files, [cassette_q55_spreadsheet.csv](https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/cassette_q55_spreadsheet.csv) and [calibration.img](https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/calibration.img). The output files are generated in [run](https://github.com/idaks/yw-noworkflow/tree/master/examples/simulate_data_collection/run) folder. 

Go to simulate_data_collection example folder:
```
cd yw-noworkflow/examples/simulate_data_collection/
```

If you would like to reproduce the results through this demo, you can remove all derived files:

```
rm -rf facts graph query/*query_outputs.txt .noworkflow *.txt df_style.py
```

### Example YesWorkflow output

The image below was produced by YesWorkflow using the YW comments added to simulate_data_collection python script ([simulate_data_collection.py](https://github.com/yesworkflow-org/yw-noworkflow/blob/master/examples/simulate_data_collection/simulate_data_collection.py)):

<p align="center"><img src="https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/graph/yw_combined_graph.png" height="500"></p>

The green blocks represent stages in the computation performed by the script, the yellow blocks represent the input, intermediate, and final data products of the script, and the white blocks are parameters used for the script.

### Example NoWorkflow output

<p align="center"><img src="https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/graph/nw_filtered_lineage_graph.png" height="500"></p>

The white blocks are input and output data, the dark blue blocks represents computational stages, and blue-green blocks represent parameter names and their values.

### Example Yw-Noworkflow output

<p align="center"><img src="https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/graph/yw_nw_retrospective_lineage.png" height="500"></p>

## Generate visualizations and query results with Prolog

### Create facts and views from YesWorkflow

1. First, create a new folder that will store YesWorkflow facts (and NoWorkflow facts later):
    ```
    mkdir facts
    ```

1. Then run YesWorkflow for the python script `simulate_data_collection.py` marked with YW annotation through command:

    ```
    java -jar ~/bin/yesworkflow-0.2.1-SNAPSHOT-jar-with-dependencies.jar model simulate_data_collection.py \
        -c extract.language=python -c extract.factsfile=facts/yw_extract_facts.P \
        -c model.factsfile=facts/yw_model_facts.P -c query.engine=xsb
    ```

  If you've defined the alias for YesWorkflow, you can simply run:

    ```
    yw model simulate_data_collection.py -c extract.language=python -c extract.factsfile=facts/ \
        yw_extract_facts.P -c model.factsfile=facts/yw_model_facts.P -c query.engine=xsb
    ```

  In this command, `model` means building the workflow model from YW comments in the source script. `extract.language=python` specifies the language used in the source file. `extract.factsfile` and `model.factsfile` specifies the locations to save the facts for the source script and the model. `query.engine=xsb` represents the output query language to be XSB. 

  We now get the facts from the YW markup in the source script, and the corresponding models, such as annotations, ports, channels, uri template, etc. You can check these facts in `yw_extract_facts.P` and `yw_model_facts.P` file in `facts` folder.

1. Then generate [yw_views](https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/views/yw_views.P) from  the facts:

`yw_views` are views derived from facts. It organizes the yw facts in such a way that can be reused by our YesWorkflow-NoWorkflow Bridge later, and can be easily queried.

        ```
        mkdir views

        bash ../../scripts/materialize_yw_views.sh > views/yw_views.P
        ```

### Create facts and views from NoWorkflow

1. First, run python source script through NoWorkflow:

    ```
    now run -e Tracer -d 3 simulate_data_collection.py q55 --cutoff 12 --redundancy 0 > run_outputs.txt
    ```

  `now run` specifies the source script to run and collects its provenance. `-e Tracer` tag means NoWorkflow captures variables, dependencies, function calls, parameters, file accesses, and globals. `-d 3` tag represents the depth for capturing function activations is 3, for the sake of the running time. `simulate_data_collection.py q55 --cutoff 12 --redundancy 0` is the source script name and its corresponding input arguments. The output of the script is written to the `run_outputs.txt` file.

  By running NoWorkflow, it automatically creates a SQLite database under .noworkflow folder. 

1. We want to extract Prolog facts through NW command `export`:
    
    ```
    now export -t -m dependency | grep -v 'environment(' > facts/nw_facts.P
    ```

1. Then generate [nw_views](https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/views/nw_views.P) from `nw_facts`, same as we did for YesWorkflow:
    ```
    bash ../../scripts/materialize_nw_views.sh > views/nw_views.P
    ```

### Create views for YW-NW

YW-NW is created by combining blocks and parameters defined by YesWorkflow and corresponding parameters, value, and functions captured by NoWorkflow. Run the command to generate [yw_nw_views](https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/views/yw_nw_views.P):

    ```
    bash ../../scripts/materialize_yw_nw_views.sh > views/yw_nw_views.P
    ```

### Perform YW, NW, YW-NW queries

Run the queries in query/query.sh and confirm that the answers make sense.

    ```
    bash query/query.sh > query/query_outputs.txt
    
    ```

  - Sample YesWorkflow query:

    - What workflow steps comprise the top-level workflow?

    ```
    yw_q2(StepName, Description)
    ...................................................................................................
    yw_q2(log_average_image_intensity,'Record statistics about each diffraction image.').
    yw_q2(transform_images,'Correct raw image using the detector calibration image.').
    yw_q2(collect_data_set,'Collect data set using the given data collection parameters.').
    yw_q2(log_rejected_sample,'Record which samples were rejected.').
    yw_q2(calculate_strategy,'Reject unsuitable crystals and compute best data sets to collect for accepted crystals.').
    yw_q2(load_screening_results,'Load sample information from spreadsheet.').
    yw_q2(initialize_run,'Create run directory and initialize log files.').
    ```

  - Sample NoWorkflow query:

    - What variable values are passed to transform_image(...) from the top of the script?

    ```
    nw_q2(Variable, Value)
    ...................................................................................................
    nw_q2(calibration_image_file,'calibration.img').
    nw_q2(raw_image_file,'run/raw/q55/DRT240/e10000/image_001.raw').
    nw_q2(raw_image_file,'run/raw/q55/DRT322/e10000/image_001.raw').
    nw_q2(raw_image_file,'run/raw/q55/DRT240/e11000/image_002.raw').
    nw_q2(raw_image_file,'run/raw/q55/DRT322/e10000/image_002.raw').
    nw_q2(raw_image_file,'run/raw/q55/DRT240/e12000/image_001.raw').
    nw_q2(raw_image_file,'run/raw/q55/DRT322/e11000/image_001.raw').
    nw_q2(raw_image_file,'run/raw/q55/DRT240/e12000/image_002.raw').
    nw_q2(raw_image_file,'run/raw/q55/DRT240/e10000/image_002.raw').
    nw_q2(raw_image_file,'run/raw/q55/DRT322/e11000/image_002.raw').
    nw_q2(raw_image_file,'run/raw/q55/DRT240/e11000/image_001.raw').
    ```

  - Sample Yes-No Workflow query:

    - What Python variables carries values of sample_name into the calculate_strategy workflow step?

    ```
    yw_nw_q1(VariableId, VariableName, VariableValue)
    ...................................................................................................
    yw_nw_q1(255,sample_name,'DRT110').
    yw_nw_q1(361,sample_name,'DRT240').
    yw_nw_q1(2511,sample_name,'DRT322').
    ```
### Generate YW, NW, YW-NW visualizations

YesWorkflow can render three types of different views of the workflow structure from the model we built before:  a process view, a data view, and a combined (data + process) view.

We can render these views through the following commands:

We first create a new folder to contain all the visualization rendered by YW, NW, and YW-NW.
    
    mkdir graph
    
Then generate graphs as gv files, the file format used by Graphviz:

    bash ../../scripts/yw_data_graph.sh > graph/yw_data_graph.gv
    bash ../../scripts/yw_process_graph.sh > graph/yw_process_graph.gv
    bash ../../scripts/yw_combined_graph.sh > graph/yw_combined_graph.gv

Render the pdf/png format file through Graphviz:

    # pdf files
    dot -Tpdf yw_data_graph.gv -o yw_data_graph.pdf
    dot -Tpdf yw_process_graph.gv -o yw_process_graph.pdf
    dot -Tpdf yw_combined_graph.gv -o yw_combined_graph.pdf
    
    #png files
    dot -Tpng yw_data_graph.gv -o yw_data_graph.png
    dot -Tpng yw_process_graph.gv -o yw_process_graph.png
    dot -Tpng yw_combined_graph.gv -o yw_combined_graph.png
    
You can checkout the resulting images here:

yw_data_graph.png:

<p align="center"><img src="https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/graph/yw_data_graph.png" height="250"></p>

yw_process_graph.png: 

<p align="center"><img src="https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/graph/yw_process_graph.png" height="250"></p>

yw_combined_graph.png: 

<p align="center"><img src="https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/graph/yw_combined_graph.png" height="500"></p>

YesWorkflow can also generate workflow from prospective provenance.

For example, if we're interested in which steps and data products result in the "corrected image", we can use the following command:

    ```
    bash ../../scripts/yw_prospective_lineage.sh \
    corrected_image \
    > graph/yw_prospective_lineage.gv
    dot -Tpng graph/yw_prospective_lineage.gv -o graph/yw_prospective_lineage.png
    dot -Tpdf graph/yw_prospective_lineage.gv -o graph/yw_prospective_lineage.pdf
    ```
<p align="center"><img src="https://github.com/idaks/yw-noworkflow/blob/master/examples/simulate_data_collection/graph/yw_prospective_lineage.png" height="500"></p>




