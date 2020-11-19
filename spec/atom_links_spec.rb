# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'


describe Atom::Links, "をnewしたとき、" do
  before do
    @links = Atom::Links.new
  end

  it "最初、要素数は0" do
    @links.should be_empty
  end
end

describe Atom::Links, "に新しい要素を追加するとき、" do
  before do
    @links = Atom::Links.new
  end

  it "addメソッドにハッシュで要素のプロパティを渡して、新しい要素を追加できる。" do
    @links.add( :href => "http://localhost/hoge", :type => "text/xml", :rel => "alternate" )
    expect(@links.size).to eq(1)
    @links[0].href.should == "http://localhost/hoge"
    @links[0].type.should == "text/xml"
    @links[0].rel.should == "alternate"

    @links.add( :href => "http://localhost/fuga", :type => "text/html", :rel => "index" )
    expect(@links.size).to eq(2)
    @links[1].href.should == "http://localhost/fuga"
    @links[1].type.should == "text/html"
    @links[1].rel.should == "index"
  end

  it "新しい要素を追加して、ブロックにその新しい要素が渡される。" do
    @links.add { |link|
      link.href = "http://localhost/hoge"
      link.rel = "alternate"
    }
    @links[0].href.should == "http://localhost/hoge"
    @links[0].type.should be_nil
    @links[0].rel.should == "alternate"
  end
end
