class NewRelic

  attr_accessor :interval_minutes, :params, :app, :api, :data
  
	def initialize(app)
    self.interval_minutes = 10
    self.params = {
    "begin" => "2100-07-27T00:00:00Z",
    "end" => "2100-07-27T00:#{"%02i" % self.interval_minutes}:00Z",
    "field" => "busy_percent",
    "summary_mode" => 1,
    "metrics[]" => "Instance/Busy",
    }
    self.api = Oldrelic::API.new(app.new_relic_api_key)
	end

  def fetch
    self.data||=Yajl::Parser.new.parse(self.api.get_api('v1', 'applications', self.app.new_relic_app_id, 'data.json', self.params))
  end
  
  def autoscale
    
  end
  
end