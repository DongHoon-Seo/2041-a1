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
			}  elsif ($word =~ /\bbreak\b/i) {
				#HANDLES BREAKS
				$lines =~ s/$word/last/g;
			} elsif ($word =~ /\bcontinue\b/i) {
				$lines =~ s/$word/continue/g;
			} elsif ($word !~ /\bprint\b/gi) {
				if($word =~ m/\band\b|\bor\b|\bnot\b/gi) {
					#does nothing if and or not come up as it is the same in both
				} elsif($word =~ m/[A-Z]+/gi ) {
					$word =~ s/\W*//gi;
					$wordPl = makeVariable($word);
					#print "word: $word wordpl: $wordPl\n";
					#print "line:$line\n";
					if ($lines !~ /\$+$word/) {
						$lines =~ s/\b\$*$word\b/$wordPl/g;
					} 
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
		} elsif ($string =~ m/.*\*|\+|\/|\-|\%|\*\*.*/g) {
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

while ($line = <>) {

#	print "BEFORE:LINES $line\n";

	if ($line =~ /^#!/ && $. == 1) {
	
		# translate #! line 
		
		print "#!/usr/bin/perl -w\n";

	} elsif ($line =~ /^\s*$/) {
		
		# If empty line ignore.
		next;

	} elsif ($line =~ /^#/) { 
	
		print $line;

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

}























