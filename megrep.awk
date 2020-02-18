#!/usr/bin/gawk --exec

BEGIN {

	if (ARGC < 3) exit 2

	file=ARGV[ARGC-1]

	for (i = 1; i < ARGC-1; i++) {

		while ((getline < file) > 0) {
			if ($0 ~ ARGV[i]) {
				# Optionally print the matching line like grep.
				#print $0
				close(file)
				f=1
				break
			}
		}
		
		if (f != 1) exit 1
		f=0
	}
	exit 0
}
