package Imager::LineTrace;
use 5.008001;
use strict;
use warnings;
use Imager;
use Imager::LineTrace::Algorithm;
use Imager::LineTrace::Figure;

our $VERSION = "0.01";

sub trace {
    my %args = @_;
    my $img = _get_image( %args );

    my $channels = [ 0 ];
    if ( exists $args{channels} and scalar(@{$args{channels}}) == 1 ) {
        $channels = $args{channels};
    }

    # 左下が原点になるように格納
    my @pixels = ();
    my $iy = $img->getheight();
    while ( 0 < $iy-- ) {
        my $ary_ref = $img->getsamples( y => $iy, channels => $channels );
        my @wk = unpack( "C*", $ary_ref );
        push @pixels, \@wk;
    }

    my $results = Imager::LineTrace::Algorithm::search( \@pixels, \%args );
    my @figures = map {
        Imager::LineTrace::Figure->new( $_ );
    } @{$results};

    return \@figures;
}

sub _get_image {
    my %args = @_;

    my $img;
    if ( exists $args{file} ) {
        Imager->new( file => $args{file} ) or die Imager->errstr;
    }
    elsif ( exists $args{image} ) {
        $args{image};
    }
    else {
        die '"file" or "image" is required';
    }
}

1;

__END__

=encoding utf-8

=head1 NAME

Imager::LineTrace - Line tracer

=head1 SYNOPSIS

    # from Sample/bmp2figure.pl
    use Imager::LineTrace;

    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0] );

    my $i = 0;
    foreach my $figure (@{$figures_ref}) {
        print "-------- [", $i++, "] --------", "\n";
        print "type        :", $figure->{type}, "\n";
        print "trace_value: ", $figure->{value}, "\n";
        print "is_close: ", $figure->{is_closed}, "\n";
        foreach my $p (@{$figure->{points}}) {
            printf( "(%2d,%2d)\n", $p->[0], $p->[1] );
        }
    }

=head1 DESCRIPTION

    # The origin is at the lower left, I will do the trace counter-clockwise

Basic Overview

    # Trace image file
    my $figures_ref = Imager::LineTrace::trace( file => $path );

    # Trace imager object.
    my $img = Imager->new( file => $path ) or die Imager->errstr;
    my $figures_ref = Imager::LineTrace::trace( image => $img );

    # If the line is drawn in black on a white background.
    my $figures_ref = Imager::LineTrace::trace( file => $path );

    # If you want to select color. ( 0:R, 1:G, 2:B, 3:Alpha )
    my $figures_ref = Imager::LineTrace::trace( file => $path, channels => [0] );

    # If you want to trace not black color.
    my $figures_ref = Imager::LineTrace::trace( file => $path, ignore => 0 );

    # If you want to trace many figure. (default "limit" is 1024)
    my $figures_ref = Imager::LineTrace::trace( file => $path, limit => 10000 );

=head1 LICENSE

Copyright (C) neko.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

neko E<lt>techno.cat.miau@gmail.comE<gt>

=cut

