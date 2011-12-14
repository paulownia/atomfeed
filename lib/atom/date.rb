require 'time'

# An Atom Date construct is an element whose content MUST conform to the "date-time" production in [RFC3339].
# In ruby language,  a time#iso8601 method formats a Time object object into the date-time string.
# You must import 'time' library before time#iso8601 method is called.
module Atom
  class Date
    attr_reader :time
  
    def initialize(element = nil)
      if element 
        @time = Time.iso8601(element.text)
        if @time.utc?
          @time.localtime
        end
      end
    end
	
    def time= (val)
      if val.nil? || val.instance_of?(Time)
        @time = val
      else
        @time = Time.iso8601(val)
        if @time.utc?
          @time.localtime
        end
      end
    end
    
    def to_element 
      if @time.nil?
        return nil
      end
      element = REXML::Element.new(self.tag)
      element.text = @time.iso8601
      element
    end
  end
  
  class Published < Date
    def tag
      "published"
    end
  end
  
  class Updated < Date
    def tag
      "updated"
    end
  end
end
