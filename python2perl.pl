#!/usr/bin/perl
# Starting point for COMP2041/9041 assignment 
# http://www.cse.unsw.edu.au/~cs2041/assignments/python2perl
# written by andrewt@cse.unsw.edu.au September 2014
# Modified by Dong Hoon Seo on September 2014.

while ($line = <>) {
	if ($line =~ /^#!/ && $. == 1) {
	
		# translate #! line 
		
		print "#!/usr/bin/perl -w\n";
	} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {
	
		# Blank & comment lines can be passed unchanged
		
		print $line;
	} elsif ($line =~ /^\s*print\s*(.*)\s*$/) {
	
		# Python's print print a new-line character by default
		# so we need to add it explicitly to the Perl print statement
		print "print \"\$$1\\n";
		print "\";\n";
		# $line =~ /^\s*print\s*"(.*)"\s*$/

	} elsif ($line =~ m/^\s*[A-Z]+\s*=/gi) {
		# Variables added in; Python has no $ where as Perl does. 
		chomp $line;
		$variable = $line;
		$variable =~ s/\s+//g;
		$variable =~ s/[0-9]+//g;
		$variable =~ s/=//g;
		#print "$variable\n";
		$variable = '$'.$variable;
		$number = $line;
		$number =~ s/[^0-9]+//g;
		print "$variable = $number;\n";
	
	} else {
	
		# Lines we can't translate are turned into comments
		
		print "#$line\n";
	}
}
