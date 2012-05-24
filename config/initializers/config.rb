module EvaluatorService::Config
  mattr_accessor :remote_evaluator

  def self.setup
    defaults = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]

    if block_given?
      yield(self, defaults)
    end
  end
end

EvaluatorService::Config.setup do |config, defaults|
  config.remote_evaluator = defaults["remote_evaluator"]
end
