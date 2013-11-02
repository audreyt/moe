#!/usr/bin/env perl
use 5.12.0;
use JSON::XS;
use File::Slurp;
# wget https://www.moedict.tw/lab/tmuse-cc-by-nc-sa-proxteam/veryfirstdump.json
my $x = JSON::XS::decode_json( File::Slurp::slurp("veryfirstdump.json" ));
while (my ($k, $v) = each %$x) {
    File::Slurp::write_file("a/$k.json", {binmode => ":utf8"} , JSON::XS->new->pretty(1)->encode($v))
}
