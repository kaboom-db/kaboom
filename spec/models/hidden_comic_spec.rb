require "rails_helper"

RSpec.describe HiddenComic, type: :model do
  describe "associations" do
    it { should belong_to(:comic) }
    it { should belong_to(:user) }
  end
end
