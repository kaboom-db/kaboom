namespace :export do
  desc "Export users"
  task export_to_seeds: :environment do
    Comic.all.each_with_index do |comic, index|
      excluded_keys = ["created_at", "updated_at", "id"]
      serialized = comic
        .serializable_hash
        .delete_if { |key, value| excluded_keys.include?(key) }
        .map { |key, value| [key, (value.is_a?(ActiveSupport::TimeWithZone) || value.is_a?(Date)) ? value.to_s : value] }
        .to_h
      puts "\ncomic_#{index} = Comic.create!(#{serialized})"

      comic.issues.each do |issue|
        serialized = issue
          .serializable_hash
          .delete_if { |key, value| excluded_keys.include?(key) || key == "comic_id" }
          .map { |key, value| [key, (value.is_a?(ActiveSupport::TimeWithZone) || value.is_a?(Date)) ? value.to_s : value] }
          .to_h
        puts "comic_#{index}.issues.create!(#{serialized})"
      end
    end
  end
end
