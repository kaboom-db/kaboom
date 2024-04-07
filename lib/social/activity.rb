module Social
  class Activity
    include Rails.application.routes.url_helpers

    attr_reader :record

    def initialize(record:)
      @record = record
    end

    def content = ""

    def link = nil

    def timestamp = nil

    def image = nil

    def type = self.class.to_s

    def user = @user ||= record.user
  end
end
