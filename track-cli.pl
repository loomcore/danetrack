# track 0.0.1
# track-cli.pl
# An interactive invokation of track-backend.
# Copyright (C) 2013 P. M. Yeeles
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use warnings;
use strict;
use Cwd;

my $pwd = cwd();
my $outdir = glob('~/Desktop');
# my $dtdir = '/cygdrive/s/pyeeles/apps/data/track';
my $dtdir = '/home/phil/dev/r/maths_ipads';

print "Results file: ";
my $file = <STDIN>;
chomp($file);
print "Child's name: ";
my $name = <STDIN>;
chomp($name);
print "Available analyses are:\nTime, Attempted, Correct, Ratio, AttemptRate, CorrectRate, CombinedRate.\nSelection: ";
my $type = <STDIN>;
chomp($type);
print "Performing $type analysis for $name...\n";
SWITCH: for ($type) {
  ($type eq "Time") && do { last SWITCH; };
  ($type eq "Attempted") && do { last SWITCH; };
  ($type eq "Correct") && do { last SWITCH; };
  ($type eq "Ratio") && do { last SWITCH; };
  ($type eq "AttemptRate") && do { last SWITCH; };
  ($type eq "CorrectRate") && do { last SWITCH; };
  ($type eq "CombinedRate") && do { last SWITCH; };
  die "Unknown analysis type: $type\n";
}
chdir($outdir);
system('Rscript', "$dtdir/track-backend.R", "$pwd/$file", $name, $type);
print "Complete!\n";