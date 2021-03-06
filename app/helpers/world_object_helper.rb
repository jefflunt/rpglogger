# encoding: utf-8
module WorldObjectHelper
  def world_object_title_or_link(world_object, can_manage_world_objects)
    if world_object.archived?
      markdown_parse(world_object.name)
    elsif can_manage_world_objects
      link_to markdown_parse(world_object.name), edit_section_world_object_path(world_object.section.id, world_object.id)
    else
      markdown_parse(world_object.name)
    end
  end
  
  def archive_or_restore_world_object(world_object, can_manage_world_objects)
    if can_manage_world_objects
      if world_object.archived?
        return link_to "⟲", restore_section_world_object_path(world_object.section.id, world_object.id), method: :put, rel: "nofollow", title: "Restore Record"
      else
        return link_to "✖", archive_section_world_object_path(world_object.section.id, world_object.id), method: :put, rel: "nofollow", title: "Archive Record"
      end
    end
  end
end
