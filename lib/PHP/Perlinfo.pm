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
$VERSION = '0.04'; 

use Config; 
use File::Find;
use File::Spec;
use IO::Socket;
use IO::Scalar;
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

  sub perl_info_print_credits {
	 
	        print "<h1>Perl Credits</h1>\n"; 
		# The Keepers of the Pumpkin    
   	        perl_info_print_table_start();
		perl_info_print_table_header(1, "Perl 5 Pumpkings");
		perl_info_print_table_row(1, "Larry Wall, Andy Dougherty, Tom Christiansen, Charles Bailey, Nick Ing-Simmons, Chip Salzenberg, Tim Bunce, Malcolm Beattie, Gurusamy Sarathy, Graham Barr, Jarkko Hietaniemi ");
		perl_info_print_table_end();
 	

		# Design & Concept 
		perl_info_print_table_start();
		perl_info_print_table_header(1, "Language Design &amp; Concept");
		perl_info_print_table_row(1, "Larry Wall");
		perl_info_print_table_end();

		# Perl 5 Language 
		perl_info_print_table_start();
		perl_info_print_table_colspan_header(2, "Perl 5 Authors");
		perl_info_print_table_header(2, "Contribution", "Authors");
		perl_info_print_table_row(2, "XS Interface Language", "Dean Roehrich");
		perl_info_print_table_row(2, "POD Format Language", "Larry Wall");
		perl_info_print_table_row(2, "Mac OS Port", "Matthias Neeracher");
		perl_info_print_table_row(2, "Win32 Port", "ActiveState with assistance from Microsoft Inc.");
		perl_info_print_table_row(2, "Other contributors", "Patch submitters and other contributers are listed in the authors file in the source distribution");
		perl_info_print_table_end();
	

		# Modules 
		perl_info_print_table_start();
		perl_info_print_table_colspan_header(2, "Core Module Authors");
		perl_info_print_table_header(2, "Module", "Authors");
	      
	        # This is the list for 5.8.3. 	
		perl_info_print_table_row(2, "AnyDBM_File","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Attribute::Handlers","Arthur Bergman");
		perl_info_print_table_row(2, "AutoLoader","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "AutoSplit","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "B","Malcolm Beattie");
		perl_info_print_table_row(2, "B::Asmdata","Nicholas Clark");
		perl_info_print_table_row(2, "B::Assembler","Nicholas Clark");
		perl_info_print_table_row(2, "B::Bblock","Nicholas Clark");
		perl_info_print_table_row(2, "B::Bytecode","Nicholas Clark");
		perl_info_print_table_row(2, "B::C","Nicholas Clark");
		perl_info_print_table_row(2, "B::CC","Nicholas Clark");
		perl_info_print_table_row(2, "B::Concise","Nicholas Clark");
		perl_info_print_table_row(2, "B::Debug","Nicholas Clark");
		perl_info_print_table_row(2, "B::Deparse","Nicholas Clark");
		perl_info_print_table_row(2, "B::Disassembler","Nicholas Clark");
		perl_info_print_table_row(2, "B::Lint","Nicholas Clark");
		perl_info_print_table_row(2, "B::Showlex","Nicholas Clark");
		perl_info_print_table_row(2, "B::Stackobj","Nicholas Clark");
		perl_info_print_table_row(2, "B::Stash","Nicholas Clark");
		perl_info_print_table_row(2, "B::Terse","Nicholas Clark");
		perl_info_print_table_row(2, "B::Xref","Nicholas Clark");
		perl_info_print_table_row(2, "Benchmark","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "ByteLoader","Nicholas Clark");
		perl_info_print_table_row(2, "CGI","Lincoln D. Stein");
		perl_info_print_table_row(2, "CGI::Carp","The CGI-Perl Developers mailing list");
		perl_info_print_table_row(2, "CGI::Cookie","Lincoln D. Stein");
		perl_info_print_table_row(2, "CGI::Fast","Lincoln D. Stein");
		perl_info_print_table_row(2, "CGI::Pretty","Lincoln D. Stein");
		perl_info_print_table_row(2, "CGI::Push","Lincoln D. Stein");
		perl_info_print_table_row(2, "CGI::Util","Lincoln D. Stein");
		perl_info_print_table_row(2, "CPAN","Andreas J. Koenig");
		perl_info_print_table_row(2, "CPAN::FirstTime","Andreas J. Koenig");
		perl_info_print_table_row(2, "CPAN::Nox","Andreas J. Koenig");
		perl_info_print_table_row(2, "Carp","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Class::ISA","Sean M. Burke");
		perl_info_print_table_row(2, "Class::Struct","Nicholas Clark");
		perl_info_print_table_row(2, "Config","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Cwd","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "DB_File","Paul Marquess");
		perl_info_print_table_row(2, "Data::Dumper","Gurusamy Sarathy");
		perl_info_print_table_row(2, "Devel::DProf","Dean Roehrich");
		perl_info_print_table_row(2, "Devel::PPPort","Marcus Holland-Moritz");
		perl_info_print_table_row(2, "Devel::Peek","Ilya Zakharevich");
		perl_info_print_table_row(2, "Devel::SelfStubber","Nicholas Clark");
		perl_info_print_table_row(2, "Digest","Gisle Aas");
		perl_info_print_table_row(2, "Digest::MD5","Gisle Aas");
		perl_info_print_table_row(2, "Digest::base","Gisle Aas");
		perl_info_print_table_row(2, "DirHandle","Chip Salzenberg");
		perl_info_print_table_row(2, "Dumpvalue","Nicholas Clark");
		perl_info_print_table_row(2, "DynaLoader","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Encode","Dan Kogai");
		perl_info_print_table_row(2, "Encode::Alias","Dan Kogai");
		perl_info_print_table_row(2, "Encode::Byte","Dan Kogai");
		perl_info_print_table_row(2, "Encode::CJKConstants","Dan Kogai");
		perl_info_print_table_row(2, "Encode::CN","Dan Kogai");
		perl_info_print_table_row(2, "Encode::CN::HZ","Dan Kogai");
		perl_info_print_table_row(2, "Encode::Config","Dan Kogai");
		perl_info_print_table_row(2, "Encode::EBCDIC","Dan Kogai");
		perl_info_print_table_row(2, "Encode::Encoder","Dan Kogai");
		perl_info_print_table_row(2, "Encode::Encoding","Dan Kogai");
		perl_info_print_table_row(2, "Encode::Guess","Dan Kogai");
		perl_info_print_table_row(2, "Encode::JP","Dan Kogai");
		perl_info_print_table_row(2, "Encode::JP::H2Z","Dan Kogai");
		perl_info_print_table_row(2, "Encode::JP::JIS7","Dan Kogai");
		perl_info_print_table_row(2, "Encode::KR","Dan Kogai");
		perl_info_print_table_row(2, "Encode::KR::2022_KR","Dan Kogai");
		perl_info_print_table_row(2, "Encode::MIME::Header","Dan Kogai");
		perl_info_print_table_row(2, "Encode::Symbol","Dan Kogai");
		perl_info_print_table_row(2, "Encode::TW","Dan Kogai");
		perl_info_print_table_row(2, "Encode::Unicode","Dan Kogai");
		perl_info_print_table_row(2, "Encode::Unicode::UTF7","Dan Kogai");
		perl_info_print_table_row(2, "English","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Env","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Errno","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Exporter","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Exporter::Heavy","Nicholas Clark");
		perl_info_print_table_row(2, "ExtUtils::Command","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::Command::MM","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::Constant","Nicholas Clark");
		perl_info_print_table_row(2, "ExtUtils::Embed","Doug MacEachern");
		perl_info_print_table_row(2, "ExtUtils::Install","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::Installed","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::Liblist","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::Liblist::Kid","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_Any","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_BeOS","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_Cygwin","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_DOS","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_MacOS","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_NW5","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_OS2","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_UWIN","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_Unix","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_VMS","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_Win32","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MM_Win95","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MY","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::MakeMaker","The MakeMaker mailing list");
		perl_info_print_table_row(2, "ExtUtils::MakeMaker::bytes","Nicholas Clark");
		perl_info_print_table_row(2, "ExtUtils::MakeMaker::vmsish","Nicholas Clark");
		perl_info_print_table_row(2, "ExtUtils::Manifest","The MakeMaker mailing list");
		perl_info_print_table_row(2, "ExtUtils::Mkbootstrap","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::Mksymlists","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::Packlist","Michael G Schwern");
		perl_info_print_table_row(2, "ExtUtils::XSSymSet","Nicholas Clark");
		perl_info_print_table_row(2, "ExtUtils::testlib","Michael G Schwern");
		perl_info_print_table_row(2, "Fatal","Nicholas Clark");
		perl_info_print_table_row(2, "Fcntl","Jarkko Hietaniemi");
		perl_info_print_table_row(2, "File::Basename","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "File::CheckTree","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "File::Compare","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "File::Copy","Aaron Sherman");
		perl_info_print_table_row(2, "File::DosGlob","Nicholas Clark");
		perl_info_print_table_row(2, "File::Find","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "File::Glob","Tye McQueen");
		perl_info_print_table_row(2, "File::Path","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "File::Spec","Ken Williams");
		perl_info_print_table_row(2, "File::Spec::Cygwin","Ken Williams");
		perl_info_print_table_row(2, "File::Spec::Epoc","Ken Williams");
		perl_info_print_table_row(2, "File::Spec::Functions","Ken Williams");
		perl_info_print_table_row(2, "File::Spec::Mac","Ken Williams");
		perl_info_print_table_row(2, "File::Spec::OS2","Ken Williams");
		perl_info_print_table_row(2, "File::Spec::Unix","Ken Williams");
		perl_info_print_table_row(2, "File::Spec::VMS","Ken Williams");
		perl_info_print_table_row(2, "File::Spec::Win32","Ken Williams");
		perl_info_print_table_row(2, "File::Temp","Tim Jenness");
		perl_info_print_table_row(2, "File::stat","Tom Christiansen");
		perl_info_print_table_row(2, "FileCache","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "FileHandle","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Filter::Simple","Damian Conway");
		perl_info_print_table_row(2, "Filter::Util::Call","Paul Marquess");
		perl_info_print_table_row(2, "FindBin","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "GDBM_File","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Getopt::Long","Johan Vromans");
		perl_info_print_table_row(2, "Getopt::Std","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Hash::Util","Nicholas Clark");
		perl_info_print_table_row(2, "I18N::Collate","Jarkko Hietaniemi");
		perl_info_print_table_row(2, "I18N::LangTags","Sean M. Burke");
		perl_info_print_table_row(2, "I18N::LangTags::List","Sean M. Burke");
		perl_info_print_table_row(2, "I18N::Langinfo","Nicholas Clark");
		perl_info_print_table_row(2, "IO","Graham Barr");
		perl_info_print_table_row(2, "IO::Dir","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "IO::File","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "IO::Handle","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "IO::Pipe","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "IO::Poll","Graham Barr");
		perl_info_print_table_row(2, "IO::Seekable","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "IO::Select","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "IO::Socket","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "IO::Socket::INET","Graham Barr");
		perl_info_print_table_row(2, "IO::Socket::UNIX","Graham Barr");
		perl_info_print_table_row(2, "IPC::Msg","Graham Barr");
		perl_info_print_table_row(2, "IPC::Open2","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "IPC::Open3","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "IPC::Semaphore","Graham Barr");
		perl_info_print_table_row(2, "IPC::SysV","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "JNI","Nicholas Clark");
		perl_info_print_table_row(2, "JPL::AutoLoader","Nicholas Clark");
		perl_info_print_table_row(2, "JPL::Class","Nicholas Clark");
		perl_info_print_table_row(2, "JPL::Compile","Nicholas Clark");
		perl_info_print_table_row(2, "List::Util","Graham Barr");
		perl_info_print_table_row(2, "Locale::Constants","Neil Bowers");
		perl_info_print_table_row(2, "Locale::Country","Neil Bowers");
		perl_info_print_table_row(2, "Locale::Currency","Neil Bowers");
		perl_info_print_table_row(2, "Locale::Language","Neil Bowers");
		perl_info_print_table_row(2, "Locale::Maketext","Sean M. Burke");
		perl_info_print_table_row(2, "Locale::Maketext::Guts","Sean M. Burke");
		perl_info_print_table_row(2, "Locale::Maketext::GutsLoader","Sean M. Burke");
		perl_info_print_table_row(2, "Locale::Script","Neil Bowers");
		perl_info_print_table_row(2, "MIME::Base64","Gisle Aas");
		perl_info_print_table_row(2, "MIME::QuotedPrint","Gisle Aas");
		perl_info_print_table_row(2, "Math::BigFloat","Tels");
		perl_info_print_table_row(2, "Math::BigFloat::Trace","Tels");
		perl_info_print_table_row(2, "Math::BigInt","Tels");
		perl_info_print_table_row(2, "Math::BigInt::Calc","Tels");
		perl_info_print_table_row(2, "Math::BigInt::CalcEmu","Tels");
		perl_info_print_table_row(2, "Math::BigInt::Trace","Tels");
		perl_info_print_table_row(2, "Math::BigRat","Tels");
		perl_info_print_table_row(2, "Math::Complex","Raphael Manfredi");
		perl_info_print_table_row(2, "Math::Trig","John A.R. Williams");
		perl_info_print_table_row(2, "Memoize","Mark Jason Dominus");
		perl_info_print_table_row(2, "Memoize::AnyDBM_File","Mark Jason Dominus");
		perl_info_print_table_row(2, "Memoize::Expire","Mark Jason Dominus");
		perl_info_print_table_row(2, "Memoize::ExpireFile","Mark Jason Dominus");
		perl_info_print_table_row(2, "Memoize::ExpireTest","Mark Jason Dominus");
		perl_info_print_table_row(2, "Memoize::NDBM_File","Mark Jason Dominus");
		perl_info_print_table_row(2, "Memoize::SDBM_File","Mark Jason Dominus");
		perl_info_print_table_row(2, "Memoize::Storable","Mark Jason Dominus");
		perl_info_print_table_row(2, "NDBM_File","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "NEXT","Damian Conway");
		perl_info_print_table_row(2, "Net::Cmd","Graham Barr");
		perl_info_print_table_row(2, "Net::Config","Graham Barr");
		perl_info_print_table_row(2, "Net::Domain","Graham Barr");
		perl_info_print_table_row(2, "Net::FTP","Graham Barr");
		perl_info_print_table_row(2, "Net::FTP::A","Graham Barr");
		perl_info_print_table_row(2, "Net::FTP::E","Graham Barr");
		perl_info_print_table_row(2, "Net::FTP::I","Graham Barr");
		perl_info_print_table_row(2, "Net::FTP::L","Graham Barr");
		perl_info_print_table_row(2, "Net::FTP::dataconn","Graham Barr");
		perl_info_print_table_row(2, "Net::NNTP","Graham Barr");
		perl_info_print_table_row(2, "Net::Netrc","Graham Barr");
		perl_info_print_table_row(2, "Net::POP3","Graham Barr");
		perl_info_print_table_row(2, "Net::Ping","Rob Brown");
		perl_info_print_table_row(2, "Net::SMTP","Graham Barr");
		perl_info_print_table_row(2, "Net::Time","Graham Barr");
		perl_info_print_table_row(2, "Net::hostent","Tom Christiansen");
		perl_info_print_table_row(2, "Net::netent","Tom Christiansen");
		perl_info_print_table_row(2, "Net::protoent","Tom Christiansen");
		perl_info_print_table_row(2, "Net::servent","Tom Christiansen");
		perl_info_print_table_row(2, "O","Malcolm Beattie");
		perl_info_print_table_row(2, "ODBM_File","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "OS2::DLL","Nicholas Clark");
		perl_info_print_table_row(2, "OS2::ExtAttr","Ilya Zakharevich");
		perl_info_print_table_row(2, "OS2::PrfDB","Ilya Zakharevich");
		perl_info_print_table_row(2, "OS2::Process","Ilya Zakharevich");
		perl_info_print_table_row(2, "OS2::REXX","Ilya Zakharevich");
		perl_info_print_table_row(2, "Opcode","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "POSIX","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "PerlIO","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "PerlIO::encoding","Nicholas Clark");
		perl_info_print_table_row(2, "PerlIO::scalar","Nicholas Clark");
		perl_info_print_table_row(2, "PerlIO::via","Nicholas Clark");
		perl_info_print_table_row(2, "PerlIO::via::QuotedPrint","Elizabeth Mattijsen");
		perl_info_print_table_row(2, "Pod::Checker","Brad Appleton");
		perl_info_print_table_row(2, "Pod::Find","Marek Rouchal");
		perl_info_print_table_row(2, "Pod::Functions","Nicholas Clark");
		perl_info_print_table_row(2, "Pod::Html","Nicholas Clark");
		perl_info_print_table_row(2, "Pod::InputObjects","Marek Rouchal");
		perl_info_print_table_row(2, "Pod::LaTeX","Tim Jenness");
		perl_info_print_table_row(2, "Pod::Man","Kenneth Albanowski");
		perl_info_print_table_row(2, "Pod::ParseLink","Russ Allbery");
		perl_info_print_table_row(2, "Pod::ParseUtils","Marek Rouchal");
		perl_info_print_table_row(2, "Pod::Parser","Brad Appleton");
		perl_info_print_table_row(2, "Pod::Perldoc","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::BaseTo","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::GetOptsOO","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::ToChecker","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::ToMan","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::ToNroff","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::ToPod","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::ToRtf","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::ToText","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::ToTk","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::Perldoc::ToXml","Sean M. Burke");
		perl_info_print_table_row(2, "Pod::PlainText","Marek Rouchal");
		perl_info_print_table_row(2, "Pod::Plainer","Nicholas Clark");
		perl_info_print_table_row(2, "Pod::Select","Brad Appleton");
		perl_info_print_table_row(2, "Pod::Text","Tom Christiansen");
		perl_info_print_table_row(2, "Pod::Text::Color","Russ Allbery");
		perl_info_print_table_row(2, "Pod::Text::Overstrike","Russ Allbery");
		perl_info_print_table_row(2, "Pod::Text::Termcap","Russ Allbery");
		perl_info_print_table_row(2, "Pod::Usage","Brad Appleton");
		perl_info_print_table_row(2, "SDBM_File","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Safe","Malcolm Beattie");
		perl_info_print_table_row(2, "Scalar::Util","Graham Barr");
		perl_info_print_table_row(2, "Search::Dict","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "SelectSaver","Chip Salzenberg");
		perl_info_print_table_row(2, "SelfLoader","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Shell","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Socket","Nathan Torkington");
		perl_info_print_table_row(2, "Storable","Abhijit Menon-Sen");
		perl_info_print_table_row(2, "Switch","Rafael Garcia-Suarez");
		perl_info_print_table_row(2, "Symbol","Chip Salzenberg");
		perl_info_print_table_row(2, "Sys::Hostname","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Sys::Syslog","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Term::ANSIColor","Russ Allbery");
		perl_info_print_table_row(2, "Term::Cap","Tony Sanders");
		perl_info_print_table_row(2, "Term::Complete","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Term::ReadLine","Ilya Zakharevich");
		perl_info_print_table_row(2, "Test","Sean M. Burke");
		perl_info_print_table_row(2, "Test::Builder","Michael G Schwern");
		perl_info_print_table_row(2, "Test::Harness","Andy Lester");
		perl_info_print_table_row(2, "Test::Harness::Assert","Andy Lester");
		perl_info_print_table_row(2, "Test::Harness::Iterator","Andy Lester");
		perl_info_print_table_row(2, "Test::Harness::Straps","Andy Lester");
		perl_info_print_table_row(2, "Test::More","Michael G Schwern");
		perl_info_print_table_row(2, "Test::Simple","Michael G Schwern");
		perl_info_print_table_row(2, "Text::Abbrev","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Text::Balanced","David Manura");
		perl_info_print_table_row(2, "Text::ParseWords","Hal Pomeranz");
		perl_info_print_table_row(2, "Text::Soundex","Mark Mielke");
		perl_info_print_table_row(2, "Text::Tabs","David Muir Sharnoff");
		perl_info_print_table_row(2, "Text::Wrap","David Muir Sharnoff");
		perl_info_print_table_row(2, "Thread","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Thread::Queue","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Thread::Semaphore","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Thread::Signal","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Thread::Specific","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Tie::Array","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Tie::File","Mark Jason Dominus");
		perl_info_print_table_row(2, "Tie::Handle","Steffen Beyer");
		perl_info_print_table_row(2, "Tie::Hash","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Tie::Memoize","Nicholas Clark");
		perl_info_print_table_row(2, "Tie::RefHash","Nicholas Clark");
		perl_info_print_table_row(2, "Tie::Scalar","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Tie::SubstrHash","Larry Wall. Author of Perl. Busy man.");
		perl_info_print_table_row(2, "Time::HiRes","Jarkko Hietaniemi");
		perl_info_print_table_row(2, "Time::Local","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Time::gmtime","Tom Christiansen");
		perl_info_print_table_row(2, "Time::localtime","Tom Christiansen");
		perl_info_print_table_row(2, "Time::tm","Nicholas Clark");
		perl_info_print_table_row(2, "UNIVERSAL","The Perl5 Porters Mailing List");
		perl_info_print_table_row(2, "Unicode::Collate","SADAHIRO Tomoyuki");
		perl_info_print_table_row(2, "Unicode::Normalize","SADAHIRO Tomoyuki");
		perl_info_print_table_row(2, "Unicode::UCD","Nicholas Clark");
		perl_info_print_table_row(2, "User::grent","Tom Christiansen");
		perl_info_print_table_row(2, "User::pwent","Tom Christiansen");
		perl_info_print_table_row(2, "VMS::DCLsym","Nicholas Clark");
		perl_info_print_table_row(2, "VMS::Filespec","Charles Bailey");
		perl_info_print_table_row(2, "VMS::Stdio","Nicholas Clark");
		perl_info_print_table_row(2, "XS::APItest","Nicholas Clark");
		perl_info_print_table_row(2, "XS::Typemap","Nicholas Clark");
		perl_info_print_table_row(2, "base","Michael G Schwern");
		perl_info_print_table_row(2, "bigint","Tels");
		perl_info_print_table_row(2, "bignum","Tels");
		perl_info_print_table_row(2, "bigrat","Tels");
		perl_info_print_table_row(2, "encoding","Dan Kogai");
		perl_info_print_table_row(2, "fields","Michael G Schwern");
		perl_info_print_table_row(2, "if","Ilya Zakharevich");
		perl_info_print_table_end();
	
		# Perldoc
		perl_info_print_table_start();
		perl_info_print_table_colspan_header(2, "Perl Documentation");
		perl_info_print_table_row(2, "Perldoc maintainer", "Sean M. Burke");
		perl_info_print_table_row(2, "Past Perldoc contributers", "Kenneth Albanowski, Andy Dougherty, and many others");
		perl_info_print_table_end();

		# CPAN 
		perl_info_print_table_start();
		perl_info_print_table_header(1, "CPAN Maintainer");
		perl_info_print_table_row(1, "Jarkko Hietaniemi");
		perl_info_print_table_end();

		# Website Team 
		perl_info_print_table_start();
		perl_info_print_table_header(1, "Perl Website Team");
		perl_info_print_table_row(1, "Lisa Wolfisch, Robert Spier, and Ask Bjoern Hansen");
		perl_info_print_table_end();

  }

 sub  perl_info_print_table_colspan_header {
  
   	 printf("<tr class=\"h\"><th colspan=\"%d\">%s</th></tr>\n", $_[0], $_[1]);  

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

  sub perl_info_print_script {
   	print "<SCRIPT LANGUAGE=\"JavaScript\">\n<!--\n function showcredits () {\n";

	my $str;
 	my $io = tie *STDOUT, 'IO::Scalar', \$str;
        perl_info_print_htmlhead();
	perl_info_print_credits();
        print "<form><input type='submit' value='close window' onclick='window.close(); return false;'></form>"; 	
        print "</div></body></html>";	
	undef $io;
	untie *STDOUT;
	$str =~ s/"/\\"/g;
	my @arr = split /\n/, $str;
        print "contents=\"$arr[0]\";";
	shift(@arr);
        print "\ncontents+= \"$_\";" for @arr;
        print <<'END_OF_HTML'; 
    	
        Win1=window.open( '' , 'Window1' , 'location=yes,toolbar=yes,menubar=yes,directories=yes,status=yes,resizable=yes,scrollbars=yes'); 
	Win1.moveTo(0,0);
        Win1.resizeTo(screen.width,screen.height);
    	Win1.document.writeln(contents);
	Win1.document.close();
    	}	    
   	//--></SCRIPT>
END_OF_HTML

  } 
  sub perl_info_print_style {
	  print "<style type=\"text/css\"><!--\n";
	  perl_info_print_css();
	  print "//--></style>\n";
  }


  sub perl_info_print_htmlhead {
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

	  perl_info_print_htmlhead();
	  perl_info_print_script() if ($flag =~ /INFO_ALL/);
	  perl_info_print_credits() if ($flag =~ /INFO_CREDITS/);
	  
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
		  <noscript>Enable JavaScript to see the credits. 
		  Alternatively you can use perlinfo(INFO_CREDITS) and perlinfo(INFO_GENERAL). 
		  </noscript>
		  </h1>
END_OF_HTML
		  perl_info_print_hr();
 		}		  
	   
           perl_info_print_credits() if ($flag =~ /INFO_GENERAL/);
		
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

It is based on PHP's phpinfo function. Like other clones of PHP functions on CPAN, perlinfo attempts to mimic the PHP function is as many ways as possible. But, of course, there are some differences in the Perl version. These differences will be logged in future revisions.

PHP's phpinfo function is usually one of the first things a new PHP programmer learns. It is a very useful function for debugging and checking configuration settings. I expect that many users of this module will already know PHP's phpinfo. To familiarize yourself with phpinfo, you can google "phpinfo" and see the output for phpinfo in one of the many results. (I rather not provide a link that can go bad with the passage of time.)

You can also read the description of the original PHP version:

L<http://www.php.net/manual/en/function.phpinfo.php>

=head1 OPTIONS

There are 6 options. More to come.

=over

=item INFO_GENERAL

The configuration line, build date, Web Server, System and more.

=item INFO_LICENSE 

Perl license information.

=item INFO_MODULES 

Local modules, their version number and more.

=item INFO_VARIABLES 

Shows all predefined variables from EGPCS (Environment, GET, POST, Cookie, Server). This is not fully implemented yet.   

=item INFO_CREDITS

Shows the credits for Perl, listing the Perl pumpkings, developers, module authors, etc. 

Note: This is equivalent to the default output of PHP's phpcredits function. Whereas PHP puts the credits information in a separate function, I have decided to include it in the info function for Perl.    

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

Every effort has been made to ensure compatibility with older versions of Perl 5.   

This is an early release of this module and it lacks many important features in the PHP version. These 
features are not hard to implement but finding the time to add them is. Help wanted! Please 
email me if you want to help out. Thanks.

=head1 AUTHOR

Mike Accardo <mikeaccardo@yahoo.com>

=head1 COPYRIGHT

   Copyright (c) 2004, Mike Accardo. All Rights Reserved.
 This module is free software. It may be used, redistributed
and/or modified under the terms of the Perl Artistic License.

=cut
