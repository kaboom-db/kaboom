module ComicVine
  # ComicVine formats issue numbers as strings meaning we can have all sorts of weird edge cases when formatting it as a float.
  # Some basic examples are:
  # 616a - (refer to https://comicvine.gamespot.com/batman-616a-hush-interlude-the-cave/4000-542921/)
  # 18 + 1 - (refer to https://comicvine.gamespot.com/barakamon-18-1-vol-18-1/4000-782271/)
  # 18+1 - (refer to https://comicvine.gamespot.com/barakamon-181-vol-181/4000-1001599/)
  class IssueNumberFormatter
    ALPHABET = "abcdefghijklmnopqrstuvwxyz"

    def self.format(issue_number)
      plus_format_regex = /(\d+) *\+ *(\d+)/
      return issue_number.gsub(/ *\+ */, ".").to_f if plus_format_regex.match(issue_number)

      alphabetised_regex = /^(\d*\.\d+|\d+(\.\d+)?)([a-z|A-Z])$/
      if (match = alphabetised_regex.match(issue_number))
        letter = match[3].downcase
        number = match[1]
        letter_number = ALPHABET.index(letter) + 1
        extra_point = number.include?(".") ? "" : "."
        return "#{number}#{extra_point}#{letter_number}".to_f
      end

      issue_number.to_f
    end
  end
end
