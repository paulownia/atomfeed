module Atom
  NAMESPACE = 'http://www.w3.org/2005/Atom'
end

require 'rexml/document'
require 'stringio'
require 'atom/person'
require 'atom/link'
require 'atom/category'
require 'atom/entry'
require 'atom/rexml'

module Atom
  class Feed
    include Atom::Meta
    
    XML = ("<?xml version='1.0' encoding='UTF-8'?><feed xmlns='" + Atom::NAMESPACE + "'/>").freeze

    attr_reader :entries


    def self.create(hash = nil)
      feed = Atom::Feed.new
      if block_given? 
        yield feed
      elsif not hash.nil?
        hash.each do |key, value| 
          feed.__send__(key.to_s + "=", value)
        end
      end 
      feed
    end

    def initialize(io_or_string = nil)
      if io_or_string
        self.read(io_or_string)
      else
		    init_metadata
        @entries = Atom::Entries.new
      end
    end

    def to_s
      to_element.to_s
    end
    
    def stringify
      to_rexml.to_s
    end

	def to_element
	  e = REXML::Element.new("feed")
	  build_element(e)
	  e
	end

    def to_rexml
      document = REXML::Document.new(Atom::Feed::XML)
      build_element(document.root)
      return document
    end

    def write(io)
      self.to_rexml.write(io)
    end

    def self.load(filepath)
      File.open(filepath, "r") do |file|
        Atom::Feed.new(file)
      end
    end

    protected
    def read(io_or_string)
      document = REXML::Document.new(io_or_string)
      if document.root.name != "feed" then
        raise ArgumentError.new("An argument is not atom document.")
      end

      if document.root.namespace != Atom::NAMESPACE
        is_atom = document.root.namespaces.any? { |ns|
          ns == Atom::NAMESPACE
        }
        
        if not is_atom
          raise ArgumentError.new("An argument is not atom document. Invalid xml namespace")
        end
      end
      read_metadata(document.root)
      @entries = Atom::Entries.new( document.root.elements.to_a("entry") ) 
    end
    
    def build_element(element)
      write_metadata(element)
      @entries.each { |e|
        element.add_element e.to_element
      }
    end
  end
end



