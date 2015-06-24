import sys

# Load map
def load_map(fname):
    m = {}
    with open(fname, 'r') as f:
        for l in f:
            l = l.strip().split('\t')
            m[l[0]] = l[1]
    return m


raw_result = sys.argv[1]    # ',' delimited
final_result = sys.argv[2]
label_map = sys.argv[3]     # tab delimited, our map
label_map2 = sys.argv[4]    # tab delimited, 48-39.map


label_map = load_map(label_map)
label_map2 = load_map(label_map2)

with open(raw_result, 'r') as f:
    with open(final_result, 'w') as fo:
        fo.write('Id,Prediction\n')
        for l in f:
            l = l.strip().split(',')
            fo.write('%s,%s\n' % (l[0],label_map2[label_map[l[1]]]))
