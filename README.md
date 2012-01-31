http://onelistapp.co written with Ruby on Rails 3.1

## Installation

Copy `database.yml.template` and add the appropriate credentials.

Create the following environment variables with the appropriate values. You'll need Amazon's SES added to your AWS account:

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    PAYPAL_SELLER_EMAIL

Paypal needs to be configured to use encryption. For this you must generate a public / private key pair in a `certs` directory in the project root:

    mkdir <rails-root>/certs
    cd <rails-root>/certs
    openssl genrsa -out onelist_key.pem 1024
    openssl req -new -key onelist_key.pem -x509 -days 365 -out onelist_cert.pem

Then you need to configure PayPal:

  * Log in with seller account
  * Profile > Encrypted Payment Settings
  * Upload public key
  * Download PayPal's public key, rename to `paypal_cert.pem` and put in `certs`
  * Profile > Website Payment Preferences
  * Click radio button for **Block Non-encrypted**
