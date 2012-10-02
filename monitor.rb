require './mailer'
require 'erb'
require 'yaml'

@free_storage_space = `df -h /`
@free_ram = `free 2> /dev/null` # for cases where there's no 'free'
@uptime = `uptime`
@running_processes = `ps -ef`
@hostname = `hostname`

@processes_to_monitor = {
  nginx: { title: 'nginx' },
  mysql: { title: 'MySQL' },
  ruby: { title: 'Ruby' },
  unicorn: { title: 'Ruby Unicorn' },
  memcached: { title: 'memcached' }
}
@process_statuses = {}

@running_processes = @running_processes.split("\n")
@running_processes.each do |line|
  @processes_to_monitor.each_key do |key|
    @process_statuses[key] = []  if @process_statuses[key].nil?
    @process_statuses[key].push line  unless line[key.to_s].nil?
  end
end

template = ERB.new File.read('./views/mail.html.erb')
body = template.result binding

required_processes = YAML.load_file('./processes.yml')
failed_process_constraints = []
required_processes.each do |process|
  name_of_process = process.keys[0]
  count_should_be = process.values[0]
  current_process = @running_processes.select {|v| v =~ /#{name_of_process}/}
  if current_process.count != count_should_be
    failed_process_constraints.push(process: name_of_process, it_should_be: count_should_be, it_is: current_process.count)
  end
end

if failed_process_constraints.any?
  prc = []
  failed_process_constraints.map { |v| prc.push v[:process] }
  status = 'errors: ' + prc.join(', ')
else
  status = 'OK'
end
puts status.to_s

subject = "Server Monitoring - #{@hostname} - #{status} - #{Time.now.utc}"
to = File.read('./send_to').gsub("\n", ' ')

puts subject
puts body

send_email to, subject: subject, body: body, content_type: 'text/html'
