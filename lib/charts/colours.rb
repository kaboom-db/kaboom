module Charts
  class Colours
    attr_reader :colours

    def initialize
      set_enum
    end

    def next
      @enum.next
    rescue StopIteration
      set_enum
      @enum.next
    end

    private

    def set_enum = @enum = Constants::CHART_COLOURS.each
  end
end
