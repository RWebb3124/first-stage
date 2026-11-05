class HttpUrlValidator < ActiveModel::EachValidator
  def self.valid?(value)
    uri = URI.parse(value.to_s.strip)
    uri.is_a?(URI::HTTP) && uri.host.present?
  rescue URI::InvalidURIError
    false
  end

  def validate_each(record, attribute, value)
    return if self.class.valid?(value)

    record.errors.add(attribute, options[:message] || "must be a full link starting with http:// or https://")
  end
end
