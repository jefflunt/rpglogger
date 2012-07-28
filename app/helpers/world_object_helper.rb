# encoding: utf-8
module WorldObjectHelper
  def world_object_title_or_link(world_object, can_manage_world_objects)
    if world_object.deleted?
      markdown_parse(world_object.name)
    elsif can_manage_world_objects
      link_to markdown_parse(world_object.name), edit_section_world_object_path(world_object.section.id, world_object.id)
    else
      markdown_parse(obj.name)
    end
  end
  
  def delete_or_untrash_world_object(world_object, can_manage_world_objects)
    if can_manage_world_objects
      if world_object.deleted?
        return link_to "⟲", untrash_section_world_object_path(section.id, obj.id), method: :put, rel: "nofollow", title: "Restore Record"
      else
        return link_to "✖", section_world_object_path(world_object.section.id, world_object.id), method: :delete, rel: "nofollow", title: "Delete Record"
      end
    end
  end
end
