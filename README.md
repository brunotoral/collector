# Collector

<p align="center">
  <a href="https://www.ruby-lang.org/en/">
    <img src="https://img.shields.io/badge/Ruby-v3.3.2-brightgreen.svg" alt="ruby version">
  </a>
  <a href="http://rubyonrails.org/">
    <img src="https://img.shields.io/badge/Rails-v7.2.1.2-brightgreen.svg" alt="rails version">
  </a>
</p>

*Collector* is a payments platform. (*This application was created for a technical test.*)


## Getting Started

### Codebase

*Collector* is built on Ruby on Rails, Pico.css and JavaScript.

### Prerequisites

- [Git](https://git-scm.com)

### Installation

1. Make sure all the prerequisites are installed.
1. Clone the repository `git clone git@github.com:brunotoral/collector.git`
1. Build the development environment `bin/setup`.
1. Start Solid Queue `bin/jobs`
1. Start development server `rails server`

You're all set! Hapy hacking! :tada:

### User and seed

We have a user with email: `admin@collector.com` and password `1q2w3e4r`
You can manually run the seed using the following command:
```bash
$ rails db:seed
```
It will create the user and some customers with their invoices.

### Running The App

You can run Rails server using the following command:

```sh
$ rails server
```

It will make the application available at `localhost:3000`.

### Collecting the Payments

Once a day at 10:00 AM, the task `payment:collect` is scheduled to run.
You can also manually trigger it by calling:
```sh
$ rake payment:collect
```

### Adding a new Payment Methods

To Add a new payment method you just need to:

Create a Processor in `app/models/payments/processors/my_processor.rb` and include `Payments::Processor` Module.
```ruby
module Payments
  module Processors
    include Payments::Processor
    # ...
  end
end
```

Add your processor to the `config/initializers/payments.rb`
```ruby
Payments.configure do |config|
  config.processors["my_processor"] = Payments::Processors::MyProcessor
end
```
