# frozen_string_literal: true

require "rails_helper"

module Gravatar
  RSpec.describe Image do
    let(:email) { "test@example.com" }

    it "returns a Gravatar avatar url" do
      expect(Image.new(email:).get).to eq "https://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?d=retro"
    end
  end
end
