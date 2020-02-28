#!/usr/bin/env python3

import sys
import re

def read_fragment(f):
    id = f.readline()
    if id == '':
        return None
    seq = f.readline()
    f.readline()
    quality = f.readline()

    return (id, seq, quality)

def write_fragment(f, id, seq, quality):
    f.write(id)
    f.write(seq)
    f.write("+\n")
    f.write(quality)

def run(pattern, in1, in2, out1, out2):
    while True:
        frag1 = read_fragment(in1)
        frag2 = read_fragment(in2)

        if frag1 is None:
            return

        (id1, seq1, q1) = frag1
        (id2, seq2, q2) = frag2

        if not (pattern.match(seq1) or pattern.match(seq2)):
            write_fragment(out1, id1, seq1, q1)
            write_fragment(out2, id2, seq2, q2)

def main():
    if len(sys.argv) != 6:
        print("USAGE: %s PATTERN IN1 IN2 OUT1 OUT2" % sys.argv[0])
        sys.exit(1)

    pattern = re.compile(sys.argv[1])

    with open(sys.argv[2]) as in1:
        with open(sys.argv[3]) as in2:
            with open(sys.argv[4], 'w') as out1:
                with open(sys.argv[5], 'w') as out2:
                    run(pattern, in1, in2, out1, out2)

if __name__ == '__main__':
    main()

# filter-fastqs.py 'CCATTGA' C0_1.fastq C0_2.fastq out/C0_1.fastq out/C0_2.fastq
