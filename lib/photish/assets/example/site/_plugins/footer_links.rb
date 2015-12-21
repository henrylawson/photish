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
    html = ''
    links.each_with_index do |link, index|
      if index == (links.count - 1)
        text = link[:text]
      else
        text = "#{link[:text]} #{seperator} "
      end
      html << "<a href=\"" << link[:url] << "\">" << text << "</a>"
    end
    html
  end
end

