require "highline"

module PasswordPromptHelpers

  # This password matches the testing users available on dev machines
  def default_test_password
    "N:B3e%7Cmh"
  end

  # Intercepts HighLine prompting for a password and returns the testing default
  # or a specific value. Otherwise this blocks the specs.
  #
  # @todo If we use HighLine in multiple places then this needs expanding
  #
  def mock_password_entry(password = default_test_password)
    HighLine.any_instance.should_receive(:ask).and_return(password)
  end
end
