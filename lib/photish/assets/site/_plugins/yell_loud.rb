require 'nokogiri'

module Photish::Plugin::YellLoud

  def self.is_for?(type)
    [
      Photish::Plugin::Type::Collection,
      Photish::Plugin::Type::Album,
      Photish::Plugin::Type::Photo,
      Photish::Plugin::Type::Image
    ].include?(type)
  end

  def yell_very_loud
    doc = Nokogiri::HTML::DocumentFragment.parse("")
    Nokogiri::HTML::Builder.with(doc) do |doc|
      doc.span("Yelling \"#{name}\" from a plugin!",
               style: 'font-weight:bold;color:red;font-size:200%;')
    end
    doc.to_html
  end
end
