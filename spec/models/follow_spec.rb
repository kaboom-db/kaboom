require "rails_helper"

RSpec.describe Follow, type: :model do
  describe "associations" do
    it { should belong_to(:target).class_name("User") }
    it { should belong_to(:follower).class_name("User") }
  end
end
