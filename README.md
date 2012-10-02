# What is it?

It is simple *NIX-server monitoring tool. It sends you emails with server status (uptime, load, free RAM etc.).

Also, it includes server status (based on important processes count) in email subject - it means that you can quickly look at email subject and you'll know "is my server okay?". For example:

    Server Monitoring - dims - OK - 2012-10-02 13:15:37 UTC
    Server Monitoring - dims - errors: mysql, unicorn - 2012-10-02 13:19:00 UTC

# Requirements

* Ruby 1.9
* sendmail