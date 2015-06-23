import sys


def previous_subsequent(data, new_data, window_size):
    person = []
    with open(new_data, 'w') as fo:
        with open(data, 'r') as f:
            l = f.readline().strip().split()
            p = l[0].split('_')
            prev_person = p[0]+p[1]
            person.append(l)
            while True:
                l = f.readline()
                if not l:
                    p = [' ',' ']
                else:
                    l = l.strip().split()
                    p = l[0].split('_')

                if p[0]+p[1] == prev_person:
                    person.append(l)
                else:
                    prev_person = p[0]+p[1]
                    person_len = len(person)
                    feature_len = len(person[0][1:])
                    for i in range(0,person_len):
                        feature = []
                        for j in range(i-window_size,i+window_size+1):
                            if j >= 0 and j < person_len:
                                feature.append(person[j][1:])
                            else:
                                feature.append([0]*feature_len)
                        feature = [str(e) for sublist in feature for e in sublist]
                        fo.write('%s %s\n' % (person[i][0],' '.join(feature)))
                    person = [l]
                if not l:
                    break


if __name__ == '__main__':
    data = sys.argv[1]
    new_data = sys.argv[2]
    window_size = int(sys.argv[3])

    previous_subsequent(data, new_data, window_size)
