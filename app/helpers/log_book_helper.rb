# encoding: utf-8
module LogBookHelper
  def new_log_book_link
    link_to "✚", new_log_book_path
  end
  
  def delete_log_book_link(log_book)
    link_to "✖", log_book_path(log_book), method: :delete
  end
  
  def untrash_log_book_link(log_book)
    link_to "⟲", untrash_log_book_path(log_book.id), method: :put
  end
  
  def shared_log_book_icon
    "⥮"
  end
  
  def log_book_access_indicator_icon(log_book)
    if current_user.can_fully_manage?(log_book)
      log_book.deleted? ? untrash_log_book_link(log_book) : delete_log_book_link(log_book)
    elsif current_user.can_manage_world_objects_in?(log_book)
      "⥮"
    end
  end
end
