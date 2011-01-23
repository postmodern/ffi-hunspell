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
end
