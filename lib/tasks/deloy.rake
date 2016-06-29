require 'rubygems'
require 'net/ssh'

namespace :deploy do
  desc 'Deploy to website of LINKNHANH.INFO'
  task all: :environment do
    @hostname = "188.166.178.240"
    @username = "root"
    @cmd = "cd /www/getlinks && ./deploy.sh"

    begin
      ssh = Net::SSH.start(@hostname, @username)
      puts 'Connect successfully!'
      puts 'Updating code on server... Please wait...'
      res = ssh.exec!(@cmd)
      ssh.close
      puts res
      puts 'Finish!'
    rescue
      puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
    end
  end
end
