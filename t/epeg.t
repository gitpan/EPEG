#!/home/y/bin/perl -w

use strict;
use EPEG qw(:constants);

my $epeg = new EPEG;
my @i = stat( "t/test.jpg" );
my $rawimgsize = $i[7];

print "1..4\n";

$epeg->open_file( "t/test.jpg" );

# Test 1: get_width()
print $epeg->get_width() == 640 ? "ok\n" : "nok\n";

# Test 2: get_height()
print $epeg->get_height() == 480 ? "ok\n" : "nok\n";

# resize() setup
$epeg->resize( 150, 150, MAINTAIN_ASPECT_RATIO );

# Test 3: save();
$epeg->write_file( "t/test2.jpg" );
print -f "t/test2.jpg" ? "ok\n" : "nok\n";

# Test 4: Expected size? 
@i = stat( "t/test2.jpg" );
print $i[7] == 2848 ? "ok\n" : "nok\n";

exit 0;
