#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

src_lang=de
tgt_lang=en

train_set=train
train_dev=valid
test_set="test valid"

mt_config=conf/colactc/baseline.yaml
inference_config=conf/colactc/baseline_decode.yaml

src_nbpe=1000
tgt_nbpe=10000   # if token_joint is True, then only tgt_nbpe is used

# tc: truecase
# lc: lowercase
# lc.rm: lowercase with punctuation removal
# Note, it is best to keep tgt_case as tc to match IWSLT22 eval
src_case=tc
tgt_case=tc

data=dump/raw

./mt.sh \
    --ignore_init_mismatch true \
    --use_lm false \
    --token_joint true \
    --ngpu 1 \
    --nj 16 \
    --inference_nj 32 \
    --src_lang ${src_lang} \
    --tgt_lang ${tgt_lang} \
    --src_token_type "bpe" \
    --src_nbpe $src_nbpe \
    --tgt_token_type "bpe" \
    --tgt_nbpe $tgt_nbpe \
    --src_case ${src_case} \
    --tgt_case ${tgt_case} \
    --feats_type raw \
    --mt_config "${mt_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --src_bpe_train_text "$data/${train_set}/text.de_en.${src_case}.${src_lang}" \
    --tgt_bpe_train_text "$data/${train_set}/text.de_en.${tgt_case}.${tgt_lang}" \
    --lm_train_text "$data/${train_set}/text.de_en.${tgt_case}.${tgt_lang}" "$@" \
    --gpu_inference true \
    --local_data_opts "$src_lang $tgt_lang"
