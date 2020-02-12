#!/usr/bin/gawk --exec

function errexit(msg) {
        print msg > "/dev/stderr"
        exit 2         
}                      

BEGIN {
	if (ARGV[2] == "") errexit("USAGE: mgrep[.awk] <regex> [regex2] ... [regexN] <file>")
	file=ARGV[ARGC-1]
	if (system("test -r " file) != 0) errexit("Cannot read file '" file "'")
	
	for (i = 1; i < ARGC-1; i++) re[i] = ARGV[i]

	while ((getline < file) > 0) {
		for (j in re) {
			if ($0 ~ re[j]) {
				delete re[j]
				if (length(re) == 0) exit 0
			}
		}
	}
	
	# Not all the regexes matched
	exit 1
}
