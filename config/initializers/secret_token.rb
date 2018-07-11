# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

Ilp2.Application.config.secret_token = ENV['SECRET_TOKEN'] || 'f7a20d7674aaccb7f40df79b45f0856bb7b97934f09122d8b8a169c129b8491faf84f236ea6d8970288c6b08f148adc35a1ee54bbdbf919e654e69bfa84a679f'
Ilp2.Application.config.secret_key_base = ENV['SECRET_KEY_BASE'] || 'c5e2cacfd7fcd19856c89251d75726705cbef3b03faee5c3e7f893c96a6d6378cf5172436f8629e28beb65a65e7d76fa2cc1decdb1a1c7f93e8729cb1574779e'
