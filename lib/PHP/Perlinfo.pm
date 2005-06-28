# ===============================================
# The original C version in the PHP source: 
# php-source\ext\standard\info.c
# ===============================================

package PHP::Perlinfo;

use App::Info::HTTPD::Apache;
use CGI::Carp 'fatalsToBrowser';
use Config qw(%Config config_sh);
use Net::Domain qw(hostname);
use Carp qw(croak); 
use Module::CoreList;
use File::Find;
use File::Spec;
use IO::Socket;
use IO::Scalar;
use File::Which;
use POSIX;

require Exporter;
require PHP::Perlinfo::HTML; 
require PHP::Perlinfo::Credits;
require PHP::Perlinfo::Config;
require PHP::Perlinfo::General;
require PHP::Perlinfo::Variables;
require PHP::Perlinfo::Apache;
require PHP::Perlinfo::MySQL;
require PHP::Perlinfo::Modules;
require PHP::Perlinfo::License;

@PHP::Perlinfo::ISA    = qw(Exporter);
@PHP::Perlinfo::EXPORT = qw(perlinfo);

$VERSION = '0.09';

# This is for modperl
initialize_globals();

  sub perl_print_info {

	  $flag = $_[0];
	  perl_info_print_htmlhead();
	  perl_info_print_script()  if ($flag =~ /INFO_ALL/);
	  perl_info_print_credits() if ($flag =~ /INFO_CREDITS/);
	  perl_info_print_config() if ($flag =~ /INFO_CONFIG/);
	  perl_info_print_httpd() if ($flag =~ /INFO_APACHE/);
	  perl_info_print_general() if ($flag =~ /INFO_ALL|INFO_GENERAL/);
	  perl_info_print_variables() if  ($flag =~ /INFO_ALL|INFO_VARIABLES/);
          perl_info_print_modules()   if  ($flag =~ /INFO_ALL|INFO_MODULES/);
          perl_info_print_license()   if  ($flag =~ /INFO_ALL|INFO_LICENSE/);
	  print "</div></body></html>";
  }

  #Output a page of useful information about Perl and the current request 

  sub perlinfo { 
	  
	  my $INFO = (($_[0] eq "") || ($_[0] !~ /[^\s]+/)) ? "INFO_ALL" : $_[0];
	  croak "@_ is an invalid perlinfo() parameter"
	  if (($INFO !~ /INFO_ALL|INFO_GENERAL|INFO_CREDITS|INFO_CONFIG|INFO_VARIABLES|INFO_APACHE|INFO_MODULES|INFO_LICENSE/) || @_ > 1); 
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

This module outputs a large amount of information (only in HTML in this release) about the current state of Perl. So far, this includes information about Perl compilation options, the Perl version, server information and environment, HTTP headers, OS version information, Perl modules, and the Perl License. 

Since the module outputs HTML, you may want to use it in a CGI script, but you do not have to. Of course, some information, like HTTP headers, would not be available if you use the module at the command-line.
 
It is based on PHP's phpinfo function. Like other clones of PHP functions on CPAN, perlinfo attempts to mimic the PHP function is as many ways as possible. But, of course, there are some differences in the Perl version. These differences will be logged in future revisions.

PHP's phpinfo function is usually one of the first things a new PHP programmer learns. It is a very useful function for debugging and checking configuration settings. I expect that many users of this module will already know PHP's phpinfo. To familiarize yourself with phpinfo, you can google "phpinfo" and see the output for phpinfo in one of the many results. (I rather not provide a link that can go bad with the passage of time.)


=head1 OPTIONS

There are 6 options to pass to the perlinfo funtion. All of these options are also object methods. The key difference is their case: Captilize the option name when passing it to the function and use only lower-case letters when using the object-oriented approach.

=over

=item INFO_GENERAL

The configuration line, build date, Web Server, System and more.

=item INFO_LICENSE 

Perl license information.

=item INFO_CONFIG

All configuration 

=item INFO_APACHE

Apache HTTP server information.  

=item INFO_MODULES 

All installed modules, their version number and more. The default is core modules.

=item INFO_VARIABLES 

Shows all predefined variables from EGPCS (Environment, GET, POST, Cookie, Server).    

=item INFO_CREDITS

Shows the credits for Perl, listing the Perl pumpkings, developers, module authors, etc.

=item INFO_ALL

Shows all of the above. This is the default value.

=back

=head1 OBJECT METHODS

These object methods allow you to change the HTML CSS settings to achieve a stylish effect. You must pass them a parameter or your program will die. Please see your favorite HTML guide for acceptable CSS values. Refer to the HTML source code of perlinfo for the defaults.

Method name/Corresponding CSS element

 bg_image 		/ background_image
 bg_position 		/ background_position
 bg_repeat 		/ background_repeat
 bg_attribute 		/ background_attribute 
 bg_color 		/ background_color
 ft_family 		/ font_familty 
 ft_color 		/ font_color
 lk_color 		/ link color
 lk_decoration 		/ link text-decoration  
 lk_bgcolor 		/ link background-color 
 lk_hvdecoration 	/ link hover text-decoration 
 header_bgcolor 	/ table header background-color 
 header_ftcolor 	/ table header font color
 leftcol_bgcolor	/ background-color of leftmost table cell  
 leftcol_ftcolor 	/ font color of left table cell
 rightcol_bgcolor	/ background-color of right table cell  
 rightcol_ftcolor	/ font color of right table cell

Remember that there are more methods (the info options listed above). 

=head1 EXAMPLES

Function-oriented style:

	# Show all information, defaults to INFO_ALL
	perlinfo();

	# Show only module information
	perlinfo(INFO_MODULES);

Object-oriented style:

	$p = new PHP::Perlinfo;
	$p->bg_color("#eae5c8");
	$p->info_all;

	# You can also set the CSS values in the constructor!
    	$p = PHP::Perlinfo->new(
		bg_image  => 'http://www.tropic.org.uk/~edward/ctrip/images/camel.gif',
		bg_repeat => 'yes-repeat'
	);
	$p->info_all;

More examples . . .

	# This is wrong (no capitals!)
	$p->INFO_CREDITS;

	# But this is correct
	perlinfo(INFO_CREDITS);
	
	# Ditto
	$p->info_credits;

=head1 NOTES

This module is still in the early stages of development. Many new additions and changes are planned. 

Perlinfo still lacks features that are in the PHP version.  

=head1 SEE ALSO

L<Config>. You can also use "perl -V" to see a configuration summary.

Perl Diver and Perl Digger are free CGI scripts that offer similar information.  

Perl Diver:  L<http://www.scriptsolutions.com/programs/free/perldiver/>

Perl Digger: L<http://sniptools.com/perldigger>

You can also read the description of the original PHP version:

L<http://www.php.net/manual/en/function.phpinfo.php>

=head1 AUTHOR

Mike Accardo <mikeaccardo@yahoo.com> Suggestions and comments welcomed.

=head1 COPYRIGHT

   Copyright (c) 2005, Mike Accardo. All Rights Reserved.
 This module is free software. It may be used, redistributed
and/or modified under the terms of the Perl Artistic License.

=cut

