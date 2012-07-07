module MarkdownHelper
  def markdown_parse(text)
    allowed_tags = %w(blockquote a p b strong em i u code dfn samp kbd var cite)
    options = {
      remove_links: false,
      remove_images: true,
      smarty_pants: true,
      pseudoprotocols: false,
      strict_mode: true,
      auto_links: true,
      safe_links: false
    }
    
    sanitize(BlueCloth.new(text, options).to_html(), tags: allowed_tags)
  end
end