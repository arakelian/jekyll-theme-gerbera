module Subheadings
  NON_WORD_RE = /[^\p{Word}\- \t]/
  
  class Generator < Jekyll::Generator
    attr_accessor :site

    H2_REGEX = %r!^\s*\#{2,2} (.*)$!
    CONVERTER_CLASS = Jekyll::Converters::Markdown

    safe true
    priority :lowest

    def initialize(site)
      @site = site
    end

    def generate(site)
      @site = site

      generate_for(site.pages)
      site.collections.each do |name,collection|
      	  generate_for(collection.docs)
      end
    end
    
    def generate_for(collection)
      collection.each do |document|
        next unless should_pull_headings?(document)
        document.data["subheadings"] = headings_for(document)
      end
    end

    def should_pull_headings?(document)
      markdown?(document)
    end

    def markdown?(document)
      markdown_converter.matches(document.extname)
    end

    def markdown_converter
      @markdown_converter ||= site.find_converter_instance(CONVERTER_CLASS)
    end

    def headings_for(document)
      matches = document.content.scan(H2_REGEX)
      subheadings = []
      matches.each do |match|
        _title = match[0]
        _slug = _title.downcase
        _slug.gsub!(NON_WORD_RE, '')
        _slug.tr!(" \t", "-")
        subheadings << { "title" => _title, "url" => [document.url, _slug].join("#") }
      end
      return subheadings
    end
  end
end