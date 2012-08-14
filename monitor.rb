require './mailer'
require 'erb'

@free_storage_space = `df -h /`
@free_ram = `free`
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
  @processes_to_monitor.each_with_index do |process, key|
    @process_statuses[key] = line  if line[key.to_s]
  end
end

template = ERB.new File.read('./views/mail.html.erb')
body = template.result binding

subject = "Server Monitoring - #{@hostname} #{Time.now.utc}"

puts subject
puts body

send_email 'monitoring@dims.kz', subject: subject, body: body, content_type: 'text/html'
