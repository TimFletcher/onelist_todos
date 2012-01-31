module PaymentNotificationsHelper

  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert_#{Rails.env}.pem")
  ONELIST_CERT_PEM = File.read("#{Rails.root}/certs/onelist_cert.pem")
  ONELIST_KEY_PEM = File.read("#{Rails.root}/certs/onelist_key.pem")

  puts Rails.env

  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(ONELIST_CERT_PEM),
                                  OpenSSL::PKey::RSA.new(ONELIST_KEY_PEM, ''),
                                  values.map { |k, v| "#{k}=#{v}" }.join("\n"),
                                  [],
                                  OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)],
                            signed.to_der,
                            OpenSSL::Cipher::Cipher::new("DES3"),
                            OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

  def paypal_encrypted(user, return_url, notify_url)
    encrypt_for_paypal({
      :cmd        => '_xclick', # Buy Now button
      :business   => ENV['PAYPAL_SELLER_EMAIL'],
      :item_name  => 'Yearly fee for OneList',
      :amount     => OneListRails::Application.config.one_time_fee,
      :invoice    => user.id,
      :rm         => 1, # Return using GET, no transaction variables
      :cert_id    => ENV['PAYPAL_CERTIFICATE_ID'],
      :return     => return_url,
      :notify_url => notify_url
    })
  end

  def get_paypal_url()
      subdomain = Rails.env.production? ? '' : '.sandbox'
      "https://www#{subdomain}.paypal.com/cgi-bin/webscr?"
  end

  def trial_expiry_display(user)
    fee = OneListRails::Application.config.one_time_fee
    time = distance_of_time_in_words((user.created_at + OneListRails::Application.config.trial_period) - Time.now)
    link_body = user.within_trial? ? "Your free trial expires in #{time}\n" : ""
    link_body += "Sign up now for $#{fee}/year"
  end
end
