
RULES_DIR = ../../rules
GRAPH_RULES_DIR = ../../graphs

YW_EXTRACT_FACTS = facts/yw_extract_facts.P
YW_MODEL_FACTS = facts/yw_model_facts.P
YW_VIEWS = yw_views.P
YW_FACTS = ${YW_EXTRACT_FACTS} ${YW_MODEL_FACTS} ${YW_VIEWS}
YW_MODEL_OPTIONS = -c extract.language=python \
                   -c extract.factsfile=${YW_EXTRACT_FACTS} \
                   -c model.factsfile=${YW_MODEL_FACTS} \
                   -c query.engine=xsb
YW_GRAPH_OPTIONS = -c extract.language=python

RUN_SCRIPT = run.sh
RUN_STDOUT = run_outputs.txt
RUN_OUTPUTS = ${RUN_STDOUT}
YW_NW_VIEWS = yw_nw_views.P

NW_EXPORTED_FACTS = facts/nw_facts.P
NW_VIEWS = nw_views.P
NW_FACTS = ${NW_EXPORTED_FACTS} ${NW_VIEWS}


RULES = ${RULES_DIR}/nw_views.P ${RULES_DIR}/yw_views.P ${RULES_DIR}/yw_nw_views.P
QUERY_SCRIPT = query.sh
QUERY_OUTPUTS = query_outputs.txt

WORKFLOW_GRAPH = workflow_graph
YW_DATA_GRAPH = yw_data_graph
YW_PROCESS_GRAPH = yw_process_graph
YW_GRAPHS = ${WORKFLOW_GRAPH}.gv ${YW_DATA_GRAPH}.gv ${YW_PROCESS_GRAPH}.gv
GRAPHS = ${YW_GRAPHS}

PNGS = ${WORKFLOW_GRAPH}.png ${YW_DATA_GRAPH}.png ${YW_PROCESS_GRAPH}.png
PDFS = ${WORKFLOW_GRAPH}.pdf ${YW_DATA_GRAPH}.pdf ${YW_PROCESS_GRAPH}.pdf

YW_PROPERTIES = yw.properties

all: ${YW_FACTS} ${RUN_OUTPUTS} ${NW_FACTS} ${YW_NW_VIEWS} ${QUERY_OUTPUTS} ${GRAPHS}

yw: ${YW_FACTS} ${YW_GRAPHS}
run: ${RUN_OUTPUTS}
nw: ${NW_FACTS}
ywnw: ${YW_NW_VIEWS}
query: ${QUERY_OUTPUTS}
graph: ${YW_GRAPHS}
png: ${PNGS}
pdf: ${PDFS}

.SUFFIXES:
.SUFFIXES: .gv .pdf .png

.gv.pdf:
	dot -Tpdf $*.gv -o $*.pdf

.gv.png:
	dot -Tpng $*.gv -o $*.png

${YW_FACTS}: ${WORKFLOW_SCRIPT} ${YW_PROPERTIES}
	mkdir -p facts
	bash -lc "yw model ${WORKFLOW_SCRIPT} ${YW_MODEL_OPTIONS}"
	${RULES_DIR}/materialize_yw_views.sh > ${YW_VIEWS}

${YW_GRAPHS}: ${YW_VIEWS}
	bash -lc "yw graph ${WORKFLOW_SCRIPT} ${YW_GRAPH_OPTIONS} > ${WORKFLOW_GRAPH}.gv"
	bash -l ../../graphs/${YW_DATA_GRAPH}.sh > ${YW_DATA_GRAPH}.gv
	bash -l ../../graphs/${YW_PROCESS_GRAPH}.sh > ${YW_PROCESS_GRAPH}.gv

${RUN_OUTPUTS}: ${RUN_SCRIPT} ${WORKFLOW_SCRIPT}
	bash -l ${RUN_SCRIPT} > ${RUN_STDOUT}

${NW_FACTS}: ${RUN_OUTPUTS}
	mkdir -p facts
	now export -t -m dependency | grep -v 'environment(' > ${NW_EXPORTED_FACTS}
	${RULES_DIR}/materialize_nw_views.sh > ${NW_VIEWS}

${YW_NW_VIEWS}: ${YW_VIEWS} ${NW_VIEWS}
	${RULES_DIR}/materialize_yw_nw_views.sh > ${YW_NW_VIEWS}

${QUERY_OUTPUTS}: ${QUERY_SCRIPT} ${YW_NW_VIEWS} ${RULES}
	bash -l ${QUERY_SCRIPT} > ${QUERY_OUTPUTS}

clean:
	rm -rf facts .noworkflow *.xwam *.gv *.png *.pdf *.P *.txt ${RULES_DIR}/*.xwam
