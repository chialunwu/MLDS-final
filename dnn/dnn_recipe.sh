pdnndir=/home/bingo4508/Desktop/MLDS-final/dnn/pdnn
result=/home/bingo4508/Desktop/MLDS-final/MLDS-Final/model/mfcc_429
train=/home/bingo4508/Desktop/MLDS-final/MLDS-Final/mfcc/train_5window_merge.ark
valid=/home/bingo4508/Desktop/MLDS-final/MLDS-Final/mfcc/valid_5window_merge.ark

export PYTHONPATH=$PYTHONPATH:$pdnndir
export THEANO_FLAGS='mode=FAST_RUN,device=cpu,floatX=float32,openmp=true'


#Train
mkdir $result
python $pdnndir/cmds/run_DNN.py --train-data "$train,random=true" \
                                --valid-data "$valid" \
                                --nnet-spec "429:1024:1024:48" --wdir ./ \
                                --l2-reg 0.0001 --lrate "D:0.08:0.5:0.01,0.005:8" --model-save-step 1 \
				--batch-size 256 \
                                --param-output-file $result/dnn.param --cfg-output-file $result/dnn.cfg\
                                --kaldi-output-file $result/kaldi.model --dropout-factor 0.5,0.5 --activation 3;




#Test
test=/home/bingo4508/Desktop/MLDS-final/MLDS-Final/mfcc/test_5window_hw1_merge.ark
python $pdnndir/cmds/run_Extract_Feats.py --data "$test" \
				--nnet-param $result/dnn.param --nnet-cfg $result/dnn.cfg \
				--output-file "dnn.classify.pickle.gz" --layer-index -1 \
				--batch-size 100



python dnn/predict.py "dnn.classify.pickle.gz" $test > output/result
paste -d',' script/static_data/test_hw1.name output/result > output/raw_result
python script/map_phone_label.py output/raw_result output/final_result script/static_data/train_label.map script/static_data/48-39.map
rm -f output/raw_result output/result
rm -f dnn.classify.pickle.gz
