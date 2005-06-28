   sub check_path {

	return which("$_[0]") if which("$_[0]");
	return "<i>not in path</i>";

   }

  sub PERL_VERSION {
	  my $version;
          if ($] >= 5.006) {
	  $version = sprintf "%vd", $^V;
          }
	  else { # else time to update Perl!
          $version = "$]";
  	  }
	  return $version;
  }

  sub RELEASE {

	return ($Module::CoreList::released{$]}) ? $Module::CoreList::released{$]} : "unknown";

  }

  
  sub ORA {
	  local($^W) = 0;
	  my $sock = IO::Socket::INET->new(	PeerAddr  => 'perl.oreilly.com',  
		  				PeerPort  => 80,
						PeerProto => 'tcp',
					        Timeout   => 5) || return 0;	 
	  $sock->close;
	  return 1;

  }


  sub perl_info_print_general {

   	          my $connected = ORA();
		  perl_info_print_box_start(1);
		  if ($connected) {
		  print "<a href=\"http://www.perl.com/\"><img border=\"0\" src=\"";
		  print "http://perl.oreilly.com/images/perl/sm_perl_id_313_wt.gif\" alt=\"Perl Logo\" title=\"Perl Logo\" /></a>";
		  }
		  printf("<h1 class=\"p\">Perl Version %s</h1><br clear=all>Release date: %s", PERL_VERSION(), RELEASE());
		 
		  perl_info_print_box_end();

		  perl_info_print_table_start();
 		  my ($sysname, $nodename, $release, $version, $machine) = POSIX::uname();
		  perl_info_print_table_row(2, "Currently running on", "$sysname $nodename $release $version $machine");
		  perl_info_print_table_row(2, "Built for",  "$Config::Config{archname}");
		  perl_info_print_table_row(2, "Build date",  "$Config::Config{cf_time}");
		  
		  perl_info_print_table_row(2, "Additional C Compiler Flags",  "$Config::Config{ccflags}");
		  perl_info_print_table_row(2, "Optimizer/Debugger Flags",  "$Config::Config{optimize}");

		  if (defined($ENV{'SERVER_SOFTWARE'})) {
			  perl_info_print_table_row(2, "Server API", "$ENV{'SERVER_SOFTWARE'}");
		  }

		  perl_info_print_table_row(2, "Perl API",  "$Config::Config{api_version}");

		  if ($Config{useithreads}) {
			  perl_info_print_table_row(2, "Thread Support",  "enabled");
		  } 
		  else {
			  perl_info_print_table_row(2, "Thread Support",  "disabled");
		  }

		  perl_info_print_table_end();

		# Powered by Perl
		# Need to check for net connection
		  perl_info_print_box_start(0);

		  if ($connected) {
		  	print "<a href=\"http://www.perl.com/\"><img border=\"0\" src=\"http://perl.oreilly.com/images/perl/powered_by_perl.gif\" alt=\"Perl logo\" title=\"Perl Logo\" /></a>";
		  	print "This is perl, v$Config::Config{version} built for $Config::Config{archname}<br />Copyright (c) 1987-@{[ sprintf '%d', (localtime)[5]+1900]}, Larry Wall";
		  	print "</td></tr></table>";
		  	print "<font size=\"1\">The use of a camel image in association with Perl is a trademark of <a href=\"http://www.oreilly.com\">O'Reilly Media, Inc.</a> Used with permission.</font><p />";
		  }
		  else {
		  	print "This is perl, v$Config::Config{version} built for $Config::Config{archname}<br />Copyright (c) 1987-@{[ sprintf '%d', (localtime)[5]+1900]}, Larry Wall";
			perl_info_print_box_end();
		  }
		  
		 if ($flag =~ /INFO_ALL/) { 
		  perl_info_print_hr();

		  print <<'END_OF_HTML';
		  <h1>
		  <SCRIPT LANGUAGE="JavaScript">
		  <!--
		  document.write("<a onclick=\"showcredits();\" href=\"javascript:void(0);\">Perl Credits</a>");
		  //-->
		  </SCRIPT>
		  <noscript>Enable JavaScript to see the credits. Alternatively you can use perlinfo(INFO_CREDITS). 
		  </noscript>
		  </h1>
END_OF_HTML
		  perl_info_print_hr();
		  print "<h1>Configuration</h1>\n";
		  perl_info_print_config(); 

 		  SECTION("Perl utilities");
		  perl_info_print_table_start();
		  perl_info_print_table_header(2, "Name", "Location");
		  perl_info_print_table_row(2, cpan_link("h2ph"), check_path("h2ph"));
		  perl_info_print_table_row(2, cpan_link("h2xs"), check_path("h2xs"));
		  perl_info_print_table_row(2, cpan_link("perldoc"), check_path("perldoc"));
		  perl_info_print_table_row(2, cpan_link("pod2html"), check_path("pod2html"));
		  perl_info_print_table_row(2, cpan_link("pod2latex"), check_path("pod2latex"));
		  perl_info_print_table_row(2, cpan_link("pod2man"), check_path("pod2man"));
		  perl_info_print_table_row(2, cpan_link("pod2text"), check_path("pod2text"));
		  perl_info_print_table_row(2, cpan_link("pod2usage"), check_path("pod2usage"));
		  perl_info_print_table_row(2, cpan_link("podchecker"), check_path("podchecker"));
		  perl_info_print_table_row(2, cpan_link("podselect"), check_path("podselect"));
		  perl_info_print_table_end();
		  
		  SECTION("Mail");
		  perl_info_print_table_start();
		  perl_info_print_table_row(2, 'SMTP', hostname());
		  perl_info_print_table_row(2, 'sendmail_path', which("sendmail"));
		  perl_info_print_table_end();


		  perl_info_print_httpd();
		  
		  SECTION("HTTP Headers Information");
		  perl_info_print_table_start();
		  perl_info_print_table_colspan_header(2, "HTTP Request Headers");
		  if  (defined($ENV{'SERVER_SOFTWARE'})) {
		  	perl_info_print_table_row(2, 'HTTP Request', "$ENV{'REQUEST_METHOD'} @{[File::Spec->abs2rel($0)]} $ENV{'SERVER_PROTOCOL'}");
		  	perl_info_print_table_row(2, 'Host', $ENV{'HTTP_HOST'});
		  	perl_info_print_table_row(2, 'User-Agent', $ENV{'HTTP_USER_AGENT'});
		  	perl_info_print_table_row(2, 'Accept', $ENV{'HTTP_ACCEPT_ENCODING'});
		  	perl_info_print_table_row(2, 'Accept-Language', $ENV{'HTTP_ACCEPT_LANGUAGE'});
		  	perl_info_print_table_row(2, 'Accept-Charset', $ENV{'HTTP_ACCEPT_CHARSET'});
		  	perl_info_print_table_row(2, 'Keep-Alive', $ENV{'HTTP_KEEP_ALIVE'});
		  	perl_info_print_table_row(2, 'Connection', $ENV{'HTTP_CONNECTION'});
	  	  }
		  perl_info_print_table_end();
	  }
  }	  
1;
