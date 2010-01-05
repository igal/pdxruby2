cache 'members-index-atom' do
  atom_feed do |feed|
    feed.title('Portland Ruby Brigade members')
    feed.updated(@members.blank? ? Time.at(0) : @members.first.updated_at)

    @members.each_with_index do |member, i|
      feed.entry(member, :url => member_path(member)) do |entry|
        entry.title(member.name)
        entry.updated(member.created_at.utc.xmlschema)

        xm = Builder::XmlMarkup.new
        xm.div {
         if member.website.present?
           xm.p {
             xm.b "Website: "
             xm.span << display_link_to(member.website, :nofollow => true)
           }
          end

          if member.feed_url.present?
           xm.p {
             xm.b "Feed: "
             xm.span << display_link_to(member.feed_url, :nofollow => true)
           }
          end

          if member.about.present?
           xm.p {
             xm.b "About:"
           }
           xm.div << display_textile_for(member.about)
          end
        }

        entry.content(xm.to_s, :type => 'html')
      end
    end
  end
end
