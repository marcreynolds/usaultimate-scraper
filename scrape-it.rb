require "httparty"
require "nokogiri"
require "thor"

WINNING_SCORE = 15

class Scraper < Thor
  desc "match", "scrape a match report"
  option :url, type: :string
  option :match_id, type: :string
  def match
    url = if options[:url].nil?
            "https:\/\/play.usaultimate.org\/teams\/events\/match_report\/?EventGameId=#{options[:match_id]}"
          else
            options[:url]
          end
    uri = URI.parse(url)

    home_score = nil
    home_name = nil
    away_score = nil
    away_name = nil
    game_over = false
    while !game_over
      response = Net::HTTP.get_response(uri)

      doc = Nokogiri::HTML(response.body)

      name_pattern = /(.*) \(/
      new_home_score = doc.css("#home_score").text.strip.to_i
      home_name = doc.css("#CT_Main_0_lblHomeTeam").text.strip.match(name_pattern)[1] if home_name.nil?
      new_away_score = doc.css("#away_score").text.strip.to_i
      away_name = doc.css("#CT_Main_0_lblAwayTeam").text.strip.match(name_pattern)[1] if away_name.nil?

      score_changed = new_home_score != home_score || new_away_score != away_score

      if score_changed
        home_score_diff = new_home_score - home_score.to_i
        away_score_diff = new_away_score - away_score.to_i

        if home_score_diff > 0 && !home_score.nil?
          `say "#{home_name} just scored #{home_score_diff}"`
        elsif away_score_diff > 0 && !away_score.nil?
          `say "#{away_name} just scored #{away_score_diff}"`
        elsif !(away_score.nil? || home_score.nil?)
          `say "It's all tied up!"`
        end

        home_score = new_home_score
        away_score = new_away_score

        puts "#{home_name}: #{home_score}\n#{away_name}: #{away_score}"
        `say "#{home_name} has #{home_score} points"`
        `say "#{away_name} has #{away_score} points"`
        winning_name = home_score > away_score ? home_name : away_name

        game_over = doc.css("#match_report > div:nth-child(2) > p:nth-child(2)").text.downcase.include?("final")

        if game_over || home_score >= WINNING_SCORE || away_score >= WINNING_SCORE
          `say "#{winning_name} just won!"`
          `afplay ./sfx-victory1.mp3`
          game_over = true
        elsif home_score == away_score
          `say "it's all tied up!"`
        elsif home_score > 0 || away_score > 0
          `say "#{winning_name} is winning"`
        end
      end

      sleep 5
    end
  end
end

Scraper.start(ARGV)
