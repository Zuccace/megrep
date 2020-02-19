#!/usr/bin/gawk --exec

function errexit(msg) {
        print msg > "/dev/stderr"
        exit 2
}

function checkfile(f) {
	return !system("test -r " f)
}

BEGIN {

	# Go trough cli switches...
	for (i = 1; i < ARGC; i++) {
		arg=ARGV[i]

		if ( substr(arg,1,1) != "-" ) break # ... but break the loop as soon as an argument does not start with a dash (-).
		else if (arg == "--") {
			i++
			break
		} else if (arg == "--file" || arg == "-f") {
			i++
			file=ARGV[i]
			if (checkfile(file)) files[j++]=file
			else errexit("Unable to read '" file "'.")
			if (length(ARGV[i+1]) == 0) errexit("Not enough arguments.")
		} else if (arg ~ /--help|-h|-\?/) {
			print "USAGE:"
			print "       megrep <regex1> [regexN] <file>"
			print "       -OR-"
			print "       megrep <--file|-f> <file1> [<--file|-f> <fileN>] [--] <regex1> [regexN]"
			print "-- forces megrep to ignore further switches."
			exit 0
		} else errexit("Unknown switch: " arg)
	}

	if (length(files[0]) == 0) {
		if (ARGC < 3) errexit("Not enough arguments. See --help.")
		file=ARGV[ARGC-1]
		if (!checkfile(file)) errexit("Unable to read '" file "'.")
		files[0] = file
		for (i = 1; i < ARGC-1; i++) regex[r++] = ARGV[i] # Create regex array from the arguments, minus the last one which is the file.
	} else {
		for (i = i; i < ARGC; i++) regex[r++] = ARGV[i] # Same but user has specified file(s) by use of --file/-f.
	}

	for (i in regex) for (k in files) { # Go trough all the regexes and files
		while ((getline < files[k]) > 0) { # ... line-by-line
			if ($0 ~ regex[i]) {
				# Optionally print the matching line like grep.
				#print $0
				close(files[k])
				found=1
				break
			}
		}

		if (found < 1) exit 1
		found=0
	}
	exit 0
}
