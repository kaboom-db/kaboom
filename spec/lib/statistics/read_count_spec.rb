# frozen_string_literal: true

require "rails_helper"

module Statistics
  RSpec.describe ReadCount do
    it_behaves_like "a statistics counter", ReadCount, :read_issue, :read_at
  end
end
