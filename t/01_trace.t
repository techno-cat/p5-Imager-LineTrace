use strict;
use Test::More 0.98;

use_ok $_ for qw(
    Imager::LineTrace::Algorithm
);

{
    my @pixels = reverse (
        [ 0 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );

    ok scalar(@{$figures}) == 0, "figure not found.";
}

{
    my @pixels = reverse (
        [ 1 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );
    ok scalar(@{$figures}) == 1, "figure found.";

    my $figure = $figures->[0];
    is $figure->{is_close}, 0, "is not close.";

    my @expected = (
        [ 0, 0 ]
    );
    is_deeply $figure->{points}, \@expected, "figure is point.";
}

{
    my @pixels = reverse (
        [ 0, 0, 0 ],
        [ 0, 0, 0 ],
        [ 1, 1, 1 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );
    ok scalar(@{$figures}) == 1, "figure found.";

    my $figure = $figures->[0];
    is $figure->{is_close}, 0, "is not close.";

    my @expected = (
        [ 0, 0 ],
        [ 2, 0 ]
    );
    is_deeply $figure->{points}, \@expected, "figure is line.";
}

{
    my @pixels = reverse (
        [ 0, 0, 1 ],
        [ 0, 0, 1 ],
        [ 1, 1, 1 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );
    ok scalar(@{$figures}) == 1, "figure found.";

    my $figure = $figures->[0];
    is $figure->{is_close}, 0, "is not close.";

    my @expected = (
        [ 0, 0 ],
        [ 2, 0 ],
        [ 2, 2 ]
    );
    is_deeply $figure->{points}, \@expected, "figure is polyline.";
}

{
    my @pixels = reverse (
        [ 1, 1, 1 ],
        [ 1, 0, 1 ],
        [ 1, 1, 1 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );

    ok scalar(@{$figures}) == 1, "figure found.";

    my $figure = $figures->[0];
    is $figure->{is_close}, 1, "is close.";

    my @expected = (
        [ 0, 0 ],
        [ 2, 0 ],
        [ 2, 2 ],
        [ 0, 2 ]
    );
    is_deeply $figure->{points}, \@expected, "figure is polygon.";
}

{
    my @pixels = reverse (
        [ 1, 1, 1 ],
        [ 1, 0, 1 ],
        [ 1, 0, 1 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );

    ok scalar(@{$figures}) == 1, "figure found.";

    my $figure = $figures->[0];
    is $figure->{is_close}, 0, "is not close.";

    my @expected = (
        [ 0, 0 ],
        [ 0, 2 ],
        [ 2, 2 ],
        [ 2, 0 ]
    );
    is_deeply $figure->{points}, \@expected, "figure is polyline.";
}

{
    my @pixels = reverse (
        [ 1, 1, 1 ],
        [ 1, 0, 0 ],
        [ 1, 1, 1 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );

    ok scalar(@{$figures}) == 1, "figure found.";

    my $figure = $figures->[0];
    is $figure->{is_close}, 0, "is not close.";

    my @expected = (
        [ 2, 0 ],
        [ 0, 0 ],
        [ 0, 2 ],
        [ 2, 2 ]
    );
    is_deeply $figure->{points}, \@expected, "figure is polyline.";
}

{
    my @pixels = reverse (
        [ 1, 1, 1 ],
        [ 0, 0, 0 ],
        [ 1, 1, 1 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );

    ok scalar(@{$figures}) == 2, "figure found.";

    {
        my $figure = $figures->[0];
        is $figure->{is_close}, 0, "is not close.";

        my @expected = (
            [ 0, 0 ],
            [ 2, 0 ]
        );
        is_deeply $figure->{points}, \@expected, "figure is line.";
    }
    {
        my $figure = $figures->[1];
        is $figure->{is_close}, 0, "is not close.";

        my @expected = (
            [ 0, 2 ],
            [ 2, 2 ]
        );
        is_deeply $figure->{points}, \@expected, "figure is line.";
    }
}

{
    my @pixels = reverse (
        [ 3, 4 ],
        [ 1, 2 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );

    ok scalar(@{$figures}) == 4, "figure found.";

    {
        my @expected = ( [ 0, 0 ] );
        is_deeply $figures->[0]->{points}, \@expected, "figure is point.";
        is $figures->[0]->{value}, 1, "trace value.";
    }
    {
        my @expected = ( [ 1, 0 ] );
        is_deeply $figures->[1]->{points}, \@expected, "figure is point.";
        is $figures->[1]->{value}, 2, "trace value.";
    }
    {
        my @expected = ( [ 0, 1 ] );
        is_deeply $figures->[2]->{points}, \@expected, "figure is point.";
        is $figures->[2]->{value}, 3, "trace value.";
    }
    {
        my @expected = ( [ 1, 1 ] );
        is_deeply $figures->[3]->{points}, \@expected, "figure is point.";
        is $figures->[3]->{value}, 4, "trace value.";
    }
}

done_testing;

