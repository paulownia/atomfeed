require "atom/text"
require "atom/date"

module Atom

  # 
  # Atomのメタ要素をインクルードします。
  #
  module Meta
    attr_accessor :id
    attr_accessor :title
    attr_accessor :icon
    attr_accessor :logo
    attr_accessor :rights
    attr_accessor :generator
    attr_accessor :subtitle
    
    attr_reader :links
    attr_reader :categories
    attr_reader :contributors
    attr_reader :authors
    
    attr_reader :content
    attr_reader :summary
    
    attr_reader :published
    attr_reader :updated
    
    def published= datetime
      @published.time = datetime
    end

    def updated= datetime
      @updated.time = datetime
    end
    
    def updated
      @updated.time
    end
    
    def published
      @published.time
    end
 

    protected
    def init_metadata
      @links = Atom::Links.new
      @categories = Atom::Categories.new
      @authors = Atom::Authors.new
      @contributors = Atom::Contributors.new
      
      @content = Atom::Content.new
      @summary = Atom::Summary.new      
      
      @published = Atom::Published.new
      @updated = Atom::Updated.new
    end

    #
    # メタ要素をREXML::Elementオブジェクトから取得して、
    # インスタンス変数にセットする
    #
    def read_metadata(element)
      @id =        Atom::Rexml.get_text(element, "id")
      @title =     Atom::Rexml.get_text(element, "title")
      @subtitle =  Atom::Rexml.get_text(element, "subtitle")
      @icon =      Atom::Rexml.get_text(element, "icon")
      @logo =      Atom::Rexml.get_text(element, "logo")
      @generator = Atom::Rexml.get_text(element, "generator")
      @rights =    Atom::Rexml.get_text(element, "rights")

      @authors = Atom::Authors.new(element.elements.to_a("author"))
      @links = Atom::Links.new(element.elements.to_a("link"))
      @categories = Atom::Categories.new(element.elements.to_a("category"))
      @content = Atom::Content.new(element.elements["content"])
      @summary = Atom::Summary.new(element.elements["summary"])
      @published = Atom::Published.new(element.elements["published"]) 
      @updated = Atom::Updated.new(element.elements["updated"]) 
   end

    #
    # メタ要素を指定のREXML::Elementオブジェクトに追加する
    #
    def write_metadata(element)
      Atom::Rexml.set_text(element, "id",        @id)
      Atom::Rexml.set_text(element, "title",     @title)
      Atom::Rexml.set_text(element, "icon",      @icon)
      Atom::Rexml.set_text(element, "logo",      @logo)
      Atom::Rexml.set_text(element, "rights",    @rights)
      Atom::Rexml.set_text(element, "generator", @generator)
      
      @authors.each { |author|
        element.add_element author.to_element
      }
      @links.each { |link|
        element.add_element link.to_element
      }
      @categories.each { |category|
        element.add_element category.to_element
      }
      @contributors.each { |contributor|
        element.add_element contributor.to_element
      }
      
      if @summary.text
        element.add_element @summary.to_element
      end
      
      if @content.text
        element.add_element @content.to_element
      end
      
      if @updated.time
        element.add_element @updated.to_element
      end
      
      if @published.time
        element.add_element @published.to_element
      end
    end
  end
end
