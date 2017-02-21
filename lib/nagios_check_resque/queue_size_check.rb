require 'nagios_check'
require 'resque'

module NagiosCheckResque
  # Prevent jobs from queuing up
  class QueueSizeCheck
    include NagiosCheck

    on '--queues QUEUES', :mandatory
    on '--redis-host HOST', default: 'redis://localhost:6379'

    enable_warning
    enable_critical
    enable_timeout

    def check
      setup_resque

      store_value(:max, queue_sizes.values.max)

      queue_sizes.each do |name, size|
        store_value(name, size)
      end
    end

    private

    def queue_sizes
      @queue_sizes ||= queues.each_with_object({}) do |name, sizes|
        sizes[name] = resque.size(name)
      end
    end

    def queues
      options.queues.split(',')
    end

    def setup_resque
      Resque.redis = Redis.new(host: options.redis_host)
    end
  end
end
