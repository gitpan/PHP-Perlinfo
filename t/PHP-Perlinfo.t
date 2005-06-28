# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl PHP-Perlinfo.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 1 };
use PHP::Perlinfo;
use IO::Scalar;
use Module::CoreList;
#########################

# Difficult to conduct testing here due to nature of perlinfo


ok ( test_01() );
ok ( test_02() );
ok ( test_03() );

sub test_01 {

$p = new PHP::Perlinfo;
$p->bg_image("yukiko.jpg");

return 0 if ($@);
return 1;
}

sub test_02 {

my $str;
my $io = tie *STDOUT, 'IO::Scalar', \$str;
print $Module::CoreList::released($]);
undef $io;
untie *STDOUT;

}

sub test_03 {

my $str;
my $io = tie *STDOUT, 'IO::Scalar', \$str;
perlinfo(INFO_APACHE);
undef $io;
untie *STDOUT;

}

