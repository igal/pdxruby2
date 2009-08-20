atom_feed do |feed|
  feed.title("Portland Ruby Brigade events")
  feed.updated((@events.blank? ? Time.at(0) : @events.first.updated_at))

  @events.each_with_index do |event, i|
    feed.entry(event, :url => event_path(event)) do |entry|
      entry.title event.name
      entry.updated event.updated_at.utc.xmlschema

      xm = ::Builder::XmlMarkup.new
      xm.div {
        xm.p {
          xm.b "Time: "
          xm.span << "#{event.starts_at.strftime('%a %b %d %Y at %I:%M%p')} &mdash; #{event.ends_at.strftime('%a %b %d %Y at %I:%M%p')}"
        }
        if event.location
          xm.p {
            xm.b "Location: "
            xm.span "#{h event.location.name}, #{h event.location.address}"
          }
        end
        xm.p { xm.b "Agenda: " }
        if event.agenda
          xm << textilize(event.agenda)
        end
      }

      entry.content(xm.to_s, :type => 'html')
    end
  end
end
