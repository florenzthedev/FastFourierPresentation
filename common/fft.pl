# Copyright (c) 2023 Zachary Todd Edwards
# MIT License

use strict;
use warnings;
use autodie;
use Regexp::Common;
use Math::Complex;

sub FFT {
  my $x = shift;
  my $n = scalar(@$x);
  return if($n < 2);

  my @xe = ();
  for(my $j = 0; $j < $n; $j += 2){
    push @xe, $$x[$j];
  }
  FFT(\@xe);

  my @xo = ();
  for(my $j = 1; $j < $n; $j += 2){
    push @xo, $$x[$j];
  }

  FFT(\@xo);

  for(my $j = 0; $j < ($n / 2); $j++){
    my $product = $xo[$j] * exp((i * 2 * pi * $j) / $n);
    $$x[$j] = $xe[$j] + $product;
    $$x[$j + ($n / 2)] = $xe[$j] - $product;
  }
}

my ($filename, $seconds) = @ARGV;
open(TABLE, '<', $filename);

my @y = ();

while(<TABLE>){
  my $letter = substr( $_, 0, 1 );
  next if($letter eq "#" or $letter eq "\n");
  my @pair = $_ =~ /($RE{num}{real})/g;
  push @y, $pair[1];
}

my $n = scalar(@y);
(($n & ($n - 1)) == 0) or die("Input not a power of two in size!");
my $hertz = $n / $seconds; 



close(TABLE);

FFT(\@y);

open(TABLE, '>', $filename);

for(my $j = 0; $j < $n; $j++){
  print TABLE ($j * ($hertz/$n)), " ", abs($y[$j])/$n, "\n";
}