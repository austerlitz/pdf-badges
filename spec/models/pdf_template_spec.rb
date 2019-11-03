require 'rails_helper'

RSpec.describe PdfTemplate, type: :model do
  subject {PdfTemplate.new}
  it {should be_kind_of(Prawn::Document)}
end
