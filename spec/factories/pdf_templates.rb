FactoryBot.define do
  factory :pdf_template do
    # use default options for a default factory
    initialize_with { new(PdfTemplate::DEFAULT_OPTIONS)}
  end
end
