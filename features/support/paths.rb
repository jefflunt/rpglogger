module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /the LogBooks index page/
      log_books_path
    when /the show LogBook page for "([^\"]*)"/
      log_book_path(LogBook.find_by_title($1))
    when /the new LogBooks page/
      new_log_book_path
    when /the new WorldObjects page of section "([^\"]*)"/
      section = Section.find_by_name($1)
      new_section_world_object_path(section.id)
    when /the edit LogBook page for "([^\"]*)"/
      log_book = LogBook.find_by_title($1)
      edit_log_book_path(log_book)
    when /the edit page for the first section in LogBook "([^\"]*)/
      log_book = LogBook.find_by_title($1)
      edit_section_path(log_book.sections.first)
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
