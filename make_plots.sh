#!/bin/bash
viz_file=examples/viz_model.lp

for ex in $(ls examples)
do
    if [ -d examples/$ex ] && [ -e examples/$ex/model.lp ]
    then
        outdir=examples/$ex
        model=$outdir/model.lp
        echo "Running for ${ex} example..."
        clingraph $model --viz-encoding $viz_file --out=render --type=digraph --dir=$outdir --name-format=model --format=png
    fi
    if [ -d examples/$ex ] && [ -e examples/$ex/fmodel.lp ]
    then
        outdir=examples/$ex
        model=$outdir/fmodel.lp
        echo "Running for ${ex} example..."
        clingraph $model --viz-encoding $viz_file --out=render --type=digraph --dir=$outdir --name-format=fmodel --format=png
    fi
done
#
