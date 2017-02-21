require 'nagios_check'

require 'resque'
require 'resque/failure/redis'

module NagiosCheckResque
  # Warn if there are failed jobs
  class FailedJobsCheck
    include NagiosCheck

    on '--redis-host HOST', default: 'redis://localhost:6379'

    enable_warning
    enable_critical
    enable_timeout

    def check
      setup_resque
      store_value(:failed, Resque::Failure::Redis.count)
    end

    private

    def setup_resque
      Resque.redis = Redis.new(host: options.redis_host)
      Resque
    end
  end
end
