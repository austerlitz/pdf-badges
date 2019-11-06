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

    let(:pdf) {subject.to_pdf}
    let(:analysis) {PDF::Inspector::Page.analyze(pdf)}
    it 'should generate a default pdf' do
      expect(pdf).to be_kind_of(String) and start_with'%PDF'
    end

    context 'with Badge default data' do
      it 'has 2 pages' do
        expect(analysis.pages.size).to eq(2)
      end

      it 'has page format A5' do
        # .reverse because of landscape format
        expect(PDF::Core::PageGeometry::SIZES.invert[analysis.pages[0][:size].reverse]).to eq(subject.paper_size) # A5 by default
      end
      it 'has `Mary` in page 2' do
        expect(analysis.pages[1][:strings]).to include('Mary')
      end
    end

  end
end
