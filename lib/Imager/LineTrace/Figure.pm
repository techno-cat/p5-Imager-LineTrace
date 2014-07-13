package Imager::LineTrace::Figure;
use 5.008001;
use strict;
use warnings;

sub new {
    my $pkg = shift;
    my $args_ref = shift;

    my @points = map {
        bless $_, 'Imager::LineTrace::Point';
    } @{$args_ref->{points}};

    my $type = "Undefined";
    if ( $args_ref->{is_close} ) {
        $type = "Polygon";
    }
    elsif ( 3 <= scalar(@points) ) {
        $type = "Polyline";
    }
    elsif ( 2 <= scalar(@points) ) {
        $type = "Line";
    }
    else {
        $type = "Point";
    }

    bless {
        points   => \@points,
        is_close => $args_ref->{is_close},
        value    => $args_ref->{value},
        type     => $type
    }, $pkg;
}

1;
