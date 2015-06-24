import numpy
import sys
import os
import cPickle, gzip
from pdnn.io_func import ark_io

pred_file = sys.argv[1]
output = sys.argv[2]


if '.gz' in pred_file:
    pred_mat = cPickle.load(gzip.open(pred_file, 'rb'))
else:
    pred_mat = cPickle.load(open(pred_file, 'rb'))

with open(output, 'w') as f:
    for e in pred_mat:
        for m in e:
	    f.write("%f ", m)
	f.write('\n')
