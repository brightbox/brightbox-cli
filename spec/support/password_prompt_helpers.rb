require "highline"

module PasswordPromptHelpers
  # This password matches the testing users available on dev machines
  def default_test_password
    "N:B3e%7Cmh"
  end

  # Intercepts HighLine prompts for a one-time password (OTP) used as part of
  # two factor authentication (2FA). The prevents blocking the spec waiting for
  # input.
  #
  def mock_otp_entry(otp = "123456")
    input = instance_double(HighLine)

    expect(input).to receive(:ask).with("Enter your two factor pin : ")
                                  .once
                                  .and_return(otp)

    expect(HighLine).to receive(:new).once.and_return(input)
  end

  # Intercepts HighLine prompting for a password and returns the testing default
  # or a specific value. Otherwise this blocks the specs.
  #
  def mock_password_entry(password = default_test_password)
    input = instance_double(HighLine)

    allow(input).to receive(:say).with("Your API credentials have expired, enter your password to update them.")
    expect(input).to receive(:ask).with("Enter your password : ")
                                  .once
                                  .and_return(password)

    expect(HighLine).to receive(:new).once.and_return(input)
  end
end
