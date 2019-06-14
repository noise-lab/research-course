#!/usr/bin/env ruby

class BibParse
  def initialize(bf)
    @bibfile = bf

    @entries = Hash.new
    @crossrefs = Hash.new
    @readinglist = Hash.new
    @readinglistbytype = Hash.new
    @strs = Hash.new

    parse
  end

  def cleanup(val)
     val.gsub(/\"/, "").gsub(/[\{\}]/, "").sub(/,\s*$/, "")
  end


  def parse

    bibent = nil
    ref = nil

    IO.foreach("#{@bibfile}") { |l|
      
      if (l =~ /\@(.*)\{\s*(.*?)\s*,/) 
        type = $1
        ref = $2

        bibent = Hash.new
        bibent["type"] = type

      elsif (l =~ /@string\{(.*)\}/i)
        strdef = $1
        if (strdef =~ /(\w+)\s*\=\s*(.*)/)
           strname = $1
           strval = $2
           val = cleanup(strval)
           @strs[strname] = val
        end

      elsif (l =~ /\s*(\w+)\s*\=\s*(.*)/)
        key = $1
        val = $2

        val.gsub!(/\"/, "")
        val.gsub!(/[\{\}]/, "")
        val.sub!(/,\s*$/, "")
        if (@strs[val])
          val = @strs[val]
        end

        bibent["#{key}"] = val
      
      elsif (l =~ /^\}/)
        
        if (bibent["type"] == "proceedings")
           @crossrefs[ref] = bibent
        else
           @entries[ref] = bibent
        end
      end
    }
  end


  def printHTML(ref, out)

    r = @entries[ref]

    out.puts "#{r["author"]}<br />"
    out.puts "<a href=\"#{r["url"]}\"><i>#{r["title"]}</i></a><br />"

    
    if (r["crossref"] && r["crossref"].length > 0)
      cr = @crossrefs[r["crossref"]]
    else
      cr = r
    end

    if (cr["booktitle"] || cr["journal"])

      title = cr["booktitle"]?cr["booktitle"]:cr["journal"]
      mon = cr["month"] ? cr["month"].capitalize : ""
      year = cr["year"] || ""
      out.print "In <i>#{title}</i>, #{mon} #{year}" 
      out.print ", pages #{cr["pages"]}" if cr["pages"]
      out.print "<br />\n"
    end


#     if r["url"]
#       out.puts "<a href=\"#{r["url"]}\">Link</a><br />"
#     end

  end


  def setURL(ref,url)
    if (!@entries[ref]) 
      $stderr.puts "URL for undefined reading list entry #{ref}.  Creating."
      $stderr.puts "Create an entry in class.bib to suppress this warning"
      @entries[ref] = Hash.new
    end
    @entries[ref]["url"] = url
  end

  def addToList(ref, lecent, type=nil)
    if (!@readinglist[lecent] || @readinglist[lecent].size <= 0)
      @readinglist[lecent] = Array.new 
    end
    @readinglist[lecent] << ref

  end


  def printReadingList(filename, head=nil, tail=nil)

    out = File.new(filename, "w+")

    out.print IO.read(head) if head

    out.puts "<ul>"

    @readinglist.keys.sort {
      |x,y| x["lecnum"].to_i <=> y["lecnum"].to_i
    }.each { |l|
      out.puts "<li>"
      out.puts "#{l["date"]} -- Lecture #{l["lecnum"]}: #{l["T"]}<br />"

      out.puts "<ul>"

      @readinglist[l].each { |ref|
        out.puts "\n<li>"
        printHTML(ref, out)
        out.puts "</li>\n"
      }
      out.puts "</ul>"
      out.puts "</li>"
    }
    out.puts "</ul>"

    now = Time.new
    out.puts "<p class=\"lastupdated\">Last Updated #{now}</p>"

    out.print IO.read(tail) if tail

  end
end

if $0 == __FILE__
    bp = BibParse.new("./class.bib")
    bp.setURL("Infranet", "http://foo/")


    # add some test entries
    lecent = Hash.new
    lecent["date"] = "10/17"
    lecent["T"] = "Anonymity"
    bp.addToList("Infranet",lecent)

    lecent = Hash.new
    lecent["date"] = "10/18"
    lecent["T"] = "Management"
    bp.addToList("rcc",lecent)

    
  bp.printReadingList("readinglist.srhtml",
                      "readinglist.head",
                      "readinglist.tail")
end
