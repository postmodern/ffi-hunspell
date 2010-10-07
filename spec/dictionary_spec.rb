require 'spec_helper'
require 'ffi/hunspell/dictionary'

describe Hunspell::Dictionary do
  subject { Hunspell::Dictionary }

  let(:root) { '/usr/share/myspell' || ENV['HUNSPELL_ROOT'] }
  let(:path) { File.join(root,'en_US') }

  let(:aff_path) { "#{path}.aff" }
  let(:dic_path) { "#{path}.dic" }

  it "should open a dictionary file from a path" do
    subject.open(path) do |dict|
      dict.should_not be_nil
    end
  end

  it "should create a dictionary from '.aff' and '.dic' files" do
    dict = subject.new(aff_path,dic_path)
    dict.should_not be_nil

    dict.close
  end

  it "should close the dictionary" do
    dict = subject.open(path)
    dict.close

    dict.to_ptr.should be_nil
  end

  it "should provide the encoding of the dictionary files" do
    subject.open(path) do |dict|
      dict.encoding.should_not be_empty
    end
  end

  it "should check if a word is valid" do
    subject.open(path) do |dict|
      dict.should be_valid('dog')
      dict.should_not be_valid('dxg')
    end
  end

  it "should find the stems of a word" do
    subject.open(path) do |dict|
      dict.stem('fishing').should == %w[fishing fish]
    end
  end

  it "should suggest alternate spellings for words" do
    subject.open(path) do |dict|
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
