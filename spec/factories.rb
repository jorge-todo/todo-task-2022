FactoryBot.define do
  factory :item do
    title { "Task-#{Random.rand(100)}" }
  end
end