#!/usr/bin/env ruby

class PSGen

  def initialize()
    @long = ['PURPOSE', 'PROBLEM', 'TASK']
    @short = ['SHORT', 'OUT', 'LONG', 'TITLE', 'DUE']
    @keywords = [@long, @short].flatten
  end

  def parseFile(filename)
    IO.foreach(filename) { |l|
      if (l =~ /\@(.*?)\@(.*)/) then
	key = $1
	if (@short.contains(key))
	  value = $2
	  print value
	end
      end

    }

  end
end

psg = PSGen.new
psg.parseFile('a1.txt')
