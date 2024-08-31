require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:notifiable).optional }
  end

  describe "validations" do
    it { should validate_inclusion_of(:notification_type).in_array(Notification::TYPES) }
    it { should validate_inclusion_of(:notifiable_type).in_array(Notification::NOTIFIABLES) }
  end
end
