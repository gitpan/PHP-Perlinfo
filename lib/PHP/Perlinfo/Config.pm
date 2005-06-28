sub perl_info_print_config {

      SECTION("Perl Core");
		  perl_info_print_table_start();
		  perl_info_print_table_header(2, "Variable", "Value");
		  perl_info_print_config_sh();
		  perl_info_print_table_end();
}

sub perl_info_print_config_sh {

		
	my $io = tie *STDOUT, 'IO::Scalar', \$str;
	print config_sh();
	undef $io;
	untie *STDOUT;

	my @results = split /\n/, $str;

	unless ($flag =~ /INFO_CONFIG/) {

		@results = grep !/(^[idho]*_|^contains|^csh|^[Dd]ate|^Id|^Log|^Mcc|^defvoidused|^dlext|^drand01|^eagain|^echo|^egrep|^exe_ext|man.*=|^a[flw]|^b[aiy]|^c[ahp]|obj|^[ntqdfR]|^l[dnos]|^m[ako]|^r[admu]|^s[Scehopy]|^sig|size|type|define|undef|^[gns]et|^end|^sPR|long|proto|std|^[uig](id|\d+)|^use|^[uni]v|=''|=':'|='\s+')/, @results;

	}
	perl_info_print_table_row(2, split/=/,$_ ) for @results;	
}

1;
