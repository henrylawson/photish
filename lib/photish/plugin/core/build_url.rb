module Photish
  module Plugin
    module Core
      module BuildUrl
        def self.is_for?(type)
          [
            Photish::Plugin::Type::Collection,
            Photish::Plugin::Type::Album,
            Photish::Plugin::Type::Photo
          ].include?(type)
        end

        def build_url(*pieces)
          url_pieces = []
          url_pieces << host
          url_pieces << url_info.base
          url_pieces << pieces
          url_pieces.flatten
                    .compact
                    .join('/')
        end
      end
    end
  end
end
