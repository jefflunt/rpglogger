module RpgloggerParserHelper
  def rpglogger_parse(text)
    text = replace_internal_links(text)
    
    markdown_parse(text)
  end
  
  private
    def replace_internal_links(text)
      # Find valid links and split them up into their component parts
      # and remove whitespace
      return nil if text.nil?
      
      parsed_text = text.gsub(/\[\[.+?\]\]\[\s*?\d+\s*?\]/) { |match|
        component_parts = match.split("][").each{|part| part.gsub!(/\[|\]/, '').strip!}
        
        begin
          world_object = WorldObject.find(component_parts[1])
          link = "<a href=\"#{section_url(world_object.section.id)}##{world_object.id}\">#{component_parts[0]}</a>"
        rescue ActiveRecord::RecordNotFound
          link = match
        end
        
        link
      }
      
      parsed_text || text  # Either give me back the link, or the original if no matches were found
    end
end