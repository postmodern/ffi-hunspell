require 'spec_helper'
require 'ffi/hunspell/dictionary'

describe Hunspell::Dictionary do
  subject { Hunspell::Dictionary }

  let(:lang) { 'en_US' }

  let(:affix_path) { File.join(Hunspell.directories.last,"#{lang}.aff") }
  let(:dic_path) { File.join(Hunspell.directories.last,"#{lang}.dic") }

  describe "#initialize" do
    subject { described_class }

    it "should create a dictionary from '.aff' and '.dic' files" do
      dict = subject.new(affix_path,dic_path)
      dict.should_not be_nil

      dict.close
    end
  end

  describe "open" do
    subject { described_class }

    it "should find and open a dictionary file for a given language" do
      subject.open(lang) do |dict|
        dict.should_not be_nil
      end
    end

    it "should close the dictionary" do
      dict = subject.open(lang)
      dict.close

      dict.should be_closed
    end

    context "when given an unknown dictionary name" do
      it "should raise an ArgumentError" do
        lambda {
          subject.open('foo')
        }.should raise_error(ArgumentError)
      end
    end
  end

  subject { described_class.new(affix_path,dic_path) }

  after(:all) { subject.close }

  it "should provide the encoding of the dictionary files" do
    subject.encoding.should == Encoding::ISO_8859_1
  end

  it "should check if a word is valid" do
    subject.should be_valid('dog')
    subject.should_not be_valid('dxg')
  end

  describe "#stem" do
    it "should find the stems of a word" do
      subject.stem('fishing').should == %w[fishing fish]
    end

    context "when there are no stems" do
      it "should return []" do
        subject.stem("zzzzzzz").should == []
      end
    end
  end

  describe "#suggest" do
    it "should suggest alternate spellings for words" do
      subject.suggest('arbitrage').should include(*[
        'arbitrage',
        'arbitrages',
        'arbitrager',
        'arbitraged',
        'arbitrate'
      ])
    end

    context "when there are no suggestions" do
      it "should return []" do
        subject.suggest("________").should == []
      end
    end
  end
end
