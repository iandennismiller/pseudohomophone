# Pseudohomophones

## Installation and Usage

```{bash}
git clone https://github.com/iandennismiller/pseudohomophone.git
cd pseudohomophone
mkvirtualenv -a . -p $(which python3) pseudohomophone # venv is optional
make requirements
make run
```

## McCann and Besner, 1987

- DOI:10.1037/0096-1523.13.1.14
- https://www.proquest.com/docview/614337696

Pronunciation performance under speeded conditions was examined for various kinds of letter strings, including pseudohomophones (e.g., TRAX), their real word counterparts (e.g., TRACKS), and a set of nonword controls (e.g., PRAX). Experiment 1 yielded a pronunciation advantage for the pseudohomophones relative to the controls, which was largest among items having few or no orthographic neighbors. Experiment 2 ruled out an account of the pseudohomophone advantage based on differences between pseudohomophones and controls in initial phonemes. Experiment 3 established the existence of a large frequency effect on pronunciation of the base words themselves. These results suggest that whole word representations in the phonological output lexicon are consulted in the course of assembling a pronunciation and that representations in a phonological output lexicon are insensitive to word frequency.

## (BA's Notes)

### Step 1: Generate representations for all items in the PMSP format

This should be easy, since it really just involves orthography for the two types of nonwords and copying the phonology for the actual words, if that is desired.  I guess technically there is a Step 1b where you run AS's patterns through the trained PMSP but I am assuming that just giving a new set of examples and recording outputs for those examples is a trivial task at this point.  I will assume this happens through PMSP simulation 3 run on 100 ticks and that conceivably you just put these nonwords into your existing example set that has "all" the stimuli, the base vocab, the anchors, the probes, etc. in it.  Thus, for a single point in time this would yield roughly 3200 examples run for 100 ticks each for which activity in about 300 units is recorded (input, hidden, output, but for now I will just focus on outputs).  We could run this crossed with epoch number, and we might want to do that in the future, but that also seems straightforward given the analyses you have already run.  

### Step 2: Analyze the results

This is where things get slightly trickier.  I'll break this point down into the two sub-analyses we care about, which concern speed and accuracy.  

#### Step 2a: Speed

There are a couple of ways to figure out when a neural network responds.  One way, which I believe you were going to implement in the near future if not already done, was to just repeat the PMSP method, which involves looking at when the output units are not changing activity levels above some threshold across successive ticks.  I think this is actually fairly easy to quantify because it just involves subtracting the output vector from tick n from that from tick n-1, taking the absolute value, averaging this number, and ensuring it falls below the threshold (0.00005  in the paper).  The resulting tick number (which range from 0-200) is the RT.  

A second way to quantify responding is when activity in the output layer reaches some threshold.  The easiest way to try to do this is just look at the average activity in the output layer over the 200 ticks. We would then set some threshold value (tbd) which corresponds to responding.  I think we could figure out the threshold to a reasonable extent by figuring out the average activity in the outputs when the model is first able to respond accurately (see 2b) for all, or almost all, of the training examples.  This effectively corresponds to the threshold when enough activity is produced to fire off a response.  I am a little skeptical that this will work given some of my other experience working with such a measure with Dave, however.  Basically, the issue could be that the network either has a quick burst of a lot of activity early on which means you can only use this threshold after some minimum number of  ticks have elapsed, or the overall activity stays fairly similar across all ticks and it is the distribution of activity that changes.  Dave also did not like settling time by the time I was his student, but it still needs to be done I think just for comparability to the original results.  

Thus, before trying to pick a threshold, the best thing AS might want to try is just producing a plot showing the average activity in the output units for all of the words and for all of the control nonwords as separate lines, and depicting how this activity changes over ticks 0-200.  This will tell us if the thresholding method could work  in principle: There would need to be an increasing level of activity, perhaps after an initial blip, such that you can't respond until a minimum k ticks has passed.  The nonword trajectory would also need to average below the word trajectory (to reflect faster RTs for words), and there would need to be sufficient proximity of the word and nonword trajectories such that you could use one threshold to respond to both stimuli and have variability in RTs for each type of stimulus.

If my hunch that the above might not work turns out to be true, the relatively easy solution to make things work is to use a nonlinear transform of the activity levels.  Something like stress/polarity, which is built into LENS and can be computed easily with a fomula if doing it outside of LENS.  Or, just a nonlinear function that rewards higher activity more than low level activity.  The idea is that settling into words at least involves strongly activating a few units and not activating most others at all, so we just need to be sensitive to that with the math.  Stress rewards activities closer to 0 and 1 relative to intermediate activity, but since the network outputs are sparse this can muddy the waters because most output units should be off and so get high stress values that could conceal higher values.  Just taking half of the stress equation will only compute a benefit for strong activity, and I am guessing that will work from my own prior modeling work.  

Basically then, AS could compute two or three simple measures of RT, perhaps with some parametric variation of the threshold to see how that impacts performance.  

#### Step 2b: accuracy

I suppose to assess accuracy the first thing we need to do is just check what the network actually produced as an output.  Am I correct in that right now you are only examining how the model is performing for the vowel in your out-of-LENS tests, and not checking the rest of the word?  If yes, then I think AS could expand this to look at  the entire word's pronunciation.  The rules for determining what the model actually produced as an output are clearly spelled out in the PMSP paper, and basically involve reversing the process used to generate the phonology to interpret the phonology and see what the word output.  In PMSP, they basically take the ordered concatenation of all the non-mutually-exclusive phonemes with activities above 0.5, with a couple of minor caveats (e.g., you always must pronounce a vowel regardless of whether the most active vowel has activity > 0.5).  Most of this task is therefore straightforward, A just needs to pay close attention to the few caveats to the general rule.  Since we know what the caveats are, they should be easy for us to manually check a couple of relevant examples as well.  

If AS programs a function to "read aloud" whatever the model is producing at a given time step, he could then in principle produce hypothetical accuracy of responses for every tick in the 0-200 range for the words, in addition to hypothetical accuracy outputs for every tick for all items.  This relates closely to an analysis you have already done (I think you were checking that all units were on the right side of 0.5 or similar?) so we have some basis for evaluating the correctness of his outputs.  

With all of this complexity in hand, we could thus answer two simple questions: 

1. if we look at tick 200, are the base words and the pseudohomophones pronounced the same way?  
2. If we look at the tick where the model was deemed to have responded per the "speed" measure above, are the words and the pseudohomophones produced "correctly"?  (i.e., are the words correct per training, and are the pseudohomophones pronounced the same way as their base words?)  How do their RTs fare compared to the control nonwords?

### Conclusion

If we know the answers to those questions and they are reasonable, we could then have him repeat a very similar analysis to what BL has done, perhaps even recycling some of BL's code, to see how the average similarity of the base words are to one another, of the pseudohomophones to one another, and of the control words to one another in each layer and in the correlations across layers (like Plaut's figure 18 that BL has worked with).  Having held phonological similarity constant and only varying orthographic similarity, we should then be able to better understand how information is being warped across each level of representation.  Ideally we would do the reverse (i.e., hold orthographic similarity constant and vary phonological similarity) but we can't do that in PMSP, so we must settle with what we have.
