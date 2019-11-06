require 'rails_helper'

RSpec.describe Badge, type: :model do
  subject {build(:badge)}
  it {should be_kind_of(Badge)}

  context 'validations' do
    it { should validate_presence_of(:template) }
    it { should validate_presence_of(:data) }
    it { should validate_presence_of(:paper_size) }
    it { should validate_presence_of(:page_layout) }
    it { should validate_presence_of(:font) }
    it { should validate_presence_of(:margins) }

    it {should validate_inclusion_of(:paper_size).in_array(PDF::Core::PageGeometry::SIZES.keys)}
    it {should validate_inclusion_of(:font).in_array(PdfTemplate::DEFAULT_FONTS.keys)}
    it {should validate_inclusion_of(:page_layout).in_array(%i(portrait landscape))}
  end

  context 'with default params' do
    it 'should be valid with default params' do
      should be_valid
    end

    it 'should generate a default pdf' do
      expect(subject.to_pdf).to be_kind_of(String) and start_with'%PDF'
    end

  end
end
