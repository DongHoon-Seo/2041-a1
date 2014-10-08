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
			}  elsif ($word =~ /\bbreak\b/) {
				#HANDLES BREAKS
				$lines =~ s/$word/last/g;
			} elsif ($word !~ /\bprint\b/gi) {
				#if($word =~ \\)
				if($word =~ m/[A-Z]+/gi) {
					$word =~ s/\W*//gi;
					$wordPl = makeVariable($word);
					#print "word: $word wordpl: $wordPl\n";
					#print "line:$line\n";
					if ($lines !~ /\$+$word/) {
						$lines =~ s/\b\$*$word\b/$wordPl/g;
					} #
					#$lines =~ s/\Q$word/$wordPl/g;
					#print "wordplline = $lines\n";
				}
			}
		}
	}

	#This deals with prints

	if($lines =~ /\s*print\s*.*/)
	{
		$string = $lines;
		$string =~ s/\s*\bprint\b\s*//g; 
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

#	print "BEFORE:LINES $line\n";

	if ($line =~ /^#!/ && $. == 1) {
	
		# translate #! line 
		
		print "#!/usr/bin/perl -w\n";

	} elsif ($line =~ /^\s*$/) {
		
		# If empty line ignore.

		next;

	} elsif ($line !~ /^\s*$/) {

		# If not empty we process line.

		if ($line =~ /\bif\b/i) {
			
			#print "If is found";
			#print "line:$line\n";
			@if_statement = split(/if|:|;/,$line);	
			$result_string = "";
			$count = 0;

			foreach $if_lines (@if_statement) {
				chomp $line;
				$line =~ s/;//;
				#print "input : $if_lines\n";
				if ($if_lines =~ /^\s*$/) {
					next;
				} else {
					$count = $count + 1;
					#print "splited:$if_lines\n";
					$perl_string = format_Perl($if_lines);
					#print "count =$count";
					if ($count == 1) {
						$line =~ s/$if_lines/$perl_string/;
						$line =~ s/if */if (/i;
						#$line =~ s/$if_lines/$perl_string/;
						#print "perly:$perl_string\n";
						$line =~ s/: ?/) {\n /;
					} elsif ($count > 1) {
						chomp $if_lines;
						chomp $perl_string;
						$line =~ s/$if_lines/   $perl_string\/n/;
					}
				}
			}
			$line =~ s/\/n/;\n/g;
			print "$line}\n";

		} elsif ($line =~ /\bwhile\b/i) { 
			
			@while_statement = split(/while|:|;/,$line);	
			$result_string = "";
			$count = 0;

			foreach $while_lines (@while_statement) {
				chomp $line;
				$line =~ s/;//;
				#print "input : $while_lines\n";
				if ($while_lines =~ /^\s*$/) {
					next;
				} else {
					$count = $count + 1;
					#print "splited:$while_lines\n";
					$perl_string = format_Perl($while_lines);
					#print "count =$count";
					if ($count == 1) {
						#print "happening $line\n";
						$line =~ s/$while_lines/$perl_string/;
						$line =~ s/while */while (/i;
						#$line =~ s/$if_lines/$perl_string/;
						#print "$perl_string";
						$line =~ s/: ?/) {\n /;
					} elsif ($count > 1) {
						#print "String:$perl_string\n";
						chomp $while_lines;
						#print "Stringmatch$while_lines\n";
						#print "line : $line\n";
						$line =~ s/\Q$while_lines\E/   $perl_string\/n/;
			
						#print "hello:$perl_string";
						#print "$while_lines\n";
					}
				}
			}
			#$templine = $line;
		#	print "linebefore : $line\n";
			$line =~ s/\/n/;\n/g;
			#$line =~ s/^\s*$/hi/;
		#	print "lineafter : $line\n";
			print "$line}\n";

		} else {
			#print "Else:$line\n";
			print format_Perl($line).";\n";

		}
	
	} elsif ($line =~ /^\s*$/) {
		
		# If empty line ignore.

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























