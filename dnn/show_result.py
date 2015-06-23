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
test_labels = test_labels.astype(numpy.int32)

correct_number = 0.0
for i in xrange(pred_mat.shape[0]):
    p = pred_mat[i, :]
    p_sorted = (-p).argsort()
    if p_sorted[0] == test_labels[i]:
        correct_number += 1

# output the final error rate
error_rate = 100 * (1.0 - correct_number / pred_mat.shape[0])
print 'Error rate is ' + str(error_rate) + ' (%)'


