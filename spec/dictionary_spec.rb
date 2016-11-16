require 'spec_helper'
require 'ffi/hunspell/dictionary'

describe Hunspell::Dictionary do
  subject { described_class }

  let(:lang) { 'en_US' }
  let(:affix_path) { File.join(Hunspell.directories.last,"#{lang}.aff") }
  let(:dic_path)   { File.join(Hunspell.directories.last,"#{lang}.dic") }

  describe "#initialize" do
    subject { described_class.new(affix_path,dic_path) }

    it "should create a dictionary from '.aff' and '.dic' files" do
      expect(subject.to_ptr).to_not be_nil
    end

    after { subject.close }
  end

  describe ".open" do
    subject { described_class }

    it "should find and open a dictionary file for a given language" do
      subject.open(lang) do |dict|
        expect(dict).to_not be_nil
      end
    end

    it "should close the dictionary" do
      dict = subject.open(lang)
      dict.close

      expect(dict).to be_closed
    end

    context "when given an unknown dictionary name" do
      it "should raise an ArgumentError" do
        expect {
          subject.open('foo')
        }.to raise_error(ArgumentError)
      end
    end
  end

  context "when opened" do
    subject { described_class.new(affix_path,dic_path) }

    after { subject.close }

    it "should provide the encoding of the dictionary files" do
      expect(subject.encoding).to be_instance_of Encoding
    end

    it "should check if a word is valid" do
      expect(subject.valid?('dog')).to be true
      expect(subject.valid?('dxg')).to be false
    end

    describe "#add_dic" do
      if FFI::Hunspell.respond_to?(:Hunspell_add_dic)
        context "when libhunspell supports add_dic" do
            before { subject.add_dic(File.join(File.dirname(File.realpath(__FILE__)), 'files/extra.dic')) }

          it "should add an extra dictionary" do
            expect(subject.add_dic(File.join(File.dirname(File.realpath(__FILE__)), 'files/extra.dic'))).to be 0
          end

          it "should validate a word from the extra dictionary" do
            expect(subject.valid?('dxg')).to be true
          end

          it "should validate an affixed word based on an affix flag from base affix file" do
            expect(subject.valid?('dxgs')).to be true
          end
        end
      else
        context "when libhunspell does not support add_dic" do
          it "should raise an error" do
            expect { subject.add_dic(File.join(File.dirname(File.realpath(__FILE__)), 'files/extra.dic')) }.to raise_error(NotImplementedError)
          end
        end
      end
    end

    describe "#stem" do
      it "should find the stems of a word" do
        expect(subject.stem('fishing')).to be == %w[fishing fish]
      end

      it "should force_encode all strings" do
        expect(subject.suggest('fishing')).to all satisfy { |string|
          string.encoding == subject.encoding
        }
      end

      context "when there are no stems" do
        it "should return []" do
          expect(subject.stem("zzzzzzz")).to be == []
        end
      end
    end

    describe "#suggest" do
      it "should suggest alternate spellings for words" do
        expect(subject.suggest('arbitrage')).to include(
          'arbitrage',
          'arbitrages',
          'arbitrager',
          'arbitraged',
          'arbitrate'
        )
      end

      it "should force_encode all strings" do
        expect(subject.suggest('arbitrage')).to all satisfy { |string|
          string.encoding == subject.encoding
        }
      end

      context "when there are no suggestions" do
        it "should return []" do
          expect(subject.suggest("________")).to be == []
        end
      end
    end
  end
end
