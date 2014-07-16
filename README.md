# NAME

Imager::LineTrace - Line tracer

# SYNOPSIS

    # from Sample/bmp2figure.pl
    use Imager::LineTrace;

    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0] );

    my $i = 0;
    foreach my $figure (@{$figures_ref}) {
        print "-------- [", $i++, "] --------", "\n";
        print "type        :", $figure->{type}, "\n";
        print "trace_value : ", sprintf("0x%06X", $figure->{value}), "\n";
        print "is_close: ", $figure->{is_closed}, "\n";
        foreach my $p (@{$figure->{points}}) {
            printf( "(%2d,%2d)\n", $p->[0], $p->[1] );
        }
    }

# DESCRIPTION

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

    # Or you want to trace with R,G and B.(this is defalt.)
    my $figures_ref = Imager::LineTrace::trace( file => $path, channels => [0,1,2] );

    # If you want to trace not black color.
    my $figures_ref = Imager::LineTrace::trace( file => $path, ignore => 0 );

    # If you want to trace many figure. (default "limit" is 1024)
    my $figures_ref = Imager::LineTrace::trace( file => $path, limit => 10000 );

# LICENSE

Copyright (C) neko.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

neko <techno.cat.miau@gmail.com>
