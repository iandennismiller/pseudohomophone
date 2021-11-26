# pmsp-lens
# Ian Dennis Miller
# 2020-11-07

global log_hidden
set log_hidden ""
global log_outputs
set log_outputs ""

proc log_activations_hook {} {
    log_hidden_activations_hook
    log_output_activations_hook
}

proc log_hidden_activations_hook {} {

    # global log_hidden_filename
    global log_hidden

    # list of group outputs to log
    set groups_to_log {hidden}
    set properties_to_log {output}

    # write activations every 50 epochs
    # if { [getObj totalUpdates] % 50 == 0} {
        foreach t $properties_to_log {
            # puts -nonewline $log_hidden_filename "[getObj totalUpdates]|"
            append log_hidden [getObj totalUpdates] "|"

            # puts -nonewline $log_hidden_filename "[getObj net(0).currentExample.name]|$t "
            append log_hidden [getObj net(0).currentExample.name] "|$t "

            foreach g $groups_to_log {
                #puts "group count"
                #puts [getObj $g.numUnits]
                for {set u 0} {$u < [getObj $g.numUnits]} {incr u} {
                    # puts -nonewline $log_hidden_filename "[getObj $g.unit($u).$t] "
                    append log_hidden [getObj $g.unit($u).$t] " "
                }
            }

            # puts $log_hidden_filename ""
            append log_hidden "\n"
        }
    # }
}

proc log_output_activations_hook {} {

    # global log_outputs_filename
    global log_outputs

    # list of group outputs to log
    set groups_to_log {phono_onset phono_vowel phono_coda}
    # set groups_to_log {hidden}
    set properties_to_log {output target}
    # set properties_to_log {output}

    # write activations every 50 epochs
    # if { [getObj totalUpdates] % 50 == 0} {
        foreach t $properties_to_log {
            # puts -nonewline $log_outputs_filename "[getObj totalUpdates]|"
            append log_outputs [getObj totalUpdates] "|"

            # puts -nonewline $log_outputs_filename "[getObj net(0).currentExample.name]|$t "
            append log_outputs [getObj net(0).currentExample.name] "|$t "

            foreach g $groups_to_log {
                #puts "group count"
                #puts [getObj $g.numUnits]
                for {set u 0} {$u < [getObj $g.numUnits]} {incr u} {
                    # puts -nonewline $log_outputs_filename "[getObj $g.unit($u).$t] "
                    append log_outputs [getObj $g.unit($u).$t] " "
                }
            }

            # puts $log_outputs_filename ""
            append log_outputs "\n"
        }
    # }

}

proc write_and_close_logs {log_hidden_filename log_outputs_filename} {
    global log_hidden
    global log_outputs

    puts $log_hidden_filename $log_hidden
    puts $log_outputs_filename $log_outputs
}
