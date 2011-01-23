require 'spec_helper'
require 'ffi/hunspell/dictionary'

describe Hunspell::Dictionary do
  subject { Hunspell::Dictionary }

  let(:lang) { 'en_US' }

  let(:affix_path) { File.join(Hunspell.directories.last,"#{lang}.aff") }
  let(:dic_path) { File.join(Hunspell.directories.last,"#{lang}.dic") }

  it "should find and open a dictionary file for a given language" do
    subject.open(lang) do |dict|
      dict.should_not be_nil
    end
  end

  it "should create a dictionary from '.aff' and '.dic' files" do
    dict = subject.new(affix_path,dic_path)
    dict.should_not be_nil

    dict.close
  end

  it "should close the dictionary" do
    dict = subject.open(lang)
    dict.close

    dict.should be_closed
  end

  it "should provide the encoding of the dictionary files" do
    subject.open(lang) do |dict|
      dict.encoding.should_not be_empty
    end
  end

  it "should check if a word is valid" do
    subject.open(lang) do |dict|
      dict.should be_valid('dog')
      dict.should_not be_valid('dxg')
    end
  end

  it "should find the stems of a word" do
    subject.open(lang) do |dict|
      dict.stem('fishing').should == %w[fishing fish]
    end
  end

  it "should suggest alternate spellings for words" do
    subject.open(lang) do |dict|
      dict.suggest('arbitrage').should == %w[
        arbitrage
        arbitrages
        arbitrager
        arbitraged
        arbitrate
      ]
    end
  end
end
