use strict;
use Test::More 0.98;

use_ok $_ for qw(
    Imager::LineTrace::Algorithm
);

# トレースアルゴリズムのテスト

{
    my @pixels = (
        [ 0, 0, 0 ],
        [ 0, 0, 0 ],
        [ 0, 0, 0 ]
    );

    my %args = ( ignore => 0 );
    my $figures = Imager::LineTrace::Algorithm::search( \@pixels, \%args );

    ok scalar(@{$figures}) == 0, "figure not exists."
}

{
    my @pixels = (
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

    is_deeply $figure->{points}, \@expected, "test points.";
}

done_testing;

