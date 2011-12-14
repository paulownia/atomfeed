# -*- coding: utf-8 -*- 
require File.dirname(__FILE__) + '/spec_helper.rb'

describe Atom::Content, "をnewした時、" do
  before do
    @content = Atom::Content.new
  end
  
  it "contentのデフォルトのtypeは text で、" do
    @content.type.should == "text"
  end
 
  it "to_elementしたとき、contentのtextが無ければnil" do
    @content.to_element.should be_nil
  end
end

describe Atom::Content, "のtextをセットした時、" do
  before do
    @content = Atom::Content.new
    @content.text = "<p>hogehoge</p>"
  end

  it "typeがxhtmlならば、Atomのcontent要素の内容はxhtmlで出力され、" do
    @content.type = "xhtml"
    @content.to_s.should == 
      "<content type='xhtml'>" +
      "<html xmlns='http://www.w3.org/1999/xhtml'>" + 
      "<p>hogehoge</p>" +
      "</html>" +
      "</content>"
  end
  
  it "typeをhtmlに変えると、Atomのcontent要素の内容はタグ等が実体参照に置き換えられたhtmlで出力される。" do
    @content.type = "html"
    @content.to_s.should == 
      "<content type='html'>&lt;p&gt;hogehoge&lt;/p&gt;</content>" 
  end
end
