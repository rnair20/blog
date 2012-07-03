#! /usr/bin/env ruby

require 'redcarpet'

file = ARGV[0] ? File.open(ARGV[0]) : STDIN

class Bloggit < Redcarpet::Render::HTML
  def replace_gists(document)
    document.gsub(/\[gist (.*) (.*)\]/) do
      gist_id = $1
      file = $2
      "<script src=\"https://gist.github.com/#{gist_id}.js?file=#{file}\"></script>"
    end
  end

  def postprocess(full_document)
    [:replace_gists].inject(full_document) { |d, m| send(m, d) }
  end
end

markdown = Redcarpet::Markdown.new(Bloggit.new)
puts markdown.render file.read
