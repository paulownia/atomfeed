require 'atom/meta'
require 'atom/elements' 

module Atom
  class Entry
    include Atom::Meta

    XML = ("<?xml version='1.0' encoding='UTF-8'?><entry xmlns='" + Atom::NAMESPACE + "'/>").freeze

    def initialize(element = nil)
      if element
        read_metadata(element)
      else
        init_metadata 
      end
    end

  	def to_s
      to_element.to_s	
  	end

    def to_element
      e = REXML::Element.new("entry")
      write_metadata(e)
      e
    end
    
    def to_rexml
      document = REXML::Document.new(Atom::Entry::XML)
      write_metadata(document.root)
      return document
    end
    
    # this method is not tested. 
    def self.from_hash
      hash.each { |k, v|
        method = self.method(k+"=".to_sym)
        if method
          method.call(v)
        end
      }
    end
  end

  class Entries < Atom::Elements
    element Entry
  end
end

