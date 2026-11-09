require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "safe_url keeps http and https links" do
    assert_equal "https://github.com/bob", safe_url("https://github.com/bob")
    assert_equal "http://example.com", safe_url("http://example.com")
  end

  test "safe_url drops anything that could run script" do
    ["javascript:alert(1)", "JaVaScRiPt:alert(1)", " javascript:alert(1)", "data:text/html,<script>"].each do |url|
      assert_nil safe_url(url), "expected #{url.inspect} to be dropped"
    end
  end

  test "safe_url drops blank and incomplete links" do
    [nil, "", "https://", "github.com/bob"].each do |url|
      assert_nil safe_url(url), "expected #{url.inspect} to be dropped"
    end
  end
end
