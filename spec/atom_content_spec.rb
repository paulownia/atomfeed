# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper.rb'

describe Atom::Content, "をnewした時、" do
  before do
    @content = Atom::Content.new
  end

  it "contentのデフォルトのtypeは text で、" do
    expect(@content.type).to eq("text")
  end

  it "to_elementしたとき、contentのtextが無ければnil" do
    expect(@content.to_element).to be nil
  end
end

describe Atom::Content, "のtextをセットした時、" do
  before do
    @content = Atom::Content.new
    @content.text = "<p>hogehoge</p>"
  end

  it "to_sするとAtomのcontent要素の内容はテキストとして出力され、タグ等が実体参照に置き換えられている。" do
    expect(@content.to_s).to eq(
      "<content type='text'>&lt;p&gt;hogehoge&lt;/p&gt;</content>"
    )
  end

  it "typeがxhtmlならば、Atomのcontent要素の内容はxhtmlで出力され、" do
    @content.type = "xhtml"

    expect(@content.to_s).to eq(
      "<content type='xhtml'>" +
      "<html xmlns='http://www.w3.org/1999/xhtml'>" +
      "<p>hogehoge</p>" +
      "</html>" +
      "</content>"
    )
  end

  it "typeをhtmlに変えると、Atomのcontent要素の内容はタグ等が実体参照に置き換えられたhtmlで出力される。" do
    @content.type = "html"

    expect(@content.to_s).to eq(
      "<content type='html'>&lt;p&gt;hogehoge&lt;/p&gt;</content>"
    )
  end
end
