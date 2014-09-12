# WatchThinkChat
[![CodeClimate](http://img.shields.io/codeclimate/github/CruGlobal/watchthinkchat.svg?style=flat)](https://codeclimate.com/github/CruGlobal/watchthinkchat) [![Coverage](http://img.shields.io/codeclimate/coverage/github/CruGlobal/watchthinkchat.svg?style=flat)](https://codeclimate.com/github/CruGlobal/watchthinkchat) [![Travis-CI](http://img.shields.io/travis/CruGlobal/watchthinkchat.svg?style=flat)](https://travis-ci.org/CruGlobal/watchthinkchat) [![Travis-CI](http://img.shields.io/gemnasium/CruGlobal/watchthinkchat.svg?style=flat)](https://gemnasium.com/CruGlobal/watchthinkchat)

WatchThinkChat is an online tool that makes it easier than ever for you organize digital outreaches.

We're an open source project and always looking for more developers to help us expand WatchThinkChat's features.  Contact support@watchthinkchat.com to get involved.

http://watchthinkchat.com

## Getting Started

### Requirements

* Postgres SQL
* Memcached

### Setup

Copy the example configuration files to active configuration files:

```bash
$ cp .env.example .env
$ cd config
$ cp database.yml.example database.yml
```

### Install Gems

```bash
$ bundle install
```

### Create databases

```bash
$ bundle exec rake db:create:all
```

### Run migrations

```bash
$ bundle exec rake db:migrate
```

### Start Development Environment

```bash
$ bundle exec guard
```

## Running Tests

Tests should run automatically in your guard environment.

## License

WatchThinkChat is released under the MIT license:  http://www.opensource.org/licenses/MIT