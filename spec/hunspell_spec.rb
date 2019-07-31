require 'spec_helper'
require 'ffi/hunspell/hunspell'

describe Hunspell do
  describe ".lang" do
    subject { super().lang }

    it "should have a default language" do
      expect(subject).to_not be_nil
      expect(subject).to_not be_empty
    end
  end

  describe ".directories" do
    subject { super().directories }

    it "should have directories to search within" do
      expect(subject).to_not be_empty
    end
  end

  describe ".add_directory" do
    subject { super().add_directory("/application/lib/directories") }

    it "should have directories to search within application lib directory" do
      expect(subject).to include("/application/lib/directories")
    end
  end

  describe ".dict" do
    it "should open a dictionary file" do
      subject.dict('en_US') do |dict|
        expect(dict).to_not be_nil
      end
    end

    it "should open the dictionary file for the default language" do
      subject.dict do |dict|
        expect(dict).to_not be_nil
      end
    end
  end
end
