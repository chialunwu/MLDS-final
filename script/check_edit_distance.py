import sys

# Christopher P. Matthews
# christophermatthews1985@gmail.com
# Sacramento, CA, USA
 
def levenshtein(s, t):
        ''' From Wikipedia article; Iterative with two matrix rows. '''
        if s == t: return 0
        elif len(s) == 0: return len(t)
        elif len(t) == 0: return len(s)
        v0 = [None] * (len(t) + 1)
        v1 = [None] * (len(t) + 1)
        for i in range(len(v0)):
            v0[i] = i
        for i in range(len(s)):
            v1[0] = i + 1
            for j in range(len(t)):
                cost = 0 if s[i] == t[j] else 1
                v1[j + 1] = min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
            for j in range(len(v0)):
                v0[j] = v1[j]
 
        return v1[len(t)]

def load(fname):
    m = {}
    with open(fname, 'r') as f:
        f.readline()    #header line
        for l in f:
            l=l.strip().split(',')
            m[l[0]] = l[1]
    return m

if len(sys.argv) < 3:
    print("args: $answer $predict")
    sys.exit(1)

answer = sys.argv[1]
predict = sys.argv[2]

ans_map = load(answer)
pre_map = load(predict)


d_s = 0
for k, v in pre_map.items():
    d = levenshtein(ans_map[k], v)
    d_s += d
    print("%s\t%d" %(k, d))

print("\nAverage edit distance: %f" % (float(d_s)/len(ans_map)))
