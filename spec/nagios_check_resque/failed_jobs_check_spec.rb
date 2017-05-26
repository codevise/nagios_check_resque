require 'nagios_check_resque/failed_jobs_check'

module NagiosCheckResque
  RSpec.describe FailedJobsCheck do
    before(:each) do
      ENV.delete('REDIS_URL')
    end

    it 'is ok when number of failed jobs is below w' do
      resque = instance_spy(ResqueAdapter, failed_count: 20)
      check = FailedJobsCheck.new(resque)

      result = check.perform(%w(-w 30 -c 40))

      expect(result).to be_ok
    end

    it 'is warning when number of failed jobs is between w and c' do
      resque = instance_spy(ResqueAdapter, failed_count: 35)
      check = FailedJobsCheck.new(resque)

      result = check.perform(%w(-w 30 -c 40))

      expect(result).to be_warning
    end

    it 'is critical when number of failed jobs is above c' do
      resque = instance_spy(ResqueAdapter, failed_count: 41)
      check = FailedJobsCheck.new(resque)

      result = check.perform(%w(-w 30 -c 40))

      expect(result).to be_critical
    end

    it 'sets up resque with redis host' do
      resque = instance_spy(ResqueAdapter, failed_count: 20)
      check = FailedJobsCheck.new(resque)

      check.perform(%w(-w 30 -c 40))

      expect(resque).to have_received(:setup).with(redis_url: 'redis://localhost:6379')
    end

    it 'allows passing custom redis host' do
      resque = instance_spy(ResqueAdapter, failed_count: 20)
      check = FailedJobsCheck.new(resque)

      check.perform(%w(-w 30 -c 40 --redis-url redis://other:6379))

      expect(resque).to have_received(:setup).with(redis_url: 'redis://other:6379')
    end
  end
end
