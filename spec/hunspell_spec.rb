require 'spec_helper'
require 'ffi/hunspell/hunspell'

describe Hunspell do
  it "should have a default language" do
    subject.lang.should_not be_nil
    subject.lang.should_not be_empty
  end

  it "should have directories to search within" do
    subject.directories.should_not be_empty
  end

  it "should open a dictionary file" do
    subject.dict('en_US') do |dict|
      dict.should_not be_nil
    end
  end

  it "should open the dictionary file for the default language" do
    subject.dict do |dict|
      dict.should_not be_nil
    end
  end
end
