RSpec::Matchers.define :warn do |message|
  match do |block|
    fake_stderr(&block).include? message
  end

  description do
    "warn \"#{message}\""
  end

  failure_message_for_should do
    "expected to #{description}"
  end

  failure_message_for_should_not do
    "expected to not #{description}"
  end

  def fake_stderr
    original_stderr = $stderr
    $stderr = StringIO.new
    yield
    $stderr.string
  ensure
    $stderr = original_stderr
  end

  def supports_block_expectations?
    true
  end
end
