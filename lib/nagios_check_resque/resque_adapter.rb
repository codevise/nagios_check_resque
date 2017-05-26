require 'resque'
require 'resque/failure/redis'

module NagiosCheckResque
  class ResqueAdapter
    def setup(options)
      Resque.redis = Redis.new(host: options[:redis_host])
    end

    def count(queue)
      Resque.count(queue)
    end

    def failed_count
      Resque::Failure::Redis.count
    end
  end
end
