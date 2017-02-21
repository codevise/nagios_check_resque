# Nagios Check Resque

[![Gem Version](https://badge.fury.io/rb/nagios_check_resque.svg)](http://badge.fury.io/rb/nagios_check_resque)

Nagios plugins to check Resque queue sized and number of failed jobs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nagios_check_resque', require: false
```

And then execute:

    $ bundle

## Usage

The provides two executables. To check queue sizes, run:

    $ bundle exec nagios_check_resque_queue_sizes --queues default,mailer -w 5 -c 8 -t 10

The result is OK if all given queues contain at most 5 jobs.  If one
of the queues contains more than 5 but not more than 8 jobs, the
result is WARNING.  If one of the queues contains more than 8 jobs,
the result is CRITICAL.  If the command takes more than 10 seconds to
finish, the result is UNKNOWN.

The number of jobs in each queue is printed as key value pairs in the
performance data.

To check the number of failed jobs, run:

    $ bundle exec nagios_check_resque_failed_jobs -w 5 -c 8 -t 10

The result is OK if there are at most 5 failed jobs.  If there are
more than 5 failed jobs but not more than 8, the result is WARNING.
If there are more than 8 failed jobs, the result is CRITICAL.  If the
command takes more than 10 seconds to finish, the result is UNKNOWN.

## Example Nagios Configuration

You can define a custom Nagios command to invoke the executables via
SSH. Line breaks have been inserted to improve readability, but have
to be removed in the actual Nagios config.

```
define command {
        command_name    check_by_ssh_resque_queue_sizes
        command_line    $USER1$/check_by_ssh -l nagios -H $HOSTADDRESS$
                          -C "BUNDLE_GEMFILE=/path/to/Gemfile
                              /usr/local/bin/bundle exec nagios_check_resque_queue_sizes
                              --queues $ARG2$
                              -w $ARG1$ -c $ARG2$ -t 10"
}

define command {
        command_name    check_by_ssh_resque_failed_jobs
        command_line    $USER1$/check_by_ssh -l nagios -H $HOSTADDRESS$
                          -C "BUNDLE_GEMFILE=/path/to/Gemfile
                              /usr/local/bin/bundle exec nagios_check_resque_failed_jobs
                              -w $ARG1$ -c $ARG2$ -t 10"
}
```

They can then be used in host definitions:

```
define service {
  use                           generic-service
  host_name                     some-host
  service_description           RESQUE_QUEUE_SIZES
  check_command                 check_by_ssh_resque_queue_sizes!default!10!20
}

define service {
  use                           generic-service
  host_name                     some-host
  service_description           RESQUE_FAILED_JOBS
  check_command                 check_by_ssh_resque_failed_jobs!0!10
}
```

## Development

After checking out the repo, run `bin/setup` to install
dependencies. You can also run `bin/console` for an interactive prompt
that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake
install`. To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will
create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/codevise/nagios_check_resque. This project is
intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of
conduct.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
