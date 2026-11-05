module ApplicationHelper
  # Returns the URL only if it is http(s), so user-supplied links that were
  # saved before validation existed can't inject `javascript:` into an href.
  def safe_url(url)
    url if HttpUrlValidator.valid?(url)
  end
end
