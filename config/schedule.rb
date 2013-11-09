# http://en.wikipedia.org/wiki/Cron
# Learn more: http://github.com/javan/whenever
#:output to get the files into the log directory is 'log/name_of_log.log'

env = :development # :production

every :reboot do
  rake "thinking_sphinx:start", :output => {:error => 'log/thinking_sphinx_start_error.err', :standard => 'log/cron.log'}, :environment => env
end

every 2.minute do
  rake "thinking_sphinx:index:delta", :output => {:error => 'log/thinking_sphinx_index_delta.err', :standard => 'log/cron.log'}, :environment => env
end

every 5.minutes do
  rake "thinking_sphinx:index", :output => {:error => 'log/thinking_sphinx_index.err', :standard => 'log/cron.log'}, :environment => env
end

every :sunday, :at => "4:30am" do
  rake "thinking_sphinx:reindex", :output => {:error => 'log/thinking_sphinx_reindex.err', :standard => 'log/cron.log'}, :environment => env
end

# every 4.days do
#   runner "AnotherModel.prune_old_records"
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end


