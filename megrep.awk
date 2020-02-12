#!/usr/bin/gawk --exec

function errexit(msg) {
        print msg > "/dev/stderr"
        exit 2         
}                      

BEGIN {
	if (ARGV[2] == "") errexit("USAGE: megrep[.awk] <regex> [regex2] ... [regexN] <file>")
	file=ARGV[ARGC-1]
	if (system("test -r " file) != 0) errexit("Cannot read file '" file "'")

	# Create new array, re, which contains all the regexes.
	for (i = 1; i < ARGC-1; i++) re[i] = ARGV[i]

	# Start reading file
	while ((getline < file) > 0) {
		for (j in re) {
			if ($0 ~ re[j]) {
				# We have a match. Now remove the regex from the array.
				# This speeds up the processing.
				delete re[j]

				# After each deletion, check if we still have unmatched regexes.
				# If not - exit succesfully.
				if (length(re) == 0) exit 0
			}
		}
	}
	
	# Not all/any the regexes matched.
	exit 1
}
