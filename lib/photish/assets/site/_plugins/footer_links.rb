require 'nokogiri'

module Photish::Plugin::FooterLinks

  def self.is_for?(type)
    [
      Photish::Plugin::Type::Collection,
      Photish::Plugin::Type::Album,
      Photish::Plugin::Type::Photo,
      Photish::Plugin::Type::Image
    ].include?(type)
  end

  def links_with_seperator(links, seperator)
    doc = Nokogiri::HTML::DocumentFragment.parse("")
    Nokogiri::HTML::Builder.with(doc) do |doc|
      links.each_with_index do |link, index|
        if index == (links.count - 1)
          text = link[:text]
        else
          text = "#{link[:text]} #{seperator} "
        end

        doc.a(text, href: link[:url])
      end
    end
    doc.to_html
  end

  private

  def text(link_text, seperator)

  end
end

