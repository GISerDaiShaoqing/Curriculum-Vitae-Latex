use strict; use warnings;
for my $file (@ARGV) {
  open my $in, "<", $file or die "open $file: $!"; my @c = <$in>; close $in;
  my $out = ""; my $done = 0;
  if ($file =~ m{enlatex/activities\.tex$}) {
    my $ins = <<'TEX';
\mycvitemac{from 2025}{Pang Changle Expert Grassroots Scientific Research Workstation, Mengzi Shuchan Investment and Development Co. Ltd}{Chief Researcher (PI)}
TEX
    for my $i (0..$#c) {
      $out .= $c[$i];
      if (!$done && $c[$i] =~ /\\faGroup\\ Science \\& Technology Service/) { $out .= $ins; $done = 1; }
    }
  } elsif ($file =~ m{cnlatex/activities\.tex$}) {
    my $ins = <<'TEX';
\mycvitemac{自2025}{蒙自市数产投资开发有限责任公司庞昌乐专家基层科研工作站}{\songti{首席研究员}}
TEX
    for my $i (0..$#c) {
      $out .= $c[$i];
      if (!$done && $c[$i] =~ /科学技术服务\}\{科学技术服务\}\}/) { $out .= $ins; $done = 1; }
    }
  } elsif ($file =~ m{entries\.csv$}) {
    my $ins = <<'CSV';
academic_service,Science & Technology Service,"Pang Changle Expert Grassroots Scientific Research Workstation, Mengzi Shuchan Investment and Development Co. Ltd",,2025,,Chief Researcher (PI),,,
CSV
    for my $i (0..$#c) {
      if (!$done && $c[$i] =~ /^academic_service,Science & Technology Service,The 138th/) { $out .= $ins; $done = 1; }
      $out .= $c[$i];
    }
  } elsif ($file =~ m{template-zh\.Rmd$}) {
    my $ins = <<'RMD';
### 科学技术服务

蒙自市数产投资开发有限责任公司庞昌乐专家基层科研工作站

首席研究员

2025-

RMD
    for my $i (0..$#c) {
      if (!$done && $c[$i] =~ /^### 科学技术服务/) { $out .= $ins; $done = 1; }
      $out .= $c[$i];
    }
  }
  die "insert failed in $file" unless $done;
  open my $o, ">", $file or die; binmode $o; print {$o} $out; close $o;
  print "$file: OK\n";
}
