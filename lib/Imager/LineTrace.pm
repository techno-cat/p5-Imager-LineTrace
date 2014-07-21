package Imager::LineTrace;
use 5.008001;
use strict;
use warnings;

use base qw(Imager);

use Imager::LineTrace::Algorithm;
use Imager::LineTrace::Figure;

our $VERSION = "0.03";

sub linetrace {
    my $self = shift;
    my %args = @_;

    my $channels = [ 0, 1, 2 ];
    if ( exists $args{channels} ) {
        $channels = $args{channels};
    }

    my $number_of_channels = scalar( @{$channels} );
    my $ymax = $self->getheight() - 1;
    my @pixels = map {
        my $iy = $_;

        my $ary_ref = $self->getsamples( y => $iy, channels => $channels );
        my @wk = ();
        if ( @{$channels} == 3 ) {
            my @tmp = unpack( "C*", $ary_ref );
            while ( @tmp ) {
                my $val = shift @tmp;
                $val = ($val << 8) + shift @tmp;
                $val = ($val << 8) + shift @tmp;
                push @wk, $val;
            }
        }
        elsif ( @{$channels} == 2 ) {
            @wk = unpack( "S*", $ary_ref );
        }
        else {
            @wk = unpack( "C*", $ary_ref );
        }

        \@wk;
    } 0..$ymax;

    if ( not exists $args{ignore} ) {
        if ( @{$channels} == 3 ) {
            $args{ignore} = 0xFFFFFF;
        }
        elsif ( @{$channels} == 2 ) {
            $args{ignore} = 0xFFFF;
        }
        else {
            $args{ignore} = 0xFF;
        }
    }

    my $results = Imager::LineTrace::Algorithm::search( \@pixels, \%args );
    my @figures = map {
        Imager::LineTrace::Figure->new( $_ );
    } @{$results};

    return \@figures;
}

1;
__END__

=encoding utf-8

=head1 NAME

Imager::LineTrace - Line tracer

=head1 SYNOPSIS

    # from Sample/bmp2figure.pl
    use Imager::LineTrace;

    my $img = Imager::LineTrace->new( file => $ARGV[0] ) or die Imager->errstr;
    my $figures_ref = $img->linetrace();

    my $i = 0;
    foreach my $figure (@{$figures_ref}) {
        print "-------- [", $i++, "] --------", "\n";
        print "type        : ", $figure->{type}, "\n";
        print "trace_value : ", sprintf("0x%06X", $figure->{value}), "\n";
        print "is_close: ", $figure->{is_closed}, "\n";
        foreach my $p (@{$figure->{points}}) {
            printf( "(%2d,%2d)\n", $p->[0], $p->[1] );
        }
    }

=head1 DESCRIPTION

    # Tracing clockwise from left top.

Basic Overview

    my $img = Imager::LineTrace->new( file => $path ) or die Imager->errstr;

    # Trace black line on white.
    my $figures_ref = $img->linetrace();

    # If you want to trace counter-clockwise from left bottom.
    $img->filp( dir => 'v' );
    my $figures_ref = $img->linetrace();

    # If you want to select color. ( 0:R, 1:G, 2:B, 3:Alpha )
    my $figures_ref = $img->linetrace( channels => [0] );

    # Or you want to trace with R,G and B.(this is defalt.)
    my $figures_ref = $img->linetrace( channels => [0,1,2] );

    # If you want to trace not black color.
    my $figures_ref = $img->linetrace( ignore => 0 );

    # If you want to trace many figure. (default "limit" is 1024)
    my $figures_ref = $img->linetrace( limit => 10000 );

=head1 LICENSE

Copyright (C) neko.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

neko E<lt>techno.cat.miau@gmail.comE<gt>

=cut

