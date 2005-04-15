package EPEG;

use 5.006;
use strict;
use warnings;
use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA = qw(Exporter DynaLoader);
our %EXPORT_TAGS = ( 'constants' => [ qw(MAINTAIN_ASPECT_RATIO IGNORE_ASPECT_RATIO) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'constants'} } );
our @EXPORT = qw();
our $VERSION = '0.01';

bootstrap EPEG $VERSION;

use constant MAINTAIN_ASPECT_RATIO => 1;
use constant IGNORE_ASPECT_RATIO => 2;

sub new
{
	my $class = shift;
	my $self = { img => undef };
	return bless $self, $class;
}


sub img		{ return $_[0]->{ img }; }
sub height	{ return $_[0]->{ height }; }
sub width	{ return $_[0]->{ width }; }


sub open_file
{
	my $self = shift;
	my $path = shift;
	$self->{ img } = EPEG::epeg_file_open( $path );
}


sub open_data
{
	my $self = shift;
	my $data = shift;
	$self->{ img } = epeg_memory_open( $data, length($data) );
}


sub get_height
{
	my $self = shift;
	$self->_init_size() unless( $self->height );
	return $self->height;
}


sub get_width
{
	my $self = shift;
	$self->_init_size() unless( $self->width );
	return $self->width;
}


sub _init_size
{
	my $self = shift; 
	($self->{ width }, $self->{ height }) =
		EPEG::epeg_size_get( $self->img );
}


sub set_quality
{
	my $self = shift;
	my $quality = shift;
	EPEG::epeg_quality_set( $self->img, $quality );
}


sub resize
{
	my $self = shift;
	my $width = shift;
	my $height = shift;
	my $aspect_ratio_mode = shift || IGNORE_ASPECT_RATIO;
	
	# ignore the aspect ratio
	if( $aspect_ratio_mode == IGNORE_ASPECT_RATIO )
	{
		EPEG::epeg_decode_size_set( $self->img, $width, $height );
		return 1;
	}

	# maintain the aspect ratio
	my ($w, $h) = ($self->get_width(), $self->get_height());
	my ($new_w, $new_h) = (0, 0);

	if( $w * $height > $h * $height )
	{
		$new_w = $width;
		$new_h = $height * $h / $w;
	}
	else
	{
		$new_h = $height;
		$new_w = $width * $w / $h;
	}

	EPEG::epeg_decode_size_set( $self->img, $new_w, $new_h );
	return 1;
}


sub get_data
{
	my $self = shift;
	my $data = EPEG::epeg_get_data( $self->img );
	EPEG::epeg_close( $self->img );
	return $data; 
}


sub write_file
{
	my $self = shift;
	my $path = shift;
	EPEG::epeg_write_file( $self->img, $path );
	EPEG::epeg_close( $self->img );
	return 1;
}


1;

__END__


=head1 NAME

EPEG - Perl extension for EPEG

=head1 SYNOPSIS

  use EPEG qw(:constants);
  my $epg = new EPEG;
  $epg->open_file( "test.jpg" );
  $epg->resize( 150, 150, MAINTAIN_ASPECT_RATIO );
  $epg->save( "test_resized.jpg" );

=head1 DESCRIPTION

Perl wrapper to the alarmingly fast jpeg manipulation library "Epeg".

=head2 Methods

=over 4

=item * new()

=item * open_file( FILENAME ) 

=item * open_data( DATA )

=item * get_height()

=item * get_width()

=item * set_quality( [0-100] )

=item * resize( WIDTH, HEIGHT, [Aspect Ratio Mode] )

=item * save( FILENAME )

=back

=head1 AUTHOR

Michael Curtis &lt;mcurtis@yahoo-inc.com&gt;

=head1 SEE ALSO

http://gatekeeper.dec.com/pub/BSD/NetBSD/NetBSD-current/pkgsrc/graphics/epeg/README.html

=cut
