module MarkdownHelper
  def markdown_parse(text)
    options = {
      
    }
    sanitize(BlueCloth.new(text, options).to_html())
  end
end