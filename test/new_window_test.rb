Bundler.require :default, :development

require 'rack/builder'
require 'rack/mock'

require 'test/unit'
class NewWindowTest < Test::Unit::TestCase

  def link(tag, options={})
    app = Rack::Builder.new do
      use Rack::NewWindow, options
      run proc {|env| [200, {}, [tag]]}
    end.to_app
    @mock = Rack::MockRequest.new app
  end

  def test_appended
    link '<a href="http://google.com">Test</a>'
    assert_equal '<a target="_blank" href="http://google.com">Test</a>', @mock.get('http://example.com/').body
  end

  # We know the link is un-touched if the target is still at the end of the tag
  def test_already_targeted
    link '<a href="/foo" target="_blank">Test</a>'
    assert_equal '<a href="/foo" target="_blank">Test</a>', @mock.get('http://example.com/').body

    link '<a href="http://google.com" target="_blank">Test</a>'
    assert_equal '<a href="http://google.com" target="_blank">Test</a>', @mock.get('http://example.com/').body
  end

  def test_manual_override
    link '<a href="http://google.com" class="local">Test</a>'
    assert_equal '<a href="http://google.com" class="local">Test</a>', @mock.get('http://example.com/').body
  end

  def test_no_extension
    link '<a href="/foo">Test</a>'
    assert_equal '<a href="/foo">Test</a>', @mock.get('http://example.com/').body
  end

  def test_html_extension
    link '<a href="/foo.html">Test</a>'
    assert_equal '<a href="/foo.html">Test</a>', @mock.get('http://example.com/').body
  end

  def test_non_html_extension
    link '<a href="/foo.pdf">Test</a>'
    assert_equal '<a target="_blank" href="/foo.pdf">Test</a>', @mock.get('http://example.com/').body
  end

  def test_extension_disabled
    link '<a href="/foo.pdf">Test</a>', :include_non_html => false
    assert_equal '<a href="/foo.pdf">Test</a>', @mock.get('http://example.com/').body
  end

  def test_non_encoded
    link '<a href="/not encoded.pdf">Test</a>'
    assert_equal '<a target="_blank" href="/not encoded.pdf">Test</a>', @mock.get('http://example.com/').body
  end

  def test_request_domain
    link '<a href="http://example.com/foo">Test</a>'
    assert_equal '<a href="http://example.com/foo">Test</a>', @mock.get('http://example.com/').body
  end

  def test_request_subdomain
    link '<a href="http://www.example.com/foo">Test</a>'
    assert_equal '<a href="http://www.example.com/foo">Test</a>', @mock.get('http://example.com/').body
  end

  def test_www_request_domain
    link '<a href="http://example.com/foo">Test</a>'
    assert_equal '<a href="http://example.com/foo">Test</a>', @mock.get('http://www.example.com/').body
  end

  def test_configured_domain
    link '<a href="http://google.com/foo">Test</a>', :local_domains => 'google.com'
    assert_equal '<a href="http://google.com/foo">Test</a>', @mock.get('http://example.com/').body
  end

end
