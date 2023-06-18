module Gravatar
  class Image
    attr_accessor :email

    def initialize(email:)
      @email = email
    end

    def get
      "https://www.gravatar.com/avatar/#{email_hash}?d=retro"
    end

    private

    def email_hash = Digest::MD5.hexdigest(email)
  end
end
