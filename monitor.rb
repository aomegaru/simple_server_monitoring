require './mailer'
require 'erb'

@free_storage_space = `df -h /`
#@free_ram = `free`
@uptime = `uptime`
@running_processes = `ps -ef`
@hostname = `hostname`

@processes_to_monitor = {
  nginx: { title: 'nginx' },
  mysql: { title: 'MySQL' },
  ruby: { title: 'Ruby' },
  memcached: { title: 'memcached' }
}
@process_statuses = {}

@running_processes.split("\n").each do |line|
  @processes_to_monitor.each_key do |key|
    @process_statuses[key] = []  if @process_statuses[key].nil?
    @process_statuses[key].push line  unless line[key.to_s].nil?
  end
end

template = ERB.new File.read('./views/mail.html.erb')
body = template.result binding

subject = "Server Monitoring - #{@hostname} #{Time.now.utc}"
to = File.read('send_to')

puts subject
puts body

send_email to, subject: subject, body: body, content_type: 'text/html'
