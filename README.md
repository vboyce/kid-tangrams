# kid-tangrams


# Repo organization

* Experiments contains the code to host/run the tablet experiments as well as the guidance we have to experimenters on how to run the expts
* Data contains transcripts and performance data for children; transcripts have kids names removed and replaced with their id number 
* Code contains analytic code for data processing and analyses (and saved model results)
* Write-ups contains presentations and manuscripts
* The public data from Leung et al. (2024) used in some preliminary analyses (code/expt_1/leung_comparison.Rmd reads it from a leung_data folder) is not included in this repo. The comparison with Leung et al. and other datasets in the manuscript gets its data from Refbank (v13.4) through refbankr, inside write-ups/manuscript/kid-tangrams-ms.Rmd.

# Pipeline needed for manuscript 
* write-up renders using write-ups/manuscript/ -- this relies on saved versions of processed data and saved model summaries. 

To re-create from raw data
* use code/expt_1/data_prep.Rmd, code/expt_2/data_prep_2.Rmd, and code/expt_3/data_prep_3.Rmd. You will need to run code/run_sbert.py in the middle to generate the sentence embeddings; run it from code/ with a Python environment that has sentence-transformers (e.g. a .venv in the repo root), and point reticulate at that Python for the chunk that reads post_sbert.npy.
* run code/demog.qmd
* For the combined data used in the paper and for the statistical models, run code/ms_analysis.Rmd -- note that some models may take a while to run. 
* Run writeups/manuscript/kid-tangrams-ms.Rmd


# Pipeline needed for cogsci 2025 paper
* write-up renders using write-ups/kid_tangrams_cogsci_2025/ and depending on code/paper_helper.R
* data comes from processed data in the data folder, model intermediates are cached

To re-create from raw data, use the data_prep.Rmd files in code/expt1 and code/expt2. You will need to use code/expt_1/sbert_play.ipynb in the middle to generate pairwise similarities. For the statistical models, run code/mods_for_cogsci_paper.R -- note that this may take a while to run some models. 

Pre-processing for datasets was re-standardized again later, so use a commit from May 2025ish. 



## how transcripts were tagged

For the game (non-intro) parts of games that are included (not pilots, not excluded), checked transcripts against videos and filled in as needed (time stamps on fill are approximate and copied from adjacent lines). 

For these, tagging
* role = L or S for child (listener / speaker)
* trial # -- when a trial starts (roughly, it's in the fill between descriptions)
* echo: is this an RA echoing (note: echoing was very common in expt 1 and so is not consistently marked; echoing was consistently marked in expt 2 and was an exclusion criteria on a trial-by-trial level)
* description: what is the target tangram being called? (note: if the exact same thing is said or restarted, only a clean part of the "noun")
* backchannel: Y for all game-relevant kid speech (which isn't necessarily backchannel) (coded only in expt 1)

