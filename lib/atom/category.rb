require 'atom/elements'

module Atom
  class Category
    
    attr_accessor :term
    attr_accessor :label
    attr_accessor :scheme

    def initialize(element = nil)
      if element.instance_of? REXML::Element
        @term = Atom::Rexml.get_attr(element, "term")
        @scheme = Atom::Rexml.get_attr(element, "scheme")
        @label  = Atom::Rexml.get_attr(element, "label")
      elsif element.instance_of Hash
        @term = element[:term]
        @scheme = element[:scheme]
        @label  = element[:label]
      end
    end

    def to_element
      category = create_element("category")
      Atom::Rexml.set_attr(category, "term", @term)
      Atom::Rexml.set_attr(category, "label",  @label)
      Atom::Rexml.set_attr(category, "scheme", @scheme)
      category
    end
  end

  class Categories < Atom::Elements
    element Category
  end
end
