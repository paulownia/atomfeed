require 'atom/elements'

module Atom
  class Link
    
    attr_accessor :href
    attr_accessor :rel
    attr_accessor :type

    def initialize(element = nil)
      if element.instance_of? REXML::Element
        @rel  = Atom::Rexml.get_attr(element, "rel")
        @type = Atom::Rexml.get_attr(element, "type")
        @href = Atom::Rexml.get_attr(element, "href")
      elsif element.instance_of? Hash
        @rel = element[:rel]
        @type = element[:type]
        @href = element[:href]
      end
    end

    def to_element
      link = REXML::Element.new "link"
      Atom::Rexml.set_attr(link, "rel",  @rel)
      Atom::Rexml.set_attr(link, "type", @type)
      Atom::Rexml.set_attr(link, "href", @href)
      link
    end
  end

  class Links <  Atom::Elements
    element Link
  end
end
