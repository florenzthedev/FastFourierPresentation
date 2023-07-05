use strict;
use warnings;

sub log2 {
    my $n = shift;
    return log($n)/log(2);
}

use integer;
my ($length) = @ARGV;
my $width = log2($length);

my $os = 2; #offset
my $ml = 2; #multiplier

my @brp = ();
for (my $i = 0; $i < $length; $i++) {
  my $r = 0;
  for (my $j = 0; $j < $width; $j++) {
     $r = $r | (1 << (($width - 1) - $j)) if ($i & (1 << $j));
  }
  $brp[$i] = $r;
}

my $full_width = $width * ($os + $ml);

for(0..($length - 1)){
  print "\\draw[thick] (-1,-$_) -- ($full_width,-$_);\n";
  my $smolX = $brp[$_];
  print "\\addplot[mark=*] coordinates {(-1,-$_)} node [left] {\$x_$smolX\$};\n";
  print "\\addplot[mark=*] coordinates {($full_width,-$_)} node [right] {\$X_$_\$};\n";
}

for(my $j = 0; $j < $width; $j++){
  my $block = $length / ($j + 1);
  for(my $g = 0; $g < $length; $g += $block){
    for(my $k = 0; $k < $block / 2; $k++){
      my $lo = $g + $k;
      my $hi = $lo + ($block / 2);
      my $hix = $brp[$hi];
      my $lox = $brp[$lo];
      my $st = ($width - 1 - $j) * ($ml + $os);
      my $nx = $st + $ml;
      my $kn = -$k; #so we don't get a negative zero
      print "\\draw[-Stealth,thick,line_color] ($st,-$lo) -- ($nx,-$hi) node[above right] {\$x_$lox-\\omega_$block^{$kn}\\cdot x_$hix\$};\n";   
      print "\\draw[-Stealth,thick,mark_color] ($st,-$hi) -- ($nx,-$lo) node[above right] {\$x_$lox+\\omega_$block^{$kn}\\cdot x_$hix\$};\n";   
    }
  }
}