module Photish
  module Gallery
    module Traits
      module Urlable
        def url
          [host, url_parts].flatten.join('/')
        end

        def url_path
          url_parts.join('/')
        end

        def url_parts
          base_url_parts + [url_end]
        end

        def base_url_parts
          parent.base_url_parts + [slugify(base_url_name)]
        end

        private

        def host
          normalized_host || ''
        end

        def normalized_host
          url_info.host.try(:chomp, '/')
        end

        def slugify(word)
          CGI.escape(word.downcase.gsub(' ', '-'))
        end
      end
    end
  end
end
