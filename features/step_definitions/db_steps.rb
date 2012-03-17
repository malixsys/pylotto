require File.expand_path(File.dirname(__FILE__) + "/../support/my_net")

When /^I save "([^"]*)"$/ do |input|
  DB.save input
end

Then /^load should return "([^"]*)"$/ do |expected_output|
  DB.load.should == expected_output
end