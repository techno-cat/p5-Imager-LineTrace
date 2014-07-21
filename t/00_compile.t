use strict;
use Test::More 0.98;
use Test::Exception;

use_ok $_ for qw(
    Imager::LineTrace
);

throws_ok( sub {
    Imager::LineTrace::trace( file => 'unreadable' );
}, qr//, 'file not exists.' );

{
    my $color = Imager::Color->new( 1, 2, 3, 4 );
    my $img = Imager::LineTrace->new( xsize => 1, ysize => 1, channels => 4 );
    $img->setpixel( x => 0, y => 0, color => $color);

    {
        my $figures_ref = $img->linetrace( channels => [0] );
        is $figures_ref->[0]->{value}, 1, 'use channels.';
    }
    {
        my $figures_ref = $img->linetrace( channels => [1] );
        is $figures_ref->[0]->{value}, 2, 'use channels.';
    }
    {
        my $figures_ref = $img->linetrace( channels => [2] );
        is $figures_ref->[0]->{value}, 3, 'use channels.';
    }
    {
        my $figures_ref = $img->linetrace( channels => [3] );
        is $figures_ref->[0]->{value}, 4, 'use channels.';
    }
}

{
    my $img = Imager::LineTrace->new( xsize => 3, ysize => 3, channels => 4 );
    $img->box( filled => 1, color => 'white' );
    $img->polyline( color => 'black', points => [[0, 0], [2, 0], [2, 2]] );

    {
        my $figures_ref = $img->linetrace();

        my @expected = (
            [ 0, 0 ],
            [ 2, 0 ],
            [ 2, 2 ],
        );
        is_deeply $figures_ref->[0]->{points}, \@expected, "Trace clockwise.";
    }

    $img->flip( dir => 'v' );
    {
        my $figures_ref = $img->linetrace();

        my @expected = (
            [ 2, 0 ],
            [ 2, 2 ],
            [ 0, 2 ],
        );
        is_deeply $figures_ref->[0]->{points}, \@expected, "Trace counter-clockwise.";
    }
}

{
    my $img = Imager::LineTrace->new( xsize => 3, ysize => 3, channels => 4 );
    $img->box( filled => 1, color => 'black' );
    $img->polyline( color => 'white', points => [[0, 0], [2, 0], [2, 2]] );

    {
        my $figures_ref = $img->linetrace( ignore => 0 );

        my @expected = (
            [ 0, 0 ],
            [ 2, 0 ],
            [ 2, 2 ],
        );
        is_deeply $figures_ref->[0]->{points}, \@expected, "Trace white line on black.";
    }
}


done_testing;
