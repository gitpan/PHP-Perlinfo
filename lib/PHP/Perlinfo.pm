# ===============================================
# Thanks to the PHP authors for making this possible.
#
# The original C version in the PHP source: 
# php-source\ext\standard\info.c
# ================================================

package PHP::Perlinfo;
require Exporter;
@PHP::Perlinfo::ISA    = qw(Exporter);
@PHP::Perlinfo::EXPORT = qw(perlinfo);
$VERSION = '0.03';

use Config; 
use File::Find;
use File::Spec;
use IO::Socket;
use POSIX qw(uname);
my ($sysname, $nodename, $release, $version, $machine) = POSIX::uname();

# get current year
sub year {
	my ($y) = (localtime)[5];
	my $year = sprintf '%d', $y+1900;
	return "$year";
}

sub modules {

	$File::Find::prune = 1, return if
	exists $path{$File::Find::dir} and $File::Find::dir ne $base;
	my $module = substr $File::Find::name, length $base;
	return unless $module =~ s/\.pm$//;


	$module =~ s!^/+!!;
	$module =~ s!/!::!g;

	my $mod_name = qq~ <a href="http://search.cpan.org/search?module=$module" title="Click here to see $module on CPAN [Opens in a new window]" target="_blank">$module</a> ~; 

	# Get the version	
	# Thieved from ExtUtils::MM_Unix 1.12603	    


	$parsefile =  File::Spec->rel2abs($File::Find::name);
	open(MOD, $parsefile) or die $!;
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
	warn "Could not eval '$eval' in $parsefile: $@" if $@;
	$mod_version = "undef" unless defined $mod_version;
	last;
}
close MOD;
$mod_version = "unknown" if ($mod_version !~ /^\d+(\.\d+)*$/);

# Test to see if the mod is core... not 100% foolproof.. yes, i know this is ugly
my $chSlashes = File::Spec->rel2abs($File::Find::dir);
my $totMatches = scalar grep $chSlashes =~ /\Q$_/, 
(File::Spec->canonpath($Config{installarchlib}),
	File::Spec->canonpath($Config{installprivlib}));
($totMatches) ? ($isCore = "yes") : ($isCore = "no");

# we are done
perl_info_print_table_row(4, "$mod_name", "$mod_version", "$isCore", "$File::Find::dir");

return $totalMods++;

  }

  sub perl_info_print_modules {

	  @path{@INC} = ();
	  for $base (@INC) { 
		  find(\&modules, $base); 
		  push(@modCount, $totalMods);
		  $totalMods = 0;
	  }

  }

  sub perl_info_print_modules_amount {

	  my $amountIndex = 0;	
	  for $base (@INC) {

		  perl_info_print_table_row(2, "$base", "$modCount[$amountIndex]");	
		  $amountIndex++;
	  }	
	  perl_info_print_table_end();
	  perl_info_print_table_start(); 
	  $totalAmount += $_ for (@modCount); 
	  perl_info_print_table_row(2, "Total modules", "$totalAmount");
	  perl_info_print_table_end();
  }

