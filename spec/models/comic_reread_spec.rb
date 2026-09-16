require 'rails_helper'

RSpec.describe ComicReread, type: :model do
  describe "associations" do
    it { should belong_to(:comic) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:reread_started_at) }
  end
end
