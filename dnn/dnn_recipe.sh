#Train
pdnndir=/home/bingo4508/pdnn
result=/home/bingo4508/Desktop/MLDS/model/mfcc_429
train=/home/bingo4508/Desktop/MLDS/mfcc/train_5window_merge.ark
valid=/home/bingo4508/Desktop/MLDS/mfcc/valid_5window_merge.ark
test=/home/bingo4508/Desktop/MLDS/mfcc/test_5window_merge.ark

export PYTHONPATH=$PYTHONPATH:$pdnndir
export THEANO_FLAGS='mode=FAST_RUN,device=cpu,floatX=float32,openmp=true'

mkdir $result
python $pdnndir/cmds/run_DNN.py --train-data "$train,random=true" \
                                --valid-data "$valid" \
                                --nnet-spec "429:1024:1024:48" --wdir ./ \
                                --l2-reg 0.0001 --lrate "D:0.08:0.5:0.01,0.005:8" --model-save-step 1 \
				--batch-size 256 \
                                --param-output-file $result/dnn.param --cfg-output-file $result/dnn.cfg\
                                --kaldi-output-file $result/kaldi.model --activation 3;


#Test
python $pdnndir/cmds/run_Extract_Feats.py --data "$test" \
				--nnet-param $result/dnn.param --nnet-cfg $result/dnn.cfg \
				--output-file "dnn.classify.pickle.gz" --layer-index -1 \
				--batch-size 100

python show_results.py "dnn.classify.pickle.gz" $test
