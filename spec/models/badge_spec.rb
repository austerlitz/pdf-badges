require 'rails_helper'

RSpec.describe Badge, type: :model do
  subject {build(:badge)}
  it {should be_kind_of(Badge)}

  context 'with default params' do
    it 'should be valid with default params' do
      should be_valid
    end

    it 'should generate a default pdf' do
      expect(subject.to_pdf).to be_kind_of(String) and start_with'%PDF'
    end
  end
end
