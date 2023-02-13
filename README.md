This project was built as part of [my answer](https://stackoverflow.com/a/75419548/9819031) to a question on StackOverflow. It illustrates how to read `ics` files using a custom Jekyll plugin written in Ruby, and expose the extracted data to a liquid variable.

It uses the [`icalendar`](https://github.com/icalendar/icalendar) gem to make the data parsing process easier.

### Usage

Add [`icalendar`](https://github.com/icalendar/icalendar) to your `Gemfile` and install it:

```shell
bundle add icalendar
bundle install
```

Create a file called `calendar_reader.rb` under the `_plugins` directory and add this code:

```ruby
require "jekyll"
require "icalendar"

module Jekyll
  module ICSReader
    def read_calendar(input)
      begin
        calendar_file = File.open(input)
        events = Icalendar::Event.parse(calendar_file)

        hash = {}
        counter = 0

        # loop through the events in the calendars
        # and map the values you want into a variable and then return it:

        events.each do |event|
          hash[counter] = {
            "summary" => event.summary,
            "dtstart" => event.dtstart,
            "dtend" => event.dtend,
            "description" => event.description
          }

          counter += 1
        end

        return hash
      rescue
        # Handle errors
        Jekyll.logger.error "Calendar Reader:", "An error occurred!"

        return {}
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::ICSReader)
```

Here we define a [Jekyll Filter](https://jekyllrb.com/docs/plugins/filters/) to accept a file name as an input. The filter then tries to read the calender file and extract relevant information, mapping it to a Ruby Hash and returning it. The [`README.md`](https://github.com/icalendar/icalendar#readme) docs of `icalendar` would help you understand how data is being read from the file.

Now take an ics file and put it into the `_data` folder.

`_data/my_calendar.ics`

```ics
BEGIN:VEVENT
DTSTAMP:20050118T211523Z
UID:bsuidfortestabc123
DTSTART;TZID=US-Mountain:20050120T170000
DTEND;TZID=US-Mountain:20050120T184500
CLASS:PRIVATE
GEO:37.386013;-122.0829322
ORGANIZER:mailto:joebob@random.net
PRIORITY:2
SUMMARY:This is a really long summary to test the method of unfolding lines
 \, so I'm just going to make it a whole bunch of lines.
ATTACH:http://bush.sucks.org/impeach/him.rhtml
ATTACH:http://corporations-dominate.existence.net/why.rhtml
RDATE;TZID=US-Mountain:20050121T170000,20050122T170000
X-TEST-COMPONENT;QTEST="Hello, World":Shouldn't double double quotes
END:VEVENT
BEGIN:VEVENT
DTSTAMP:20110118T211523Z
UID:uid-1234-uid-4321
DTSTART;TZID=US-Mountain:20110120T170000
DTEND;TZID=US-Mountain:20110120T184500
CLASS:PRIVATE
GEO:37.386013;-122.0829322
ORGANIZER:mailto:jmera@jmera.human
PRIORITY:2
SUMMARY:This is a very short summary.
RDATE;TZID=US-Mountain:20110121T170000,20110122T170000
END:VEVENT
```

This sample ics file is taken from the [icalendar repository](https://github.com/icalendar/icalendar/blob/main/spec/fixtures/two_events.ics).

You can use the plugin filter from your markdown/html:

```liquid
{% assign events = "_data/my_calendar.ics" | read_calendar %}
```

Here `read_calendar` is the function defined in `_plugins/calendar_reader.rb` and `_data/my_calendar.ics` is the file you want to get the data from. The plugin gets the `input` file name, reads it and returns a `hash` which is stored into the `events` variable itself.

You can now use `{{ events }}` to access the hash of the data that you return from the function in the plugin file.

```
// {{ events }}

{0=>{“summary”=>”This is a really long summary to test the method of unfolding lines, so I’m just going to make it a whole bunch of lines.”, “dtstart”=>#<DateTime: 2005-01-20T17:00:00+00:00 ((2453391j,61200s,0n),+0s,2299161j)>, “dtend”=>#<DateTime: 2005-01-20T18:45:00+00:00 ((2453391j,67500s,0n),+0s,2299161j)>, “description”=>nil}, 1=>{“summary”=>”This is a very short summary.”, “dtstart”=>#<DateTime: 2011-01-20T17:00:00+00:00 ((2455582j,61200s,0n),+0s,2299161j)>, “dtend”=>#<DateTime: 2011-01-20T18:45:00+00:00 ((2455582j,67500s,0n),+0s,2299161j)>, “description”=>nil}}


// events[0]:

{“summary”=>”This is a really long summary to test the method of unfolding lines, so I’m just going to make it a whole bunch of lines.”, “dtstart”=>#<DateTime: 2005-01-20T17:00:00+00:00 ((2453391j,61200s,0n),+0s,2299161j)>, “dtend”=>#<DateTime: 2005-01-20T18:45:00+00:00 ((2453391j,67500s,0n),+0s,2299161j)>, “description”=>nil} 

// events[1]:

{“summary”=>”This is a very short summary.”, “dtstart”=>#<DateTime: 2011-01-20T17:00:00+00:00 ((2455582j,61200s,0n),+0s,2299161j)>, “dtend”=>#<DateTime: 2011-01-20T18:45:00+00:00 ((2455582j,67500s,0n),+0s,2299161j)>, “description”=>nil}
```

## License

```
MIT License

Copyright (c) 2023 Gourav Khunger

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
