# -*- coding: utf-8 -*- 
require File.dirname(__FILE__) + '/spec_helper.rb'
require 'rexml/document'

describe Atom::Feed, "createのブロックで各種プロパティをセットしたとき" do
  before do
    @now = Time.now
    @feed = Atom::Feed.create do |feed|
      feed.id = "homura"
      feed.title = "もう誰にも頼らない"
      feed.published = @now
      feed.entries.add do |entry| 
        entry.id = ""
      end
    end
  end

  it "ブロックでセットしたidが入っている" do
    @feed.id.should == "homura"
  end
  it "ブロックでセットしたtileが入っている" do
    @feed.title.should == "もう誰にも頼らない"
  end
  it "ブロックでセットしたpublishedが入っている" do
    @feed.published.should == @now
  end
  it "ブロックで追加したentryがある" do
    @feed.entries.size.should == 1
  end
end

describe Atom::Feed, "createの引数にハッシュでプロパティ値を渡した時、" do
  before do
    @now = Time.now
    @feed = Atom::Feed.create(
      :id => "madoka", 
      :title => "そんなの絶対おかしいよ",
      :published => @now
    )
  end
  it "ブロックでセットしたidが入っている" do
    @feed.id.should == "madoka"
  end
  it "ブロックでセットしたtileが入っている" do
    @feed.title.should == "そんなの絶対おかしいよ"
  end
  it "ブロックでセットしたpublishedが入っている" do
    @feed.published.should == @now
  end
end


describe Atom::Feed, "をnewした直後に、" do
  before do
    @feed = Atom::Feed.new
  end

  it "to_sすると、feedの空要素タグを出力する" do
    @feed.to_s.should == "<feed/>"
  end

  it "stringifyで、feed空要素がルートノードのXML文字列を生成" do
    @feed.stringify.should == 
      "<?xml version='1.0' encoding='UTF-8'?>" +
      "<feed xmlns='http://www.w3.org/2005/Atom'/>"
  end

  it "id要素は空" do
    @feed.id.should be_nil
  end
  it "title要素は空" do
    @feed.title.should be_nil
  end
  it "logo要素は空" do
    @feed.logo.should be_nil
  end
end

describe Atom::Feed, "のloadメソッドでファイルがなかった場合は" do
  before do
    @loading_no_file = lambda{ Atom::Feed.load( "sonna_file_neeeeyo.xml" ) }
  end
  
  it "例外が投げられる" do
    @loading_no_file.should raise_error Errno::ENOENT
  end
end

describe Atom::Feed, "のloadメソッドでXMLファイルをロードした場合" do
  before(:all) do
    # ファイル読み込みは一度
  	@atom = Atom::Feed.load( f "files/load.xml" )
  end

  it "id要素が読み込まれている。" do
  	@atom.id.should == "http://paulownia.jp/"
  end

  it "updatedの日付が読み込まれている" do
    @atom.updated.strftime("%Y/%m/%d %H:%M:%S").should == "2007/01/10 13:28:27"
  end
  
  it "publishedの日付が読み込まれている" do
    @atom.published.strftime("%Y/%m/%d %H:%M:%S").should == "2006/01/10 00:28:27"
  end

  it "icon要素が読み込まれている" do
    @atom.icon.should == "http://paulownia.jp/favicon.ico"
  end
  
  it "logo要素が読み込まれている" do
    @atom.logo.should == "http://paulownia.jp/logo.png"
  end

  it "rights要素が読み込まれている" do
    @atom.rights.should == "nullpon"
  end
  
  it "generator要素が読み込まれている" do
    @atom.generator.should == "intiki generator"
  end

  it "title要素が読み込まれている" do
    @atom.title.should == "paulownia.jp"
  end

  it "subtitle要素が読み込まれている" do
    @atom.subtitle.should == "atom test"
  end

  it "summary要素が読み込まれている" do
    @atom.summary.should_not be_nil
    @atom.summary.type.should == "text"
    @atom.summary.text.should == "hogehoge"
  end
  
  it "content要素が読み込まれている" do
    @atom.content.should_not be_nil
    @atom.content.type.should == "xhtml"
    @atom.content.text.should == "<p>ほげ？</p>"
  end


  it "author要素の内容が読み込まれている。" do
  	@atom.authors.should have(1).items
  	@atom.authors.length.should == 1
    @atom.authors[0].name.should == "paulownia"
  end
  
  it "link要素が読み込まれている" do
    @atom.links.size.should == 1
    @atom.links[0].rel.should == "alternate"
  end
  
  it "2つのcategory要素が読み込まれている" do
    @atom.categories.size.should == 2
    @atom.categories[0].term.should == "ruby"
    @atom.categories[1].scheme.should == "http://127.0.0.1/programming"
  end
  
  it "3つのentry要素が読み込まれている" do
    @atom.entries.length.should == 3
    @atom.entries[0].title.should == "テスト１"
    @atom.entries[1].title.should == "テスト２"
    @atom.entries[2].title.should == "テスト３"  
  end
end

describe Atom::Feed, "のpublishedプロパティは、" do
  before do
    @atom = Atom::Feed.new
  end
  
  it "最初はnilで、" do
    @atom.published.should be_nil
  end
  
  it "Timeインスタンスをセットできて、" do
    @atom.published = Time.local(2008,10,3,12,15,30)
    @atom.published.strftime("%Y/%m/%d %H:%M:%S").should == "2008/10/03 12:15:30"
  end
  
  it "iso8601の日付文字列もセットできる。" do
    @atom.published = "2009-03-31T10:12:00+09:00"
    @atom.published.strftime("%Y/%m/%d %H:%M:%S").should == "2009/03/31 10:12:00"
  end
end

describe Atom::Feed, "に色々プロパティを設定して" do
  before(:all) do
    @compared_file = fs("files/write_compared.xml")
  end

  before do
    @feed = Atom::Feed.new
    @feed.id = "hoge"
    @feed.title = "タイトル"
    @feed.updated = Time.local(2009, 4, 1, 2, 37, 10)
    @feed.published = Time.local(2008, 12, 31, 18, 4, 10)
    @feed.content.text = "ほげふがぷー"
    @feed.entries.add { |entry| 
      entry.id = "hoge1"
      entry.title = "エントリ１"
      entry.content.text = "エントリ１ほげふがぷー"
    }
    @feed.entries.add { |entry| 
      entry.id = "hoge2"
      entry.title = "エントリ２"
      entry.content.text = "エントリ２ほげふがぷー"
    }
  end

  it "XMLファイルを生成すると、その内容が予期されたファイルと同じ" do
    File.open(f("feed_write_tmp.xml"), "w" ) { |file|
      @feed.write(file)
    }
    fs("feed_write_tmp.xml").should == @compared_file
  end

  after do
    File.delete(f("feed_write_tmp.xml"))
  end
end

