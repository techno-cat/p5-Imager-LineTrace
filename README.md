# NAME

Imager::LineTrace - これは画像中の直線をトレースするモジュールです

# SYNOPSIS

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

# DESCRIPTION

左下を原点として、反時計周りにトレースを行います。
現時点では、作者の要求のみ満たすように作られています。

    # 白地に黒でラインが描かれている場合は、以下のように記述します
    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0] );

    # R, G, B, Alpha のうち、どの要素をトレースするか指定できます
    # channels には、 0:R, 1:G, 2:B, 3:Alpha のいずれか1つを指定します
    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0], channels => [0] );

    # 白地じゃない場合は、背景色を指定します
    # 背景色のうち channels で指定した要素の値を ignore に指定します
    # 背景色が黒で、黒以外の色をトレースするときは、以下のように記述します
    my $figures_ref = Imager::LineTrace::trace( file => $ARGV[0], ignore => 0 );

# LICENSE

Copyright (C) neko.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

neko <techno.cat.miau@gmail.com>
