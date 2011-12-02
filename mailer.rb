require 'net/smtp'

def send_email(to, opts={})
  opts[:server]      ||= 'localhost'
  opts[:from]        ||= 'mailer@dims.kz'
  opts[:from_alias]  ||= 'Dims Server Mailer'
  opts[:subject]     ||= "<no subject>"
  opts[:body]        ||= "<no body>"
  opts[:content_type] ||= "text/plain"
  opts[:content_type] += '; charset=utf-8'

  msg = <<END_OF_MESSAGE
From: #{opts[:from_alias]} <#{opts[:from]}>
To: <#{to}>
Subject: #{opts[:subject]}
Content-Type: #{opts[:content_type]}

#{opts[:body]}
END_OF_MESSAGE

  Net::SMTP.start(opts[:server]) do |smtp|
    smtp.send_message msg, opts[:from], to
  end
end

