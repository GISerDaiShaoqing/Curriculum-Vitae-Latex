use strict; use warnings;
my @titles = (
  "Understanding multi-perspective urban green space patterns under urban expansion",
  "Measuring causal strengths from spatial cross-sectional data",
  "Editorial: Machine learning for advanced remote sensing",
);
for my $file (@ARGV) {
  open my $in, "<", $file or die "open $file: $!"; my @c = <$in>; close $in;
  my @idx;
  for my $t (@titles) {
    my $found = -1;
    for my $i (0..$#c) { if ($c[$i] =~ /\Q$t\E/) { $found = $i; last } }
    die "title not found in $file: $t" unless $found >= 0;
    die "not an item block at $found in $file" unless $c[$found-2] =~ /^\\item/;
    push @idx, [$found-2, $found+2];
  }
  my @extracted;
  for my $r (sort { $b <=> $a } map { $_->[0] } @idx) {
    my ($s, $e) = (0, 0);
    for my $x (@idx) { if ($x->[0] == $r) { ($s, $e) = @$x; last } }
    my @blk = splice(@c, $s, $e - $s + 1);
    die "block bad in $file" unless $blk[0] =~ /^\\item/ && $blk[4] =~ /IF=/;
    unshift @extracted, [@blk];
  }
  # insert before the tEDM \item (author line anchors it): final order Editorial, causal, SCS, tEDM
  my $done = 0;
  for my $i (0..$#c) {
    next unless $c[$i] =~ /Wenbo Lyu, Yangyang Lei, Wen Yi, Yongze Song, Xiao Li/;
    my $joined = join("", @c[$i-1..$i]);
    $joined =~ s/(\\item\n?)$/$extracted[2][0][0]/;   # sanity probe
    for my $bi (reverse 0..2) { splice(@c, $i-1, 0, @{$extracted[$bi]}); }
    $done = 1; last;
  }
  die "tEDM anchor not found in $file" unless $done;
  # verify: titles now sit between co-header and Key-header positions
  my $joined = join("", @c);
  my $en = ($file =~ m{^enlatex/});
  my $cop = index($joined, $en ? "Peer-Reviewed Journal Articles (other author)" : "共同作者");
  my $nextp = index($joined, $en ? "Book Chapter" : "著作章节");
  for my $t (@titles) {
    my $p = index($joined, $t);
    die "placement wrong for $t (p=$p cop=$cop next=$nextp)" unless $p > $cop && $p < $nextp;
  }
  open my $o, ">", $file or die; binmode $o; print {$o} join("", @c); close $o;
  print "$file: moved back OK\n";
}
