import sys

try:
	map_input = sys.argv[1]
	input = sys.argv[2]
	output = sys.argv[3]
except:
	print("param: $(map input file) $(input file) $(output file)")
	sys.exit()

m = {}

with open(map_input, 'r') as f:
	for l in f:
		l = l.strip().split('\t')
		m[l[0].lower()] = l[1]

with open(input, 'r') as fi:
	with open(output, 'w') as fo:
		fo.write("id,sequence\n")
		for i,l in enumerate(fi):
			fo.write('%d,' % i)
			tmp = []
			for e in l:
				try:
					e = e.lower()
					tmp.append(m[e])
				except:
					pass
			fo.write(''.join(tmp)+'\n')
