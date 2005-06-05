sub mod_check {

my $module = $_[0];	
$module =~ s!::!/!g;
$module = "$module.pm";

my $mod_path;
    foreach my $i (@INC)
    {
        if ( -f File::Spec->catfile($i, $module) )
        {
            $mod_path = $i;
            last;
        }
    }
return 1 if ($mod_path);
return 0;
}	

sub cpan_link {

return qq~ <a href="http://search.cpan.org/perldoc?$_[0]" title="Click here to see $_[0] on CPAN [Opens in a new window]" target="_blank">$_[0]</a> ~; 

#return $mod_name;
}


sub perl_info_print_all_modules {
    my ($totalfound, @modCount, %path, $isCore, $coreDir1, $coreDir2); 
	$coreDir1 = File::Spec->canonpath($Config{installarchlib});
	$coreDir2 = File::Spec->canonpath($Config{installprivlib});
  
    @path{@INC} = ();
    for my $base (@INC) { 		  
	find ( sub { 
	my $startdir = "$File::Find::topdir";
	$File::Find::prune = 1, return if
	exists $path{$File::Find::dir} and $File::Find::dir ne $startdir;
	my $module = substr $File::Find::name, length $startdir;
	return unless $module =~ s/\.pm$//;

	$module =~ s!^/+!!;
	$module =~ s!/!::!g;

	my $mod_name = cpan_link($module); 

	# Get the version	
	# Thieved from ExtUtils::MM_Unix 1.12603	    
	
	open(MOD, $_) or die "$_: $!";
	my $inpod = 0;
	my $mod_version;
	while (<MOD>) {
		$inpod = /^=(?!cut)/ ? 1 : /^=cut/ ? 0 : $inpod;
		next if $inpod || /^\s*#/;

		chomp;
		next unless /([\$*])(([\w\:\']*)\bVERSION)\b.*\=/;
		my $eval = qq{
		package PHP::Perlinfo::_version;
		no strict;

		local $1$2;
		\$$2=undef; do {
		$_
		}; \$$2
	};
	local $^W = 0;
	$mod_version = eval($eval);
	warn "Could not eval '$eval' in $_: $@" if $@;
	$mod_version = "undef" unless defined $mod_version;
	last;
}
close MOD;
$mod_version = "unknown" if !($mod_version) || ($mod_version !~ /^\d+(\.\d+)*$/);

# Test to see if the mod is core... not 100% foolproof 
my $totMatches = scalar grep File::Spec->rel2abs($File::Find::dir) =~ /\Q$_/, ($coreDir1, $coreDir2);
$isCore = ($totMatches) ? "yes" : "no";

# we are done
perl_info_print_table_row(4, "$mod_name", "$mod_version", "$isCore", "$File::Find::dir");

$totalfound++;  
			   }, $base); 
		  push(@modCount, $totalfound);
		  $totalfound = 0;
	  }

	  perl_info_print_table_end();
         
	  perl_info_print_table_start();
	  perl_info_print_table_header(2, "Directories", "Number of modules");

	  my ($amountIndex, $totalAmount) = 0;	
	  for my $base (@INC) {
		  perl_info_print_table_row(2, "$base", "$modCount[$amountIndex]");	
		  $amountIndex++;
	  }	

	  perl_info_print_table_end();
	  perl_info_print_table_start(); 
	  $totalAmount += $_ for (@modCount); 
	  perl_info_print_table_row(2, "Total modules", "$totalAmount");
	  perl_info_print_table_end();
	  
	  perl_info_print_table_end();
  }

sub perl_info_print_modules {

  	SECTION("mysql");
		  perl_info_print_table_start();
		  perl_info_print_table_header(2, "MySQL Support", "installed");
		  if (mod_check("DBI")) {
		  perl_info_print_table_row(2, "@{[cpan_link('DBI')]} - Database independent interface", "yes");
		  }
		  else {
		  perl_info_print_table_row(2, "@{[cpan_link('DBI')]} - Database independent interface", "no");
	  	  }
		  if (mod_check("DBD::mysql")) {
		  perl_info_print_table_row(2, "@{[cpan_link('DBD::mysql')]} - MySQL driver for the DBI", "yes");  
		  } 
		  else {
		  perl_info_print_table_row(2, "@{[cpan_link('DBD::mysql')]} - MySQL driver for the DBI", "no");
  	          }
		  perl_info_print_table_end();

	SECTION("All modules & pragmas");
		  perl_info_print_table_start();
		  perl_info_print_table_header(4, "Module name", "Version", "Core", "Location");
		  perl_info_print_all_modules();

}
  
1;
