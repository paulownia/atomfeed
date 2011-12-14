require "atom/elements"

module Atom
  class Person

    attr_accessor :name
    attr_accessor :uri
    attr_accessor :email

    def initialize(element = nil)
      if element.instance_of? REXML::Element
        @name =  Atom::Rexml.get_text(element, "name")
        @uri =   Atom::Rexml.get_text(element, "uri")
        @email = Atom::Rexml.get_text(element, "email")
      elsif element.instance_of? Hash
        @name =  element[:name]
        @uri =   element[:uri]
        @email = element[:email]      
      end
    end
    
    def to_element
      parent = REXML::Element.new(self.tag)      
      Atom::Rexml.set_text(parent, "name",  @name)
      Atom::Rexml.set_text(parent, "uri",   @uri)
      Atom::Rexml.set_text(parent, "email", @name)
      parent
    end
  end

  class Author < Person
    def tag
      "author"
    end
  end

  class Authors < Atom::Elements
    element Author
  end

  class Contributor < Person
  	def tag
  		"contributor"
  	end
  end

  class Contributors < Atom::Elements
    element Contributor
  end
end


