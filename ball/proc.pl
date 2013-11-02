use 5.12.0;
use utf8;
use warnings;
use JSON::XS;
use File::Slurp qw[ read_file write_file ];
my %near;
proc('hausdorff_distance_output.csv');
proc('intersection_union_output.csv');
my %prox;
while (my ($k, $v) = each %near) {
    my $vs = join '', sort keys %$v;
    $prox{$k} = $vs;
}
File::Slurp::write_file("Shape.json", {binmode => ":utf8"} , JSON::XS->new->pretty(1)->encode(\%prox));
sub proc {
open my $fh, '<:utf8', shift;
<$fh>; 
while (<$fh>) {
    s/"//g;
    my ($ch1, $ch2) = split /,/, $_;
    $near{$ch1}{$ch2} = 1;
    $near{$ch2}{$ch1} = 1;
}

}
