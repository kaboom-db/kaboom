require "ostruct"

class RatingPresenter
  attr_reader :rateable

  def initialize(rateable:)
    @rateable = rateable
  end

  def average_rating
    return @average_rating if @average_rating
    ratings = rateable.ratings
    num_of_ratings = ratings.load.count.to_f
    sum_of_ratings = ratings.sum(&:score)
    @average_rating = sum_of_ratings / num_of_ratings
  end

  # TN_TODO: Actual reviews
  def top_reviews
    classes = [
      "from-[#00df77] hover:bg-[#00df77]",
      "from-[#e0ca3c] hover:bg-[#e0ca3c] md:ml-8",
      "from-[#f6504b] hover:bg-[#f6504b] md:ml-16"
    ]
    [
      OpenStruct.new(
        title: "Pretty good comic overall",
        score: 7,
        user: OpenStruct.new(username: "comicbooklover123"),
        likes: OpenStruct.new(count: 1245),
        colour: classes[0]
      ),
      OpenStruct.new(
        title: "Not too sure how to feel about this one...",
        score: 5,
        user: OpenStruct.new(username: "Onthefence123"),
        likes: OpenStruct.new(count: 453),
        colour: classes[1]
      ),
      OpenStruct.new(
        title: "I hate this comic.",
        score: 2,
        user: OpenStruct.new(username: "comicbookhater123"),
        likes: OpenStruct.new(count: 189),
        colour: classes[2]
      ),
      OpenStruct.new(
        title: "Lovely writing!",
        score: 8,
        user: OpenStruct.new(username: "obi-wan-kenobi"),
        likes: OpenStruct.new(count: 102),
        colour: classes[0]
      ),
      OpenStruct.new(
        title: "Very mediocre imho",
        score: 6,
        user: OpenStruct.new(username: "boxbox"),
        likes: OpenStruct.new(count: 97),
        colour: classes[1]
      ),
      OpenStruct.new(
        title: "Wow. Not good at all.",
        score: 1,
        user: OpenStruct.new(username: "witch123"),
        likes: OpenStruct.new(count: 4),
        colour: classes[2]
      )
    ].sample(3).sort_by { _1.likes.count }.reverse
  end
end
