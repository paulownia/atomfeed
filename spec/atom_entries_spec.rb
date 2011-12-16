# -*- coding: utf-8 -*- 
require File.dirname(__FILE__) + '/spec_helper.rb'

describe Atom::Entries, "のインスタンスは" do
  before do
    @entries = Atom::Entries.new
  end

  it "Enumerableである。" do
    @entries.should be_kind_of Enumerable 
  end
  it "Atom::Elementsである。" do
    @entries.should be_kind_of Atom::Elements
  end

  it "addメソッドにブロックを渡して新しいAtom::Entryを追加できる" do
    @entries.add { |entry|
      entry.should be_instance_of Atom::Entry
      entry.id = "hoge"
      entry.title = "fuga"
      entry.links.add(:href => "http://hogehoge.com/")
    }
    @entries.should have(1).items
  end
end

describe Atom::Entries, "をnewした直後、" do
  before do
    @entries = Atom::Entries.new
  end

  it "要素数は0" do
    @entries.should be_empty
  end
end
