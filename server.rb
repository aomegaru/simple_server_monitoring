require_relative 'mailer'

free_storage_space = `df -h /`;
free_ram = `free`;
uptime = `uptime`;
running_processes = `ps -ef`;

body = "<h3>Uptime</h3><p>#{uptime}</p>";
body += "<h3>Free Storage Space</h3><p>#{free_storage_space}</p>"
body += "<h3>Free RAM &amp; Running processes</h3>"
body += "<p>#{free_storage_space}</p><p><pre><code>#{running_processes}</code></pre></p>"

subject = "Dims Server Monitoring for #{Time.now.utc}"
send_email('dsemenyuk@gmail.com', :subject => subject, :body => body, :content_type => 'text/html')

