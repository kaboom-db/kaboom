# frozen_string_literal: true

require "rails_helper"

module Statistics
  RSpec.describe CollectedCount do
    it_behaves_like "a statistics counter", CollectedCount, :collected_issue, :collected_on
  end
end
