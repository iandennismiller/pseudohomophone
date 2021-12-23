# pmsp-lens
# Ian Dennis Miller
# 2020-11-07

set dt 100

set random_seed $::env(PMSP_RANDOM_SEED)
puts "Random seed: $random_seed"
seed $random_seed

set dilution_amount $::env(PMSP_DILUTION)
puts "Dilution amount: $dilution_amount"

set partition_id $::env(PMSP_PARTITION)
puts "Partition ID: $partition_id"

# unique name of this script, for naming saved weights
set script_name "pmsp-activations"

# root of project is relative to this .tcl file
set root_path "../"

set example_file "${root_path}/usr/pmsp-train-the-normalized.ex"

set results_path "${root_path}/var/results-${script_name}"
file mkdir $results_path

global log_outputs_filename
set log_outputs_filename [open "${results_path}/activations-output.txt" w ]

global log_hidden_filename
set log_hidden_filename [open "${results_path}/activations-hidden.txt" w ]

source ./activations.tcl
source ./recurrent-network.tcl

train -a "deltaBarDelta" -setOnly
setObj learningRate 0.05
setObj momentum 0.98

# p. 28 "the slight tendency for weights to decay towards zero was removed, to prevent the very small weight changes induced by low-frequency words - due to their very small scaling factors - from being overcome by the tendency of weights to shrink towards zero."
setObj weightDecay 0.00000

# "output units are trained to targets of 0.1 and 0.9"
setObj targetRadius 0.1

loadExamples $example_file -s "vocab"
exampleSetMode vocab PERMUTED
useTrainingSet vocab

setObj vocab.minTime 2.0
setObj vocab.maxTime 2.0
setObj vocab.graceTime 1.0

# install hook to log activations
setObj postTickProc { log_activations_hook }

# Need to view units to be able to access the history arrays.
viewUnits -updates 3

# load a network that has been already trained
resetNet
loadWeights "${root_path}/usr/1999-pmsp.wt.gz"

# `test` doesn't provide access to hidden units via postExampleProc
# use train instead
train 1

write_and_close_logs $log_outputs_filename $log_hidden_filename

exit
