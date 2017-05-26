require 'nagios_check'
require 'nagios_check_resque/resque_adapter'

module NagiosCheckResque
  # Prevent jobs from queuing up
  class QueueSizeCheck
    include NagiosCheck

    on '--queues QUEUES', :mandatory
    on '--redis-host HOST', default: 'redis://localhost:6379'

    enable_warning
    enable_critical
    enable_timeout

    def initialize(resque = ResqueAdapter.new)
      @resque = resque
    end

    def check
      @resque.setup(redis_host: options['redis-host'])

      store_message(queue_sizes_message)
      store_value(:max, queue_sizes.values.max)

      queue_sizes.each do |name, size|
        store_value(name, size)
      end
    end

    private

    def queue_sizes_message
      queue_sizes.sort_by { |_, size| size }.reverse.map { |name, size|
        "#{size} in #{name}"
      }.compact.join(', ')
    end

    def queue_sizes
      @queue_sizes ||= queues.each_with_object({}) do |name, sizes|
        sizes[name] = @resque.size(name)
      end
    end

    def queues
      options.queues.split(',')
    end
  end
end
