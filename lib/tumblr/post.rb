module Tumblr

  class Post
    attr_reader :id, :url, :type, :date_gmt, :date, :unix_timestamp, :tags
    def initialize(attribs)
      attribs.each{ |k,v| instance_variable_set(:"@#{k.to_s}",v) }
    end
  end
  
  # regular - Requires at least one:
  # * title
  # * body (HTML allowed)
  class RegularPost < Post
    attr_reader :title, :body
  end
  
  # photo - Requires either source or data, but not both. If both are specified, source is used.
  # * source - The URL of the photo to copy. This must be a web-accessible URL, not a local file or intranet location.
  # * data - An image file. See File uploads below.
  # * caption (optional, HTML allowed)
  # * click-through-url (optional)
  class PhotoPost < Post
    attr_reader :source, :data, :caption, :click_through_url
  end
  
  # quote
  # * quote
  # * source (optional, HTML allowed)
  class QuotePost < Post
    attr_reader :quote, :source
  end

  # link 
  # * name (optional)
  # * url
  # * description (optional, HTML allowed)
  class LinkPost < Post
    attr_reader :name, :url, :description
  end
  
  # conversation
  # * title (optional)
  # * conversation
  class ConversationPost < Post
    attr_reader :title, :conversation
  end
  
  # video - Requires either embed or data, but not both.
  # * embed - Either the complete HTML code to embed the video, or the URL of a YouTube video page.
  # * data - A video file for a Vimeo upload. See File uploads below.
  # * title (optional) - Only applies to Vimeo uploads.
  # * caption (optional, HTML allowed)
  class VideoPost < Post
    attr_reader :embed, :data, :title, :caption
  end
  
  # audio
  # * data - An audio file. Must be MP3 or AIFF format. See File uploads below.
  # * caption (optional, HTML allowed)
  class AudioPost < Post
    attr_reader :data, :caption
  end

end
