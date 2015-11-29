module Photish
  module Gallery
    module Traits
      module Breadcrumbable
        def breadcrumbs
          doc = Nokogiri::HTML::DocumentFragment.parse("")
          Nokogiri::HTML::Builder.with(doc) do |doc|
            doc.ul(class: 'breadcrumbs') {
              parents_and_me.each_with_index do |level, index|
                doc.li(class: crumb_class(index)) {
                  doc.a(level.name, href: level.url)
                }
              end
            }
          end
          doc.to_html
        end

        def parents_and_me
          [parent.try(:parents_and_me), self].flatten.compact
        end

        private

        def crumb_class(index)
          crumb_class = []
          crumb_class << 'breadcrumb'
          crumb_class << "crumb-#{index}"
          crumb_class << 'crumb-first' if index == 0
          crumb_class << 'crumb-last' if index == (parents_and_me.count - 1)
          crumb_class << 'crumb-only' if parents_and_me.count == 1
          crumb_class.join(' ')
        end
      end
    end
  end
end