# Should search for Get, Post, Cookies, Session, and Environment.
  sub perl_print_gpcse_array  {
	  my($name) = @_;
	  my ($gpcse_name, $gpcse_value);
	  foreach $key (sort(keys %ENV))
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

  sub perl_info_print_table_row {

	  my($num_cols) = $_[0];
	  print "<tr>";

	  for ($i=0; $i<$num_cols; $i++) {

		  printf("<td class=\"%s\">",
			  ($i==0 ? "e" : "v" )
		  );

		  my $row_element = $_[$i+1];
		  if ((not defined ($row_element)) || ($row_element !~ /[^\s+]/)) {
			  print "<i>no value</i>";
		  } else {
			  my $elem_esc = $row_element;
			  print "$elem_esc";

		  }

		  print " </td>";

	  }

	  print "</tr>\n";
  }

  sub perl_info_print_table_start {

	  print "<table border=\"0\" cellpadding=\"3\" width=\"600\">\n";

  }
  sub perl_info_print_table_end {

	  print "</table><br />\n";

  }
  sub perl_info_print_box_start {

	  perl_info_print_table_start();	
	  if ($_[0] == 1) {
		  print "<tr class=\"h\"><td>\n";
	  } 
	  else {
		  print "<tr class=\"v\"><td>\n";
	  }
  }


  sub perl_info_print_box_end {
	  print "</td></tr>\n";
	  perl_info_print_table_end();
  }
  sub perl_info_print_hr {
	  print "<hr />\n";

  }
  sub perl_info_print_table_header {

	  my($num_cols) = $_[0];
	  print "<tr class=\"h\">";

	  my $i;		
	  for ($i=0; $i<$num_cols; $i++) {
		  my $row_element = $_[$i+1];
		  $row_element = " " if (!$row_element);
		  print "<th>";
		  print $row_element;
		  print "</th>";
	  }

	  print "</tr>\n";
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

  sub ORA {
	  local($^W) = 0;
	  my $sock = IO::Socket::INET->new(	PeerAddr  => 'perl.oreilly.com',  
		  				PeerPort  => 80,
						PeerProto => 'tcp',
					        Timeout   => 5) || return 0;	 
	  $sock->close;
	  return 1;

  }

  sub SECTION  {

	  print "<h2>" . $_[0] . "</h2>\n"; 

  }


  sub perl_info_print_license {

	  print <<'END_OF_HTML';
<p>
This program is free software; you can redistribute it and/or modify it under the terms of
either the Artistic License or the GNU General Public License, which may be found in the Perl 5 source kit.
</p>

<p>This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
</p>
<p>
Complete documentation for Perl, including FAQ lists, should be found on
this system using `man perl' or `perldoc perl'.  If you have access to the
Internet, point your browser at <a href="http://www.perl.org/">http://www.perl.org/</a>, the Perl directory. 
END_OF_HTML

  }


  sub perl_info_print_css{

	  print <<'END_OF_HTML';
body {background-color: #ffffff; color: #000000;}
body, td, th, h1, h2 {font-family: sans-serif;}
pre {margin: 0px; font-family: monospace;}
a:link {color: #000099; text-decoration: none; background-color: #ffffff;}
a:hover {text-decoration: underline;}
table {border-collapse: collapse;}
.center {text-align: center;}
.center table { margin-left: auto; margin-right: auto; text-align: left;}
.center th { text-align: center !important; }
td, th { border: 1px solid #000000; font-size: 75%; vertical-align: baseline;}
h1 {font-size: 150%;}
h2 {font-size: 125%;}
.p {text-align: left;}
.e {background-color: #ccccff; font-weight: bold; color: #000000;}
.h {background-color: #9999cc; font-weight: bold; color: #000000;}
.v {background-color: #cccccc; color: #000000;}
i {color: #666666; background-color: #cccccc;}
img {float: right; border: 0px;}
hr {width: 600px; background-color: #cccccc; border: 0px; height: 1px; color: #000000;}
END_OF_HTML

  }

  sub perl_info_print_style {
	  print "<style type=\"text/css\"><!--\n";
	  perl_info_print_css();
	  print "//--></style>\n";
  }


  sub perl_print_info_htmlhead {
	  print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"DTD/xhtml1-transitional.dtd\">\n";
	  print "<html>";
	  print "<head>\n";
	  perl_info_print_style();
	  print "<title>perlinfo()</title>";
	  print "</head>\n";
	  print "<body><div class=\"center\">\n";
  }

  sub perl_print_info {

	  my ($flag) = @_;

	  perl_print_info_htmlhead();


	  if ($flag =~ /INFO_ALL|INFO_GENERAL/) {

		  my $connected = ORA();
		  perl_info_print_box_start(1);
		  if ($connected) {
		  print "<a href=\"http://www.perl.com/\"><img border=\"0\" src=\"";
		  print "http://perl.oreilly.com/images/perl/sm_perl_id_313_wt.gif\" alt=\"Perl Logo\" title=\"Perl Logo\" /></a>";
		  }
		  printf("<h1 class=\"p\">Perl Version %s</h1>\n", PERL_VERSION());
		  perl_info_print_box_end();

		  perl_info_print_table_start();
		  perl_info_print_table_row(2, "Currently running on", "$sysname $nodename $release $version $machine");
		  perl_info_print_table_row(2, "Built for",  "$Config::Config{archname}");
		  perl_info_print_table_row(2, "Build date",  "$Config::Config{cf_time}");
		  perl_info_print_table_row(2, "Additional C Compiler Flags",  "$Config::Config{ccflags}");
		  perl_info_print_table_row(2, "Optimizer/Debugger Flags",  "$Config::Config{optimize}");

		  if (defined($ENV{'SERVER_SOFTWARE'})) {
			  perl_info_print_table_row(2, "Server API", "$ENV{'SERVER_SOFTWARE'}");
		  }

		  perl_info_print_table_row(2, "Perl API",  "$Config::Config{api_version}");
		  perl_info_print_table_row(2, "XS API",    "$Config::Config{xs_apiversion}");

		  if ($Config{useithreads}) {
			  perl_info_print_table_row(2, "Thread Support",  "enabled");
		  } else {
			  perl_info_print_table_row(2, "Thread Support",  "disabled");
		  }

		  perl_info_print_table_end();

		# Powered by Perl
		# Need to check for net connection
		  perl_info_print_box_start(0);

		  if ($connected) {
		  	print "<a href=\"http://www.perl.com/\"><img border=\"0\" src=\"http://perl.oreilly.com/images/perl/powered_by_perl.gif\" alt=\"Perl logo\" title=\"Perl Logo\" /></a>";
		  	print "This is perl, v$Config::Config{version} built for $Config::Config{archname}<br />Copyright (c) 1987-@{[ &year ]}, Larry Wall";
		  	print "</td></tr></table>";
		  	print "<font size=\"1\">The use of a camel image in association with Perl is a trademark of <a href=\"http://www.oreilly.com\">O'Reilly Media, Inc.</a> Used with permission.</font><p />";
		  }
		  else {
		  	print "This is perl, v$Config::Config{version} built for $Config::Config{archname}<br />Copyright (c) 1987-@{[ &year ]}, Larry Wall";
			perl_info_print_box_end();
		  }

		  perl_info_print_hr();
		  print "<h1><a href=\"http://search.cpan.org/src/NWCLARK/perl-5.8.6/AUTHORS\">";
		  print "Perl Credits";
		  print "</a></h1>\n";
		  perl_info_print_hr();

	  }

	  if  ($flag =~ /INFO_ALL|INFO_VARIABLES/) {
		  SECTION("Perl Variables");
		  perl_info_print_table_start();
		  perl_info_print_table_header(2, "Variable", "Value");
		  perl_info_print_table_row(2, "Perl_SELF", $0);
		  if (defined($ENV{'SERVER_SOFTWARE'})) {
			  perl_print_gpcse_array("_SERVER");
		  } else {
			  perl_print_gpcse_array("_ENV",);
		  }
		  perl_info_print_table_end();
	  }

	  if  ($flag =~ /INFO_ALL|INFO_MODULES/) {

		  SECTION("Perl Modules");
		  perl_info_print_table_start();
		  perl_info_print_table_header(4, "Module name", "Version", "Core", "Location");
		  perl_info_print_modules();
		  perl_info_print_table_end();

		  perl_info_print_table_start();

		  perl_info_print_table_header(2, "Directories", "Number of modules");
		  perl_info_print_modules_amount();
		  perl_info_print_table_end();
	  }

	  if  ($flag =~ /INFO_ALL|INFO_LICENSE/) {
		  SECTION("Perl License");
		  perl_info_print_box_start(0);
		  perl_info_print_license();
		  perl_info_print_box_end();
	  }
	  print "</div></body></html>";
  }
# Output a page of useful information about Perl and the current request 
  sub perlinfo { 

	  my ( $INFO ) = @_;

	  $INFO = "INFO_ALL" unless $INFO; 

	  # Andale!  Andale!  Yee-Hah! 
	  print "Content-type: text/html\n\n" if (defined($ENV{'SERVER_SOFTWARE'}));
	  perl_print_info($INFO);

  }
1;
__END__
=pod

=head1 NAME

PHP::Perlinfo - Clone of PHP's phpinfo function for Perl 

=head1 SYNOPSIS

	use PHP::Perlinfo;

	perlinfo();

=head1 DESCRIPTION

This module outputs a large amount of information (only in HTML in this release) about the current state of Perl. So far, this includes information about Perl compilation options, the Perl version, server information and environment, OS version information, Perl modules, and the Perl License.  

It is based on PHP's phpinfo function. Like other clones of PHP functions on CPAN, Perlinfo attempts to mimic the PHP function is as many ways as possible. But, of course, there are some differences in the Perl version. These differences will be logged in future revisions.

PHP's phpinfo function is usually one of the first things a new PHP programmer learns. It is a very useful function for debugging and checking configuration settings. I expect that many users of this module will already know PHP's phpinfo. To familiarize yourself with phpinfo, you can google "phpinfo" and see the output for phpinfo in one of the many results. (I rather not provide a link that can go bad with the passage of time.)

=over 1

You can also read the description of the original PHP version:

=item L<http://www.php.net/manual/en/function.phpinfo.php>

=back

=head1 OPTIONS

There are only 5 options in this initial release. All 5 are copied from phpinfo. More to come.

=over

=item INFO_GENERAL

The configuration line, build date, Web Server, System and more.

=item INFO_LICENSE 

Perl license information.

=item INFO_MODULES 

Local modules, their version number and more.

=item INFO_VARIABLES 

Shows all predefined variables from EGPCS (Environment, GET, POST, Cookie, Server). This is not fully implemented yet.   

=item INFO_ALL

Shows all of the above. This is the default value.

=back

=head1 EXAMPLES

	# Show all information, defaults to INFO_ALL
	perlinfo();

	# Show only module information
	perlinfo(INFO_MODULES);

Other things you could try: email yourself the results. This is handy in debug situations or if you want to keep an eye on something. To change stylesheet settings you could tie a variable to STDOUT, put the output into that variable and do a regular expression substitution.   

=head1 NOTES

This is an early release of this module and it lacks many important features in the PHP version. These 
features are not hard to implement but finding the time to add them is. Help wanted! Please 
email me if you want to help out, too. Thanks.

=head1 AUTHOR

Mike Accardo <mikeaccardo@yahoo.com>

=head1 COPYRIGHT

   Copyright (c) 2004, Mike Accardo. All Rights Reserved.
 This module is free software. It may be used, redistributed
and/or modified under the terms of the Perl Artistic License.

=cut
