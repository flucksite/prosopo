# prosopo

A Prosopo Procaptcha verifier for Crystal apps.

> **Note** The original repository is hosted at [https://codeberg.org/fluck/prosopo](https://codeberg.org/fluck/prosopo).

## Installation

1. Add the dependency to your `shard.yml`:

  ```yaml
  dependencies:
    prosopo:
      codeberg: fluck/prosopo
  ```

2. Run `shards install`

## Usage

### Configuration

Require the shard in your app:

```crystal
require "prosopo"
```

Add your configuration:

```crystal
Prosopo.configure do |settings|
  # Required
  settings.site_key = ENV.fetch("PROSOPO_SITE_KEY")
  settings.secret_key = ENV.fetch("PROSOPO_SECRET_KEY")

  # Optional
  settings.endpoint = "https://api.prosopo.io/siteverify" 
  settings.timeout = 5.seconds
  settings.retry_attempts = 3
  settings.retry_delays = [0.5, 1, 2]
  settings.script = "https://js.prosopo.io/js/procaptcha.bundle.js"
end
```

### Front-end

Include the tags mixin:

```crystal
abstract class BasePage
  include Prosopo::Tags
end
```

Then add the Prosopo script in the head of your page:

```erb
<%= prosopo_script %>
```

Or for Lucky Framework:

```crystal
lucky_prosopo_script
```

This helper accepts the following options:

```erb
<%= prosopo_script(
  async: false,           # default is true
  defer: false            # default is true
) %>
```

**Note**: All additional named arguments will be rendered as attributes on the
HTML tag, with underscores converted to hyphens in the attribute names.

Next, add the Prosopo container element:

```erb
<%= prosopo_container %>
```

Or for Lucky Framework:

```crystal
lucky_prosopo_container
```

This helper accepts a class name:

```erb
<%= prosopo_container(class_name: "my-class-name") %>
```

All other named arguments will be rendered as attributes on the HTML tag, with
underscores converted to hyphens in the attribute names:

```erb
<%= prosopo_container(data_theme: "dark", data_callback: "myCallback") %>
```

Look at the [Prosopo
docs](https://docs.prosopo.io/en/basics/integration/)
for all the available configuration options.

### Back-end

Verify validity of the token:

```crystal
prosopo_token = params["procaptcha-response"]
ip_address = request.remote_address

Prosopo.verify?(prosopo_token, ip_address)
# => true
```

Or with more detail:

```crystal
result = Prosopo.verify(prosopo_token, ip_address)

if result.verified?
  puts "Verification successful!"
  puts "Status: #{result.status}"
else
  puts "Verification failed"
  
  result.errors.each do |error|
    puts "Error: #{error}"
  end
end
```

Handling exceptions:

```crystal
begin
  result = Prosopo.verify(prosopo_token)
  
  if result.verified?
    # Handle successful verification
  else
    # Handle captcha failure (invalid response, expired, etc.)
  end
rescue Prosopo::RequestError
  # Network connectivity issues, timeouts, connection failures
rescue Prosopo::ResponseError
  # Invalid JSON response, unexpected HTTP status codes
end
```

## Contributing

1. Fork it (<https://codeberg.org/fluck/prosopo/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'feat: add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Wout](https://wout.codes) - creator and maintainer
