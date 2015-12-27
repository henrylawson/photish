module Photish
  module Gallery
    module Traits
      module Urlable
        def url
          @url ||= [host, url_parts].flatten.join('/')
        end

        def url_path
          @url_path ||= url_parts.join(File::SEPARATOR)
        end

        def url_parts
          @url_parts ||= base_url_parts + [url_end]
        end

        def base_url_parts
          @base_url_parts ||= parent.base_url_parts + [slugify(base_url_name)]
        end

        private

        def host
          @host ||= if url_info.type == 'absolute_uri'
                      url_info.host || ''
                    else
                      ''
                    end
        end

        def slugify(word)
          CGI.escape(word.downcase.gsub(' ', '-'))
        end
      end
    end
  end
end
