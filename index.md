---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
---

This project was built as part of [my answer](https://stackoverflow.com/a/75419548/9819031) to a question on StackOverflow. It illustrates how to read `ics` files using a custom Jekyll plugin written in Ruby, and expose the extracted data to a liquid variable.

## Usage

Add [`icalendar`](https://github.com/icalendar/icalendar) to your `Gemfile` and install it:

```shell
bundle add icalendar
bundle install
```

Get the [`calendar_reader.rb`](https://github.com/gouravkhunger/ics-reader-plugin-example/blob/main/_plugins/calendar_reader.rb) file and place it under the `_plugins` directory.

Take an [example ics file](https://github.com/icalendar/icalendar/blob/main/spec/fixtures/two_events.ics) `my_calendar.ics` and put it into the `_data` folder.

Now you can use the plugin filter from your markdown/html:

```liquid
{% raw %}{% assign events = "_data/my_calendar.ics" | read_calendar %}{% endraw %}
```

Here `read_calendar` is the function defined in `_plugins/calendar_reader.rb` and `_data/my_calendar.ics` is the file you want to get the data from. The plugin gets the `input` file name, reads it and returns a `hash` which is stored into the `events` variable itself.

You can now use `{% raw %}{{ events }}{% endraw %}` to access the hash of the data that you return from the function in the plugin file.

```
// {% raw %}{{ events }} {% endraw %}
{% assign events = "_data/my_calendar.ics" | read_calendar %}{{ events }}

// {% raw %}{{ events[0] }}{% endraw %}:
{{ events[0] }}

// {% raw %}{{ events[1] }}{% endraw %}:
{{ events[1] }}
```

For more information, checkout the [project repository](https://github.com/gouravkhunger/ics-reader-plugin-example) at GitHub.
