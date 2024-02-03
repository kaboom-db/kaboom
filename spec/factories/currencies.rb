FactoryBot.define do
  factory :currency do
    symbol { "£" }
    symbol_native { "£" }
    name { "British Pound Sterling" }
    decimal_digits { 1 }
    rounding { 1 }
    name_plural { "British pounds sterling" }
    code { "GBP" }
  end
end
