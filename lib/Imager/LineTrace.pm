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

Imager::LineTrace - これは画像中の直線をトレースするモジュールです

=head1 SYNOPSIS

    # from Sample/bmp2figure.pl
    use Imager::LineTrace;

    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0] );

    my $i = 0;
    foreach my $figure (@{$figures_ref}) {
        print "-------- [", $i++, "] --------", "\n";
        print "trace_value: ", $figure->{value}, "\n";
        print "is_close: ", $figure->{is_close}, "\n";
        foreach my $p (@{$figure->{points}}) {
            printf( "(%2d,%2d)\n", $p->[0], $p->[1] );
        }
    }

=head1 DESCRIPTION

左下を原点として、反時計周りにトレースを行います。

    # 白地に黒でラインが描かれている場合は、以下のように記述します
    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0] );

    # R, G, B, Alpha のうち、どの要素をトレースするか指定できます
    # channels には、 0:R, 1:G, 2:B, 3:Alpha のいずれか1つを指定します
    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0], channels => [0] );

    # 白地じゃない場合は、背景色を指定します
    # 背景色のうち channels で指定した要素の値を ignore に指定します
    # 背景色が黒で、黒以外の色をトレースするときは、以下のように記述します
    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0], ignore => 0 );

    # デフォルトでトレースできる形状の数は 1024 です
    # たくさんの形状をトレースしたい場合は、以下のように limit を指定します
    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0], limit => 10000 );

=head1 LICENSE

Copyright (C) neko.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

neko E<lt>techno.cat.miau@gmail.comE<gt>

=cut

