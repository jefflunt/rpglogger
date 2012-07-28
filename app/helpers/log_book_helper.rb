module LogBookHelper
  def new_log_book_link
    link_to "\u271a", new_log_book_path
  end
  
  def delete_log_book_link(log_book)
    link_to "\u2716", log_book_path(log_book), method: :delete
  end
  
  def untrash_log_book_link(log_book)
    link_to "\u27f2", untrash_log_book_path(log_book.id), method: :put
  end
  
  def shared_log_book_icon
    "\u296e"
  end
  
  def log_book_access_indicator_icon(log_book)
    if current_user.can_fully_manage?(log_book)
      log_book.deleted? ? untrash_log_book_link(log_book) : delete_log_book_link(log_book)
    elsif current_user.can_manage_world_objects_in?(log_book)
      "\u296e"
    end
  end
end
