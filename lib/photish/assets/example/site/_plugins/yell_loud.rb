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
    text = "Yelling \"#{name}\" from a plugin!"
    "<span style=\"font-weight:bold;color:red;font-size:200%;\">#{text}</span>"
  end
end
