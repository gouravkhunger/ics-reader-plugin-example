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