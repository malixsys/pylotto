require 'flyingv'


# encoding: utf-8
Given /^we have the following tickets:$/ do |table|
  @tickets = table.raw
  #puts eval(@tickets.to_s)
end

When /^I enter "([^"]*)"$/ do |command|
  @command = command
end

When /^I run the program$/ do
  @output = `ruby lotto.rb #{@command}`
  raise('Command failed!') unless $?.success?
end

Then /^the output should be "([^"]*)"$/ do |expected_output|
  @output.should == expected_output
end

Then /^we should have the following tickets:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending 
end