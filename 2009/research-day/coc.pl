#!/usr/bin/perl

while (<>) {
($title, $speaker, $advisor) = split(/\s{2,}/);
chomp($advisor);
print "$title\n";
print "$speaker (advisor: $advisor)\n\n";
}
