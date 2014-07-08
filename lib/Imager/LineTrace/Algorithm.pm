package Imager::LineTrace::Algorithm;
use 5.008001;
use strict;
use warnings;

sub search {
    my ( $pixels_ref, $opt ) = @_;
    my $ignore = ( exists $opt->{ignore} ) ? $opt->{ignore} : 255;
    my $limit = ( exists $opt->{limit} ) ? $opt->{limit} : 1024;

    my $w = scalar(@{$pixels_ref->[0]});
    my $h = scalar(@{$pixels_ref});

    my @figures = ();
    my $y0 = 0;
    foreach my $point_number (1..16) { # todo: $limitで置き換え！
        my ( $x, $y ) = ( -1, -1 );

        for (my $iy=$y0; $iy<$h; $iy++) {
            my $i = 0;
            #say "iy = $iy";
            foreach my $val (@{$pixels_ref->[$iy]}) {
                if ( $val != $ignore ) {
                    #say "here!!!!!!!!!!!!!";
                    $x = $i;
                    $y = $iy;
                    last;
                }
                $i++;
            }

            last if 0 <= $y;
            $y0 = $iy + 1;
        }

        if ( $y < 0 ) {
            print 'comp!', "\n";
            last;
        }

        my $x0 = $x;
        my $y0 = $y;
        my $trace_value = $pixels_ref->[$y][$x];

        # 探索開始点は図形の左下なので、
        # 上方向の点がなければ閉じていないと判断できる
        my $is_close = 0;
        if ( $y0 < ($h - 1) ) {
            $is_close = ( $pixels_ref->[$y + 1][$x] != $ignore );
            if ( $is_close ) {
                # 最後の探索が開始点に到達できるように残しておく
            }
            else {
                # 閉じた図形ではないので、探索済みの処理をする
                $pixels_ref->[$y][$x] = $ignore;
            }
        }

        my @points = ( [$x, $y] );
        my $search_comp = 0;
        while ( not $search_comp ) {
            my $number_of_points = scalar( @points );

            # 右方向に探索
            if ( ($x + 1) < $w and $pixels_ref->[$y][$x + 1] == $trace_value ) {
                while ( $pixels_ref->[$y][$x + 1] == $trace_value ) {
                    $x++;
                    $pixels_ref->[$y][$x] = $ignore;
                    last if $w <= ($x + 1);
                }

                push @points, [ $x, $y ];
            }

            # 上方向に探索
            if ( ($y + 1) < $h and $pixels_ref->[$y + 1][$x] == $trace_value ) {
                while ( $pixels_ref->[$y + 1][$x] == $trace_value ) {
                    $y++;
                    $pixels_ref->[$y][$x] = $ignore;
                    last if $h <= ($y + 1);
                }

                push @points, [ $x, $y ];
            }

            # 左方向に探索
            if ( 0 < ($x - 1) and $pixels_ref->[$y][$x - 1] == $trace_value ) {
                while ( $pixels_ref->[$y][$x - 1] == $trace_value ) {
                    $x--;
                    $pixels_ref->[$y][$x] = $ignore;
                    last if ($x - 1) < 0;
                }

                push @points, [ $x, $y ];
            }

            # 下方向に探索
            if ( 0 < ($y - 1) and $pixels_ref->[$y - 1][$x] == $trace_value ) {
                while ( $pixels_ref->[$y - 1][$x] == $trace_value ) {
                    $y--;
                    $pixels_ref->[$y][$x] = $ignore;
                    last if ($y - 1) < 0;
                }

                if ( $is_close ) {
                    # 開始点に到達したか判定
                    $search_comp = 1 if ( $x == $x0 and $y == $y0 );
                    if ( not $search_comp ) {
                        push @points, [ $x, $y ];
                    }
                }
                else {
                    push @points, [ $x, $y ];
                }
            }

            # 探索前と頂点を比較することで完了したか判定
            $search_comp = 1 if $number_of_points == scalar( @points );
        }

        # todo: 適切なクラスかデータ構造に変換する
        push @figures, +{
            points => \@points,
            is_close => $is_close,
            value => $trace_value
        };
    }

    return \@figures;
}

1;
__END__

=encoding utf-8

=head1 NAME

Imager::LineTrace - It's new $module

=head1 SYNOPSIS

    use Imager::LineTrace::Algorithm;

=head1 DESCRIPTION

Imager::LineTrace::Algorithm is ...

=head1 LICENSE

Copyright (C) neko.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

neko E<lt>techno.cat.miau@gmail.comE<gt>

=cut
