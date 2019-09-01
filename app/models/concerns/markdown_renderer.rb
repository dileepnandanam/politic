class MarkdownRenderer
  def self.render(text)
    evaluate text.to_s
  end

  def self.evaluate(markdown_text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      fenced_code_blocks: true,
      autolink: true
    )
    MarkdownRails.configure do |config|
      config.render do |markdown_source|
        markdown.render(markdown_source)
      end
      .call(markdown_text).html_safe
    end
  end

  def self.escape(text)
    text.gsub(/\n/, "<br \/>")
  end
end