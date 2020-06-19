#!/usr/bin/perl -w

use Font::Fret;

#@files = glob($ARGV[0]);
foreach $ttf (@ARGV)
{
    $font = Font::TTF::Font->open($ttf) || die "Can't open font file $ttf";
    $value = scalar $font->{'name'}->read->find_name(4);
    #$copyright = $font->{'name'}->find_name(0);

    print "$ttf: $value\n";
}
