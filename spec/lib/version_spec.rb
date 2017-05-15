require 'spec_helper'
describe Capcoauth do
  describe '#gem_version' do
    subject { Capcoauth.gem_version }

    it 'has a Gem::Version version' do
      expect(subject).to be_a(Gem::Version)
    end
    it 'has semver format' do
      parts = subject.to_s.split('.')
      expect(parts.length).to eq(3)
      parts.each do |part|
        expect(part.to_i.to_s).to eq(part)
      end
    end
  end
end

describe Capcoauth::VERSION do
  it 'has integer parts' do
    expect(Capcoauth::VERSION::MAJOR).to be_an(Integer)
    expect(Capcoauth::VERSION::MINOR).to be_an(Integer)
    expect(Capcoauth::VERSION::PATCH).to be_an(Integer)
  end
end
