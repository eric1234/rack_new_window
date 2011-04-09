require 'rack_replace'

module Rack

  class NewWindow < Rack::Replace

    def initialize(app, options={})
      # Set defaults
      options[:include_non_html] = true unless options.has_key? :include_non_html
      options[:local_domains] = Array(options[:local_domains])

      super app, /\<a[^\>]*>/ do |env, link|
        link = Link.new link, options
        link.append_target! unless link.ignore?(env)
        link.to_s
      end
    end

  end

end

require 'rack/new_window/link'
