# Carrierwave::Base64

[![Gem Version](https://badge.fury.io/rb/carrierwave-base64.svg)](http://badge.fury.io/rb/carrierwave-base64)
[![Build Status](https://travis-ci.org/lebedev-yury/carrierwave-base64.svg?branch=master)](https://travis-ci.org/lebedev-yury/carrierwave-base64)

Upload files encoded as base64 to carrierwave.

This small gem can be useful for API's that interact with mobile devices.

## Installation

Add the gem to your Gemfile:

```ruby
gem 'carrierwave-base64'
```

Also add this if you need mongoid support:

```ruby
gem "carrierwave-mongoid"
```

## Usage

Mount the uploader to your model:

```ruby
mount_base64_uploader :image, ImageUploader
```

Now you can also upload files by passing an encoded base64 string to the attribute.

## Data format

The string with the encoded data, should be prefixed with Data URI scheme format:

```
data:image/jpg;base64,(base64 encoded data)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/carrierwave-base64/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
