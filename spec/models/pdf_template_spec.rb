require 'rails_helper'

RSpec.describe PdfTemplate, type: :model do
  subject {build(:pdf_template)}
  let(:default_pdf) {subject.to_pdf}

  it {should be_kind_of(Prawn::Document)}

  context 'defaults' do
    it 'should render a pdf with default name there' do
      pdf_analysis = PDF::Inspector::Text.analyze(default_pdf)
      expect(pdf_analysis.strings).to include('John Snow')
    end

    it 'should render a pdf with default paper size' do

      page_analysis = PDF::Inspector::Page.analyze(default_pdf)
      expect(page_analysis.pages.size).to eq(1)
      expect(page_analysis.pages[0][:size]).to eq PDF::Core::PageGeometry::SIZES['A4']
    end
  end

  context 'custom params' do
    let(:pdf) { PdfTemplate.new data: {name: 'Sarah Connor'}, paper_size: 'A5'}
    let(:two_page_pdf) { PdfTemplate.new data: [{name: 'Sarah Connor'}, {name: 'Terminator T-800'}], paper_size: 'A5'}
    it 'renders a pdf with custom name provided' do
      pdf_analysis = PDF::Inspector::Text.analyze(pdf.to_pdf)
      expect(pdf_analysis.strings).to include('Sarah Connor')
    end
    it 'renders a pdf with custom paper size' do
      page_analysis = PDF::Inspector::Page.analyze(pdf.to_pdf)
      expect(page_analysis.pages[0][:size]).to eq PDF::Core::PageGeometry::SIZES['A5']
    end
    it 'renders a two-page pdf if a two-rows array is provided' do
      page_analysis = PDF::Inspector::Page.analyze(two_page_pdf.to_pdf)
      expect(page_analysis.pages.size).to eq(2)
    end
  end
end
