#!/usr/bin/perl
# Starting point for COMP2041/9041 assignment 
# http://www.cse.unsw.edu.au/~cs2041/assignments/python2perl
# written by andrewt@cse.unsw.edu.au September 2014
# Modified by Dong Hoon Seo on September 2014.

%variables = ();

sub makeVariable {
	my ($pyVar) = @_;
	$plVar = '$'.$pyVar;
	return $plVar;
}


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

	} elsif ($line =~ /^\s*[A-Z]+[0-9]*\s*=\s*[0-9]*\s*/gi) {
		# Variables added in; Python has no $ where as Perl does.
		# $strings = all the seperate words from the input line
		# $word = single word $wordpl = word in perl format
		# $perled = string has been changed to perl format;
 
		chomp $line;
		$perled = $line;
		@strings = split(/\s+/,$perled); 

		foreach $word (@strings) {	
			if($word =~ m/[A-Z]+/gi) {
				$wordPl = makeVariable($word);
				$perled =~ s/$word/$wordPl/g;
			} elsif ($word =~ m/\-[0-9]+/g) {
				$wordPl = $word;
				$wordPl =~ s/\-//g;
				$perled =~ s/$word/\- $wordPl/g;
			}
		}
	
		print "$perled;\n";
	
	} elsif ($line =~ m/\(*[A-Z]+[0-9]*\s*and|or|not\s*[A-Z]+[0-9]*\)*/gi) {

		# This section deals with logical operators
		# This section should trigger when a variable and a logical operator exist
		# on the same line.		

		chomp $line;
		$perled = $line;
		@strings = split(/\s+/,$perled);

		foreach $word (@strings) {
			if(($word =~ m/[A-Z]+[0-9]*/gi) && ($word !~ "and|or|not")) {
				$wordPl = makeVariable($word);
				if($perled !~ m/\$$word/g) {
					$perled =~ s/$word/$wordPl/g;
				}
			}
		}
		
		print "$perled;\n";

	} else {
	
		# Lines we can't translate are turned into comments
		
		print "#$line\n";
	}

}























