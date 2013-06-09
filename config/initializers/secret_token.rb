# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
DeployDemoApp::Application.config.secret_key_base = 'e13701b3b4b4467bf74cc358ae92dfc49f4a650c0d595d3b75359cb318ffc73e6becf5ed0cd8a74de43b241265237b0477d0eae41a988011d43fbb8e3a89207e'
