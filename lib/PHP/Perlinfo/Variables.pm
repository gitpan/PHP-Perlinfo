
  sub perl_info_print_local_env {

 	return if ($^O =~ /MSWin/);
  	local %ENV;
 	my $shell = shift || (getpwuid($<))[8];
 	my $env = `echo env | perl -e 'exec {"$shell"} -sh'`;
	my @arr = split /\n/, $env;
	perl_info_print_table_row(2, split/=/,$_ ) for @arr;
	
   }
# Should search for Get, Post, Cookies, Session, and Environment.
  sub perl_print_gpcse_array  {
	  my($name) = @_;
	  my ($gpcse_name, $gpcse_value);
	  foreach my $key (sort(keys %ENV))
	  {
		  $gpcse_name = "$name" . '["' . "$key" . '"]';
		  if ($ENV{$key}) {
			  $gpcse_value = "$ENV{$key}";
		  } else {
			  $gpcse_value = "<i>no value</i>";
		  }
		  perl_info_print_table_row(2, "$gpcse_name", "$gpcse_value");
	  }
  }

  sub perl_info_print_variables {

	SECTION("Environment");
		perl_info_print_table_start();
		perl_info_print_table_header(2, "Variable", "Value");
		perl_info_print_local_env();
		perl_info_print_table_end();
	  
	  SECTION("Perl Variables");
		  perl_info_print_table_start();
		  perl_info_print_table_header(2, "Variable", "Value");
		  if (defined($ENV{'SERVER_SOFTWARE'})) {
			  perl_print_gpcse_array("_SERVER");
		  } else {
			  perl_print_gpcse_array("_ENV",);
		  }
		  perl_info_print_table_end();
   }
1;
