
# From https://github.com/davetron5000/gli/blob/gli-2/features/step_definitions/gli_executable_steps.rb
Given /^my terminal size is "([^"]*)"$/ do |terminal_size|
  if terminal_size =~/^(\d+)x(\d+)$/
    ENV['COLUMNS'] = $1
    ENV['LINES'] = $2
  else
    raise "Terminal size should be COLxLines, e.g. 80x24" 
  end
end

When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

Then /^the output should contain the version information$/ do
  expected = "#{@app_name} version #{Brightbox::VERSION}"
  assert_partial_output(expected, all_output)
end
