# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :minitest, test_file_patterns: '*_test.rb'  do
  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }
end

notification :tmux,
  display_message: true,
  timeout: 5, # in seconds
  default_message_format: '%s >> %s',
  # the first %s will show the title, the second the message
  # Alternately you can also configure *success_message_format*,
  # *pending_message_format*, *failed_message_format*
  line_separator: ' > ', # since we are single line we need a separator
  color_location: %w[status-left-bg pane-active-border-fg pane-border-fg]

