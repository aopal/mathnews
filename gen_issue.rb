require 'nokogiri'

root = File.open(ARGV[0]) { |f| Nokogiri::XML(f) } # parse the given file
posts = root.css("category[nicename = '#{ARGV[1]}']").map(&:parent) # get all posts with a certain tag
posts.map! do |post|
  title = post.css("title").text
  body = post.children.find{|c| c.namespace&.prefix == "content"}.text
  body.gsub!(/\n{2,}/, "\n")
  body.gsub!(/&nbsp;/, '')
  body.gsub(/>\n+/, '>')
  "<article><title>#{title}</title>\n#{body}</article>"
end

f = File.new("#{ARGV[1]}.xml", 'w')
f.write("<issue>#{posts.join("\n")}</issue>")
f.close