# -*- coding: utf-8 -*- 
require File.dirname(__FILE__) + '/spec_helper.rb'
require 'rexml/document'

describe Atom::Link, "をnewしたとき、" do
  before do
    @link = Atom::Link.new
  end

  it "最初、属性値は空" do
    @link.rel.should be_nil
    @link.href.should be_nil
    @link.type.should be_nil
  end
end  
  
describe Atom::Link, "に属性値をセットしたとき、" do
  before do
    @link = Atom::Link.new
    @link.href = "http://localhost/"
    @link.type = "text/html"
    @link.rel = "index"
  end

  it "to_elementすると、それらを属性値として持つREXML::Elementが生成" do
    rexml = @link.to_element 
    rexml.should be_instance_of REXML::Element
    rexml.attribute("rel").value.should == "index"
    rexml.attribute("href").value.should == "http://localhost/"
    rexml.attribute("type").value.should == "text/html"
  end
  
  it "to_sすると、属性値をもったlink要素のXML文字列になる" do
    @link.to_element.to_s.should ==
      "<link href='http://localhost/' rel='index' type='text/html'/>"
  end
end
  

describe Atom::Link, "をハッシュを引数にnewしたとき" do
  before do
    @link = Atom::Link.new( :href => "http://localhost/hoge", :type => "text/xml", :rel => "alternate" )
  end

  it "ハッシュの値が属性値にセットされている" do
    @link.href.should == "http://localhost/hoge"
    @link.type.should == "text/xml"
    @link.rel.should == "alternate" 
  end
end 
 
describe Atom::Link, "をREXML::Elementを引数にしてnewしたとき" do
  before do
    e = REXML::Element.new("link")
    e.add_attributes( 'href' => "http://localhost/hoge", 'type' => "text/xml", 'rel' => "alternate")
    @link = Atom::Link.new(e)
  end
  
  it "REXML::Elementの内容がプロパティに読み込まれている" do
    @link.href.should == "http://localhost/hoge"
    @link.type.should == "text/xml"
    @link.rel.should == "alternate" 
  end
end
