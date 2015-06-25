#
# 1. Run setup.py to set up pdnn first 
# 2. Cd into the home directory of the repository
# 3. Revise the directory and file name within the =========== symbol
# 4. Copy the script below the ========== symbol and run manually
#

pdnndir=$(pwd)/dnn/pdnn
export PYTHONPATH=$PYTHONPATH:$(pwd)/dnn/pdnn
export THEANO_FLAGS='mode=FAST_RUN,device=cpu,floatX=float32,openmp=true'



# Prepare merge ark data
############################################################################################################
train=MLDS-Final/mfcc/train.ark
valid=MLDS-Final/mfcc/valid.ark
test=MLDS-Final/mfcc/test_hw1.ark
window=10
train_xwindow=MLDS-Final/mfcc/train_$window\window.ark
valid_xwindow=MLDS-Final/mfcc/valid_$window\window.ark
train_xwindow=MLDS-Final/mfcc/test_$window\window_hw1.ark
train_label=MLDS-Final/label/train.label
valid_label=MLDS-Final/label/valid.label
############################################################################################################

python script/preprocess.py $train $train_xwindow $window
python script/preprocess.py $valid $valid_xwindow $window
python script/preprocess.py $test $test_xwindow $window
./dnn/prepare_big_data.sh $train_xwindow $train_label
./dnn/prepare_big_data.sh $valid_xwindow $valid_label
./dnn/prepare_big_data.sh $test_xwindow






# Pre-training
############################################################################################################
result=MLDS-Final/model/mfcc_429
train=MLDS-Final/mfcc/train_5window_merge.ark
############################################################################################################

python $pdnndir/cmds/run_RBM.py --train-data "$train,random=true" \
                                --nnet-spec "819:1024:1024:48" \
                                --wdir ./ --ptr-layer-number 2 \
                            	--epoch-number 10 --batch-size 256 \
                            	--learning-rate 0.08 --gbrbm-learning-rate 0.005 \
                            	--momentum 0.5:0.9:5 --first_layer_type gb \
                            	--param-output-file $result/rbm.mdl






# Train
#############################################################################################################
result=MLDS-Final/model/mfcc_429
train=MLDS-Final/mfcc/train_10window_merge.ark
valid=MLDS-Final/mfcc/valid_10window_merge.ark
#############################################################################################################

mkdir $result
python $pdnndir/cmds/run_DNN.py --train-data "$train,random=true" \
                                --valid-data "$valid" \
                                --nnet-spec "819:1024:1024:48" --wdir ./ \
                                --l2-reg 0.0001 --lrate "D:0.08:0.5:0.01,0.005:8" --model-save-step 1 \
				--batch-size 256 --ptr-file $result/rbm.mdl --input-dropout-factor 0.2\
				--dropout-factor 0.5,0.5 --activation 3 --param-output-file $result/dnn.param --cfg-output-file $result/dnn.cfg --kaldi-output-file $result/kaldi.model;






# Test
#############################################################################################################
result=MLDS-Final/model/mfcc_429
test=MLDS-Final/mfcc/test_10window_hw1_merge.ark
output=MLDS-Final/output
#############################################################################################################

python $pdnndir/cmds/run_Extract_Feats.py --data "$test" \
				--nnet-param $result/dnn.param --nnet-cfg $result/dnn.cfg \
				--output-file "dnn.classify.pickle.gz" --layer-index -1 \
				--batch-size 100

python dnn/predict.py "dnn.classify.pickle.gz" $test > $output/result
paste -d',' script/static_data/test_hw1.name $output/result > $output/raw_result
python script/map_phone_label.py $output/raw_result $output/final_result script/static_data/train_label.map script/static_data/48-39.map
rm -f $output/raw_result $output/result
rm -f dnn.classify.pickle.gz





# Extract feature vector for structured learning
#############################################################################################################
result=MLDS-Final/model/mfcc_429
train=MLDS-Final/mfcc/train_10window_merge.ark
test=MLDS-Final/mfcc/test_10window_hw1_merge.ark
output=MLDS-Final/output
extract_feature_layer=-2
#############################################################################################################

mkdir $output
python $pdnndir/cmds/run_Extract_Feats.py --data "$train" \
				--nnet-param $result/dnn.param --nnet-cfg $result/dnn.cfg \
				--output-file "$output/train_layer.pickle.gz" --layer-index $extract_feature_layer \
				--batch-size 100
python dnn/convert_feature.py "$output/train_layer.pickle.gz" "$output/train_layer.txt"
rm -f "$output/train_layer.pickle.gz"

python $pdnndir/cmds/run_Extract_Feats.py --data "$test" \
				--nnet-param $result/dnn.param --nnet-cfg $result/dnn.cfg \
				--output-file "$output/test_layer.pickle.gz" --layer-index $extract_feature_layer \
				--batch-size 100
python dnn/convert_feature.py "$output/test_layer.pickle.gz" "$output/test_layer.txt"

rm -f "$output/test_layer.pickle.gz"
