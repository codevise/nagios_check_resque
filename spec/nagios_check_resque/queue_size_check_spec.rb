require 'nagios_check_resque/queue_size_check'

module NagiosCheckResque
  RSpec.describe QueueSizeCheck do
    it 'is ok when all queues have less than w jobs' do
      resque = resque_adapter_double(default: 5, mailers: 0)
      check = QueueSizeCheck.new(resque)

      result = check.perform(%w(-w 10 -c 20 --queues default,mailers))

      expect(result).to be_ok
    end

    it 'is warning when at least one queue has more than w jobs' do
      resque = resque_adapter_double(default: 5, mailers: 11)
      check = QueueSizeCheck.new(resque)

      result = check.perform(%w(-w 10 -c 20 --queues default,mailers))

      expect(result).to be_warning
    end

    it 'is critical when at least one queue has more than c jobs' do
      resque = resque_adapter_double(default: 11, mailers: 22)
      check = QueueSizeCheck.new(resque)

      result = check.perform(%w(-w 10 -c 20 --queues default,mailers))

      expect(result).to be_critical
    end

    it 'stores helpful message with queues ordered by size' do
      resque = resque_adapter_double(default: 4, mailers: 0, other: 6)
      check = QueueSizeCheck.new(resque)

      result = check.perform(%w(-w 10 -c 20 --queues default,mailers,other))

      expect(result.output).to include('6 in other, 4 in default, 0 in mailers')
    end

    it 'sets up resque with redis host' do
      resque = resque_adapter_double(default: 4)
      check = QueueSizeCheck.new(resque)

      check.perform(%w(-w 10 -c 20 --queues default))

      expect(resque).to have_received(:setup).with(redis_host: 'redis://localhost:6379')
    end

    it 'allows passing custom redis host' do
      resque = resque_adapter_double(default: 4)
      check = QueueSizeCheck.new(resque)

      check.perform(%w(-w 10 -c 20 --queues default --redis-host redis://other:6379))

      expect(resque).to have_received(:setup).with(redis_host: 'redis://other:6379')
    end

    def resque_adapter_double(queue_sizes)
      resque = instance_spy('ResqueAdapter')

      queue_sizes.each do |name, size|
        allow(resque).to receive(:size).with(name.to_s).and_return(size)
      end

      resque
    end
  end
end
