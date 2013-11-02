use 5.12.0;
use utf8;
use warnings;
use JSON::XS;
use File::Slurp qw[ read_file write_file ];
my %sound;
my %rhyme;
my %alike;
while (<DATA>) {
    chomp;
    my ($id, $ch, @bpmf) = grep length, split /,/;
    next unless length $ch == 1;
    s/丨/ㄧ/g for @bpmf;
    s/[\s　]//g for @bpmf;
    $sound{$ch} = \@bpmf;
    for (@bpmf) {
        my $x = $_;
        $x =~ s/[ˋˊˇ‧]//g;
        $alike{$x} .= $ch;
        $rhyme{substr($x, -1)} .= $ch;
    }
}

my @chars = split //, read_file 'orig-chars.json', {binmode => ':utf8'};
for (@chars) {
    next if /"/ or /\s/;
    next if $sound{$_};
    next unless -e "a/$_.json";
    my $ch = $_;
    my $x = JSON::XS::decode_json( File::Slurp::slurp("a/$_.json" ));
    my @bpmf;
    for my $h (@{$x->{h} || []}) {
        push @bpmf, $h->{b} if $h->{b};
    }
    s/丨/ㄧ/g for @bpmf;
    s/[\s　]//g for @bpmf;
    s/（.*?）//g for @bpmf;
    $sound{$ch} = \@bpmf;
    for (@bpmf) {
        my $x = $_;
        $x =~ s/[ˋˊˇ‧]//g;
        $alike{$x} .= $ch;
        $rhyme{substr($x, -1)} .= $ch;
    }
}

File::Slurp::write_file("Sound.json", {binmode => ":utf8"} , JSON::XS->new->pretty(1)->canonical(1)->encode(\%sound));
File::Slurp::write_file("SoundRhyme.json", {binmode => ":utf8"} , JSON::XS->new->pretty(1)->canonical(1)->encode(\%rhyme));
File::Slurp::write_file("SoundAlike.json", {binmode => ":utf8"} , JSON::XS->new->pretty(1)->canonical(1)->encode(\%alike));

