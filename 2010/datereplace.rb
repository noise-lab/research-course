#!/usr/bin/ruby

now = Time.new
system("cp #{ARGV[0]} #{ARGV[0]}.tmp")
f = File.new(ARGV[0], "w+")
IO.foreach("#{ARGV[0]}.tmp") { |l|
  l.gsub!(/Updated .*$/,
          sprintf("Updated %s", now.to_s))
  f.print l
}
system("rm #{ARGV[0]}.tmp")
