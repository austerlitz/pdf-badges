FactoryBot.define do
  factory :badge do
    initialize_with { new(Badge::DEFAULT_OPTIONS)}
  end
end
