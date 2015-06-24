import numpy
import sys
import os
import cPickle, gzip
from pdnn.io_func import ark_io

pred_file = sys.argv[1]
test_file = sys.argv[2]

if '.gz' in pred_file:
    pred_mat = cPickle.load(gzip.open(pred_file, 'rb'))
else:
    pred_mat = cPickle.load(open(pred_file, 'rb'))

# load the testing set to get the labels
test_data, test_labels = ark_io.load(open(test_file, 'r'))

for i in xrange(pred_mat.shape[0]):
    p = pred_mat[i, :]
    p_sorted = (-p).argsort()
    print p_sorted[0]
