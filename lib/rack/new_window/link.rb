class Rack::NewWindow::Link

  def initialize(tag, options)
    @tag = tag
    @options = options
  end

  # Should this tag be ignored (i.e. not appended)
  def ignore?(env)
    already_targeted? || manually_overridden? ||
    (local_domain?(env) && extension_local?)
  end

  # Append a target of a new window to this link
  def append_target!
    @tag.gsub! /\<a/, '<a target="_blank"'
  end

  # Print the link
  def to_s
    @tag
  end

  private

  def uri
    @uri ||= URI.parse(@tag.scan(/href\s*=\s*"([^"]+)"/)[0][0]) rescue nil
  end

  def already_targeted?
    @tag.include?('target')
  end

  def manually_overridden?
    @tag.include?('local')
  end

  def extension_local?
    return true unless @options[:include_non_html]
    extension = File.extname uri.path if uri.respond_to?(:path) && uri.path
    extension == '.html' || (extension || '').strip == ''
  end

  def local_domain?(env)
    return true if !uri || !uri.host
    request_domain = Rack::Request.new(env).host
    request_domain = request_domain.split('.', 2).last if
      request_domain.split('.', 2).first == 'www' 
    (@options[:local_domains] + [request_domain]).any? {|d| uri.host.include?(d)}
  end

end
