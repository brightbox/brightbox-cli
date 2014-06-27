require "highline"

module PasswordPromptHelpers
  # This password matches the testing users available on dev machines
  def default_test_password
    "N:B3e%7Cmh"
  end

  # Intercepts HighLine prompting for a password and returns the testing default
  # or a specific value. Otherwise this blocks the specs.
  #
  def mock_password_entry(password = default_test_password)
    expect_any_instance_of(HighLine).to receive(:ask).at_least(:once).and_return(password)
  end
end
