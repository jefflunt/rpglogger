namespace :db do
  desc "Manually match the `sort_order` field on the WorldObjectProperty class to the parent SectionPropertyClass"
  task :matchup_sort_order => :environment do
    properties_to_correct = WorldObjectProperty.all.select{|prop| prop.sort_order != prop.section_property.sort_order}
    puts "WorldObjectProperties to correct: #{properties_to_correct.count}"
    
    properties_to_correct.each do |prop_to_correct|
      prop_to_correct.update_attribute(:sort_order, prop_to_correct.section_property.sort_order)
    end
    
    WorldObject.reset_column_information
    properties_still_broken = WorldObjectProperty.all.select{|prop| prop.sort_order != prop.section_property.sort_order}
    puts "WorldObjectProperties still broken: #{properties_still_broken.count}"
  end
end