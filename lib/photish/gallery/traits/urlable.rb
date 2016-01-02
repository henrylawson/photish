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

        def host
          @host ||= absolute_uris? ? url_info_host : ''
        end

        private

        def slugify(word)
          CGI.escape(word.downcase.gsub(' ', '-'))
        end

        def absolute_uris?
          url_info.type == 'absolute_uri'
        end

        def url_info_host
          url_info.host || ''
        end
      end
    end
  end
end
