use strict; use warnings;
for my $file ("enlatex/activities.tex", "cnlatex/activities.tex") {
  open my $in, "<", $file or die $!;
  my @c = <$in>; close $in;
  my $n = 0;
  for my $i (0..$#c) {
    next unless $c[$i] =~ /^\mycvitemacl\{(?:from |自)2019\}\{\textbf\{Health/;
    $n = ($c[$i] =~ s/ & / \& /g);
    die "no bare & found in $file reviewer line" unless $n > 0;
    last;
  }
  die "reviewer line not found in $file" unless $n > 0;
  open my $o, ">", $file or die; binmode $o; print {$o} join("", @c); close $o;
  print "$file: escaped $n bare ampersands\n";
}
