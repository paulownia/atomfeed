# -*- coding: utf-8 -*- 
require File.dirname(__FILE__) + '/spec_helper.rb'

describe Atom::Published, "を引数なしでnewしたとき" do
  before do
    @published = Atom::Published.new
  end

  it "time属性はnil" do
    @published.time.should be_nil
  end
end

describe Atom::Published, "にREXML::ELementを引数にしてnewしたとき" do
  before do
    element = REXML::Element.new("published")
    element.text = "2009-04-21T20:07:15+09:00"
    @published = Atom::Published.new(element)
  end

  it "time属性には、コンストラクタに渡したElementのテキストをパースした日付がセットされている" do
    @published.time.year.should == 2009
    @published.time.month.should == 4
    @published.time.day.should == 21
    @published.time.hour.should == 20
    @published.time.min.should == 7

    # 地方時になっていること 
    @published.time.utc_offset.should == Time.now.localtime.utc_offset
  end
end
