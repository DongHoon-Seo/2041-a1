#!/usr/bin/perl

# Python2Perl program by Dong Hoon Seo on September 2014
# more information on log book . txt

sub format_Perl {
	my ($plLine) = @_;

 	$lines = $plLine;
	
	#This changes variables

	if ($lines =~ m/.*[a-z0-9]+.*/gi) 
	{
		@line = split(/".+"|\s+/,$lines); 
		#@line = split(/\s+/,$plLine); 
		foreach $word (@line) {	
			#print "word: $word\n";
			if ($word =~ m/.*".*/g) {
				#print "word: found \"\n";
				next;
			} elsif ($word !~ "print") {
				if($word =~ m/[A-Z]+/gi) {
					#$word =~ s/\W*//gi;
					$wordPl = makeVariable($word);
					#print "word: $wordPl\n";
					$lines =~ s/\Q$word/$wordPl/g;
					#print "wordplline = $lines\n";
				}
			}
		}
	}

	#This deals with prints

	if($lines =~ /\s*print.*/)
	{
		$string = $lines;
		$string =~ s/\s*print\s*//g; 
		$string =~ s/\s*$//g;
		#print "String = $string\n";
		#print "format_perl:$string\n";
		if ($string =~ m/".*"/g) {
			#print "YO\n";
			$plString = $string.", \"\\n\"";
		} elsif ($string =~ m/.*\*|\+.*/g) {
			#print "found *\n";
 			$plString = $string.", \"\\n\"";
		} elsif ($string =~ m/.*/g) {
			#print "here\n";
			$plString = "\"".$string."\\n\"";
		} 
		$lines =~ s/\Q$string/$plString/;
	} 
	
	chomp $lines;
	$lines = $lines.";\n";
	return $lines;
}


sub makeVariable {
	my ($pyVar) = @_;
	#if()
	$plVar = "\$".$pyVar;
	return $plVar;
}

sub meticOperators {
	my ($pyLine) = @_;
	chomp $pyLine;
	$plLine = $pyLine;
	@strings = split(/\s+/,$pyLine); 

	foreach $word (@strings) {	
		if($word =~ m/[A-Z]+/gi) {
			$wordPl = makeVariable($word);
			$plLine =~ s/$word/$wordPl/g;
		} elsif ($word =~ m/\-[0-9]+/g) {
			$wordPl = $word;
			$wordPl =~ s/\-//g;
			$plLine =~ s/$word/\- $wordPl/g;
		}
	}
	
	return $plLine.";\n";
}


while ($line = <>) {
	if ($line =~ /^#!/ && $. == 1) {
	
		# translate #! line 
		
		print "#!/usr/bin/perl -w\n";

	} elsif  ($line !~ /^\s*$/) {

		print format_Perl($line);
	
	} elsif ($line =~ /^\s*$/) {
		
		next;

	} else {
	
		# Lines we can't translate are turned into comments
		
		print "#$line\n";
	}

	#} #elsif ($line =~ /^\s*print\s*(.*)\s*$/) {
	
		# Python's print print a new-line character by default
		# so we need to add it explicitly to the Perl print statement
		#print "print \"\$$1\\n";
		#print "\";\n";
		#$plLine = format_Perl($line);
		#print "$plLine";

	#} #elsif ($line =~ /^\s*[A-Z]+[0-9]*\s*=\s*[0-9]*\s*/gi) {
		# Variables added in; Python has no $ where as Perl does.
		# $strings = all the seperate words from the input line
		# $word = single word $wordpl = word in perl format
		# $perled = string has been changed to perl format;
 
	#	chomp $line;
	#	$perled = $line;
	#	@strings = split(/\s+/,$perled); 

	#	foreach $word (@strings) {	
	#		if($word =~ m/[A-Z]+/gi) {
	#			$wordPl = makeVariable($word);
	#			$perled =~ s/$word/$wordPl/g;
	#		} elsif ($word =~ m/\-[0-9]+/g) {
	#			$wordPl = $word;
	#			$wordPl =~ s/\-//g;
	#			$perled =~ s/$word/\- $wordPl/g;
	#		}
	#	}
	
		#print "$perled;\n";
#	
	#}  elsif ($line =~ m/\s*if\s*[A-Z]+[0-9]*.*:.*/gi) { 

		# Reconstructing string when single if expression is found		

	#	print "Found if statement\n";
	#	chomp $line;
	#	$expr = $line;
	#	$expr =~ s/if\s*//g;
	#	$expr =~ s/\s*:.*//g;
#
	#	if ($expr =~ m/\(*[A-Z]+[0-9]*\s*and|or|not\s*[A-Z]+[0-9]*\)*/gi) { 
			# This section deals with logical operators 
			# This section should trigger when a variable and a logical operator exist
			# on the same line.		
	#		@strings = split(/\s+/,$expr);
	#		foreach $word (@strings) {
	#			if(($word =~ m/[A-Z]+[0-9]*/gi) && ($word !~ "and|or|not")) {
	#				$wordPl = makeVariable($word);
	#				if($expr !~ /\$$word/) {
	#					$expr =~ s/\b$word\b/$wordPl/g;
	#				}
	#				print "array: $word, $wordPl\n";
	#			}
				#print "array: $word, $wordPl\n";
	#		}
	#	}
	
	#	$body = $line; 
	#	$body =~ s/.*:\s*//g;
	#	chomp $body;
	#	$body = meticOperator
		

	#	$string = "if";
	#	if ($expr !~ m/(.*)/g) {
	#		$string = $string." (".$expr.")";
	#	} else {
	#		$string = $string.$expr;
	#	}
		
		
		#print "$expr;\n";



	#} elsif ($line =~ m/\(*[A-Z]+[0-9]*\s*\&|\||\^|\~|\<\<|\>\>\s*[A-Z]+[0-9]*\)*/gi) {

		# This Section deals with bitwise operators

}























