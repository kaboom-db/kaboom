require 'rails_helper'

RSpec.describe Visit, type: :model do
  describe "associations" do
    it { should belong_to(:user).optional }
    it { should belong_to(:visited) }
  end
end
