module DisplayLinkToHelper
  def display_link_to(url, opts={})
    return display_link_to_wrapper(url, opts)
  end

  def display_mail_to(email, opts={})
    opts = opts.clone
    opts[:mailto] = true
    return display_link_to_wrapper(email, opts)
  end

  # Return a #link_to for a +url+ that's been sanitized by #h, had its text
  # truncated, and optionally has the 'rel="nofollow"' flag set.
  #
  # Options:
  # * :maxlength => Maximum length of the displayed URL. Defaults to 64.
  # * :nofollow => Include a 'rel="nofollow"' in link to discourage spammers. Defaults to true.
  # * :mailto => The URL is an email address and should be rendered as a mailto link. Defaults to false.
  # * :title => Title to give link, else URL.
  def display_link_to_wrapper(url, opts={})
    opts = opts.symbolize_keys.reverse_merge({
      :maxlength => 64,
      :nofollow => true,
      :mailto => false
    })

    link_to_opts = {}
    link_to_opts[:rel] = "nofollow" if opts[:nofollow]
    link_to_opts[:popup] = true if opts[:popup]
    truncated_url = truncate(url, :length => opts[:maxlength])

    if opts[:mailto]
      return mail_to(h(url), h(opts[:title] || truncated_url), :encode => "javascript")
    else
      return link_to(h(opts[:title] || truncated_url), h(url), link_to_opts)
    end
  end
end
