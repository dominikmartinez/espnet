# README for Master's Thesis by Dominik Martínez
**Title:** Coarse Labels Improve the Efficiency of CTC-assisted NMT. A Trade-off Between Translation Quality and Decoding Speed

**Submission date:** 31/05/24

The fork of this codebase shall give insight into the experiments conducted for the thesis.

## Some key points
* All experiments have been conducted using the `run_baseline.sh` and `run_ctc.sh` scripts with the respective config files in `conf/colactc/` and the hyperparameter values indicated in the thesis.
* To run the different experiments, the following values might need to be adjusted in the `run*.sh` scripts:
    * an `mt_tag`, which indicates the directory where the training and decoding files are saved
    * the `src_lang`, set it either to `de` or `es`
    * set `test_set` to `test` if you don't need to decode the validation set
    * for run_ctc.sh, set the intended config file

**Important**: To run a specific implementation of the decoding step, (un)comment the respective lines in `batch_beam_search.py`, according to the comments in the script in [this commit](https://github.com/dominikmartinez/espnet/commit/b79c5a61afdbb5cdfa1138041327dcbfca7e4b35).

## How we retrieved the results reported in the thesis
Training times:
```
tail -n 1 exp/mt_{model_tag}/train.log
```

Decoding times:
```
tail -n 1 exp/mt_{model_tag}/{decoding_run}/test/logdir/mt_inference.1.log
```

BLEU scores:
```
grep -A 1 "BLEU" exp/mt_{model_tag}/{decoding_run}/exp/test/score_bleu/result.tc.txt
```

Hypothesis and reference lengths:
```
wc exp/mt_{model_tag}/{decoding_run}/test/score_bleu/{hyp|ref}.trn
```

Hypothesis expansion proxy:
first state the experiments you're interested in in the script, then call
```
bash sum_max_hyp_len.sh
```

Information about the number of trainable parameters per model or the number of epochs trained can be found in the training log files `train.log`.

## Note on reproducibility
* Some code seems to be incompatible with newly installed packages. If an error indicates incompatibility, rolling back the respective package to an earlier version will resolve the issue. It's a good idea to look up what version was the most current on 17/08/22, the date of [this commit](https://github.com/siddalmia/espnet/commit/3f10d182e4a80345d4bd07435bab7d369e32a838).
* Specifically, I have encountered the following packages to be backwards-incompatible, and rolled them back to the version indicated:
  * typeguard==2.13.3
  * Pillow==9.5.0



Feel free to reach out for any inquiries regarding the thesis or the code!