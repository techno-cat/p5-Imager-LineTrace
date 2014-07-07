package Imager::LineTrace;
use 5.008001;
use strict;
use warnings;
use Imager::LineTrace::Algorithm;
use Imager;


our $VERSION = "0.01";

sub trace {
    my %args = @_;

    if ( not exists $args{file} ) {
        die 'file => "file_path" is required';
    }

    my $img = Imager->new( file => $args{file} ) or die Imager->errstr;

    my $channels = [ 0 ];
    if ( exists $args{channels} and scalar(@{$args{channels}}) == 1 ) {
        $channels = $args{channels};
    }

    my @pixels = ();
    my $h = $img->getheight();
    for (my $iy=0; $iy<$h; $iy++) {
        my $ary_ref = $img->getsamples( y => $iy, channels => $channels );
        my @wk = unpack( "C*", $ary_ref );
        push @pixels, \@wk;
    }

    # 左下を原点にしたいので反転
    @pixels = reverse @pixels;

    return Imager::LineTrace::Algorithm::search( \@pixels, \%args );
}

1;
__END__

=encoding utf-8

=head1 NAME

Imager::LineTrace - It's new $module

=head1 SYNOPSIS

    use Imager::LineTrace;

=head1 DESCRIPTION

Imager::LineTrace is ...

=head1 LICENSE

Copyright (C) neko.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

neko E<lt>techno.cat.miau@gmail.comE<gt>

=cut

