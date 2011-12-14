module Atom
module Rexml

  #
  # このモジュールのメソッドは、
  # Atom::Rexml名前空間にクラス（モジュール？）メソッドとして追加されます。
  # Atom::Rexml.get_text() で呼べます。
  # 
  # 名前空間を付けるのかったるいならば、各クラスで extend しちゃってください。includeでもいいですがｗ
  #
  module Utility 
    def get_text(feed, node_name)
      e = feed.elements[node_name]
      if e.nil? 
        nil
      else
        e.text
      end
    end

    def get_attr(element, attr_name)
      attr = element.attribute(attr_name)
      if attr.nil?
        nil
      else
        attr.value
      end
    end

    def set_attr(element, attr_name, attr_value)
      if attr_value.nil?
        return
      end
      element.add_attribute(attr_name, attr_value)
    end

    #
    # 指定の要素nodeに、node_nameで指定した名前の要素を追加し、
    # さらに子要素としてnode_valueを値として持つテキストノードを追加する。
    #
    def set_text(node, node_name, node_value)
      if node_value.nil?
        return
      end
      e = REXML::Element.new node_name
      e.add_text node_value
      node.add_element(e)
    end
  end

  extend Utility
end
end
