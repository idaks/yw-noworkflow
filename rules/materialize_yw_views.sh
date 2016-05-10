#!/usr/bin/env bash -l
#
# ./run_queries.sh &> run_queries.txt

xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN

[yw_extract_facts].
[yw_model_facts].
['../../rules/general_rules'].
['../../rules/yw_view_rules'].

set_prolog_flag(unknown, fail).

rule_banner('yw_source_file(SourceId, SourceFile).').
printall(yw_source_file(_,_)).

rule_banner('yw_workflow_script(WorkflowId, WorkflowName, SourceId, SourceFile).').
printall(yw_workflow_script(_,_,_,_)).

rule_banner('yw_workflow(WorkflowId, WorkflowName, ParentWorkflowId, SourceId, BeginLine, EndLine).').
printall(yw_workflow(_,_,_,_,_,_)).

rule_banner('yw_workflow_step(StepId, StepName, WorkflowId, SourceId, BeginLine, EndLine).').
printall(yw_workflow_step(_,_,_,_,_,_)).

rule_banner('yw_function(FunctionId, FunctionName, ParentWorkflowId, SourceId, BeginLine, EndLine).').
printall(yw_function(_,_,_,_,_,_)).

rule_banner('yw_in_port(ProgramId, ProgramName, PortId, PortName, DataId, DataName).').
printall(yw_in_port(_,_,_,_,_,_)).

rule_banner('yw_out_port(ProgramId, ProgramName, PortId, PortName, DataId, DataName).').
printall(yw_out_port(_,_,_,_,_,_)).

rule_banner('yw_inflow(WorkflowId, WorkflowName, DataId, DataName, ProgramId, ProgramName).').
printall(yw_inflow(_,_,_,_,_,_)).

rule_banner('yw_flow(SourceProgramId, SourceProgramName, SourcePortId, SourcePortName, DataId, DataName, SinkPortId, SinkPortName, SinkProgramId, SinkProgramName).').
printall(yw_flow(_,_,_,_,_,_,_,_,_,_)).

rule_banner('yw_outflow(ProgramId, ProgramName, ProgramDataId, DataName, WorkflowId, WorkflowName).').
printall(yw_outflow(_,_,_,_,_,_)).

rule_banner('yw_qualified_name(EntityType, Id, QualifiedName).').
printall(yw_qualified_name(_,_,_)).

rule_banner('yw_description(EntityType, Id, Name, Description)).').
printall(yw_description(_,_,_,_)).

END_XSB_STDIN
