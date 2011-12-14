module Atom
  module ElementsClass
    def element(c = nil)
      @element_class = c
    end
    
    def get_element
      @element_class
    end
  end

  #
  # 1つ以上の同一要素を扱うためのクラス
  #
  class Elements
    include Enumerable
    extend ElementsClass

    def initialize(rexml_elements = nil)
      @items = []
      if rexml_elements
        rexml_elements.each { |e|
          @items << self.class.get_element.new(e)
        }
      end
    end

    def empty?
      size == 0
    end

    #
    # 新しい要素を作成して追加する。
    # 追加した要素を返す。
    # ブロックを渡して、追加した新しい要素を処理することも可能。
    # 
    def add val = nil, &block    
      c = self.class.get_element
      if block_given?
        item = c.new
        yield item
        @items << item
      elsif val.instance_of? Hash
        item = c.new(val)
        @items << item
      elsif val.instance_of? c
      	@items << val
      end
    end
    
    def delete item
      @items.delete item
    end

    def delete_at pos
      @items.delete_at(pos)
    end
    
    def delete_if &block
      @items.delete_if &block
      self
    end
    
    def size
      @items.size
    end

    alias :length :size

    def [] pos
      @items[pos]
    end

    def each &block
      @items.each &block
    end
  end
end
