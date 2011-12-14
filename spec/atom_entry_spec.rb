# -*- coding: utf-8 -*- 
require File.dirname(__FILE__) + '/spec_helper.rb'
require "rexml/document"

describe Atom::Entry, "をnewした時" do
  before do
    @entry = Atom::Entry.new
  end
  
  it "to_s すると空要素タグを出力する。" do
    @entry.to_s.should == "<entry/>"
  end

  
  it "to_element すると、子要素も属性も持たないREXML::Elementを作成する" do
    @entry.to_element.should be_instance_of REXML::Element
    @entry.to_element.to_s.should == "<entry/>"
  end
  
  
  it "to_rexml すると、空要素のみを持つREXML::Documentを作成する" do
    @entry.to_rexml.should be_instance_of REXML::Document
    
    @entry.to_rexml.to_s.should == 
      "<?xml version='1.0' encoding='UTF-8'?>" + 
      "<entry xmlns='http://www.w3.org/2005/Atom'/>"
  end
end

