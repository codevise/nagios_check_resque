require 'nagios_check'
require 'nagios_check_resque/resque_adapter'

module NagiosCheckResque
  # Warn if there are failed jobs
  class FailedJobsCheck
    include NagiosCheck

    on '--redis-host HOST', default: 'redis://localhost:6379'

    enable_warning
    enable_critical
    enable_timeout

    def initialize(resque = ResqueAdapter.new)
      @resque = resque
    end

    def check
      @resque.setup(redis_host: options['redis-host'])

      failed_jobs_count = @resque.failed_count

      store_message("#{failed_jobs_count} failed jobs")
      store_value(:failed, failed_jobs_count)
    end
  end
end
