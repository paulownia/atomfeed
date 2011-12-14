module Atom
  class Text
	
    attr_accessor :text
    attr_writer :type
  
    def initialize(element = nil)
      if element
        @type = Atom::Rexml.get_attr(element, "type")
        
        if not element.elements.empty?
          if @type == "xhtml" 
            e = element.elements[1, "html"]
            if e 
              element = e
            end
          end
          @text = element.elements.map { |child| child.to_s }.join
        else
          @text = element.texts.join
        end
      end
    end

    def to_s
      to_element.to_s
    end

    def to_element
      if @text.nil?
        return nil
      end
      
      if @type.nil? || @type == "text"
        to_element_directly
      elsif @type == "html"
        to_element_directly
      elsif @type == "xhtml"
        to_element_as_xhtml
      else
        nil
      end
    end

    def type
      if @type.nil? 
        return "text"
      elsif @type == "html" || @type == "xhtml"
        return @type
      else
         return "text"
      end
    end
    
    protected
        
    def to_element_as_xhtml
      element = REXML::Element.new(self.tag)
      element.add_attribute("type", self.type)
      xhtml = REXML::Document.new("<html xmlns='http://www.w3.org/1999/xhtml'>" + @text + "</html>")
      element.add_element(xhtml.root)
      element
    end
    
    def to_element_directly
      element = REXML::Element.new(self.tag)
      element.add_attribute("type", self.type)
      element.text = @text 
      element
    end
  end
  
  class Content < Text
    def tag
      "content"
    end
  end
  
  class Summary < Text
    def tag
      "summary"
    end
  end
end
