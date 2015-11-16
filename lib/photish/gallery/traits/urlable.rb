require 'cgi'

module Urlable
  def url
    url_parts.join('/')
  end

  def url_parts
    base_url_parts + ['index.html']
  end

  def base_url_parts
    parent.base_url_parts + [CGI.escape(name.downcase.gsub(' ', '-'))]
  end
end
