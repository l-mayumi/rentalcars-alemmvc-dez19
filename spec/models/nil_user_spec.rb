require 'rails_helper'

describe NilUser do
  describe '.admin?' do
    it 'should be false' do
      expect(described_class.new).not_to be_admin
    end
  end
end