class Autoscale

  attr_accessor :interval_minutes, :params, :app, :api, :data, :min_ratio, :max_ratio, :avg_ratio, :min_dynos, :pessimism
  
	def initialize(app)
    self.app = app
    self.interval_minutes = 10
    self.min_ratio, self.max_ratio = 0.72, 0.85
    self.avg_ratio = (max_ratio + min_ratio) / 2.0
    self.min_dynos = 0 # it will never go below this value
    self.pessimism = 0.8 # 1 is max, 0 is min
    
    self.params = {
      "begin" => "2100-07-27T00:00:00Z",
      "end" => "2100-07-27T00:#{"%02i" % self.interval_minutes}:00Z",
      "field" => "busy_percent",
      "summary_mode" => 1,
      "metrics[]" => "Instance/Busy",
    }
    self.api = Oldrelic::API.new(self.app.new_relic_api_key)
	end

  def fetch
    self.data||=Yajl::Parser.new.parse(self.api.get_api('v1', 'applications', self.app.new_relic_app_id, 'data.json', self.params))
  end
  
  # Borrowed heavily from https://github.com/viki-org/heroku-autoscale/blob/master/autoscale
  def autoscale
    begin
      parsed = fetch
      load_ratio = (parsed[0]['busy_percent'] + (20.0 * pessimism))/100

      current_dynos = app.dynos
    	current_workers = app.workers
      dynos_load_ratio = (load_ratio/(current_dynos.to_f/(current_dynos+current_workers))) * pessimism

    	puts "Current dynos: #{current_dynos}".yellow
    	puts "Current workers: #{current_workers}".yellow

    	puts ("Instance Usage (dynos+workers): %.2f%%" % (load_ratio*100.0)).yellow
    	puts ("Current dyno load: %.2f%%" % (dynos_load_ratio * 100)).yellow

    	used_dynos = current_dynos*dynos_load_ratio

      should_dynos = (used_dynos/avg_ratio).ceil
      should_dynos = min_dynos if should_dynos < min_dynos
      should_dynos = 100 if should_dynos > 100

      puts ("Amount of dynos to reach the %.2f%% of target load: #{should_dynos}" % (avg_ratio * 100)).yellow
      time_set = Time.now
    	if dynos_load_ratio > max_ratio || dynos_load_ratio < min_ratio
    	  if should_dynos != current_dynos
          #heroku_output = try_run!("#{heroku_command} dynos #{should_dynos} --app #{app_name}")
          # TODO set dynos
          puts "#{app.name} dynos adjusted to #{should_dynos}"
          # TODO send email
        else
          puts "#{app.name} already has this amount of dynos set. Skipping."
        end
    	else
    	  puts "#{app.name} current load is between our acceptance range(%.2f%%-%.2f%%), no change needed." % [min_ratio*100, max_ratio*100]
      end
    	puts ''

    rescue Exception => e
      message = "\nSomething has failed scaling #{app.name}!\nNew Relic response: #{parsed.inspect}.\nException: #{e.class} #{e.message} \nerror:\n#{e.backtrace.join("\n")}\n"
      puts message
      # TODO send email
    end
  end
  
end