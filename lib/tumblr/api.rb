require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'net/http'
require 'uri'

module Tumblr
  
  # == Tumblr API
  #
  # The Api class implements the Tumblr API directly. It is not really intended to be used directly.
  class Api
    
    ROOT = 'http://%s.tumblr.com/api'
  
    class << self
      
      # * start  - The post offset to start from. The default is 0.
      # * num    - The number of posts to return. The default is 20, and the maximum is 50.
      # * type   - The type of posts to return. If unspecified or empty, all types of posts are returned. 
      #            Must be one of regular, quote, photo, link, conversation, video, or audio.
      # * id     - A specific post ID to return. Use instead of start, num, or type.
      # * filter - Alternate filter to run on the text content. Allowed values:
      #       o text - Plain text only. No HTML.
      #       o none - No post-processing. Output exactly what the author entered. 
      #                (Note: Some authors write in Markdown, which will not be converted to HTML when this option is used.)
      def read(opts = {})
        options = {:filter => opts[:filter]}
        if opts[:id]
          options.merge!(:id => opts[:id]) 
        else
          options.merge!( :start => opts[:start], :num => opts[:num], :type => opts[:type])
        end
        #tidy up, it makes testing easier.
        options.delete_if{ |k,v| v.nil? }
        
        doc, posts = Hpricot::XML(get('read', options)), []
        
        (doc/:post).each do |p|
          type = p[:type]
          tags = []
          
          attribs = p.attributes.inject({}) do |result, arr|
            result[:"#{arr.first.sub('-','_')}"] = arr.last
            result
          end
            
          attribs = p.containers.inject(attribs) do |result, element| 
            if element.name == 'tag'
              tags << element.innerHTML
            elsif element.name == 'conversation'
              result[:conversation] = element.containers.inject([]) do |res,line|
                res << line.attributes.merge(:line => line.innerHTML)
              end
            else
              result[element.name.sub(/^#{type}-/,'').to_sym] = element.innerHTML
            end
            result[:tags] = tags
            result
          end
          
          posts << case type
            when 'regular'      : RegularPost.new(attribs)
            when 'photo'        : PhotoPost.new(attribs)
            when 'quote'        : QuotePost.new(attribs)
            when 'link'         : LinkPost.new(attribs)
            when 'conversation' : ConversationPost.new(attribs)
            when 'video'        : VideoPost.new(attribs)
            when 'audio'        : AudioPost.new(attribs)
          end
        end
        
        posts
      end
      
      def write(opts = {})
        options = {:email => Tumblr::defaults[:email], :password => Tumblr::defaults[:password], :generator => Tumblr::defaults[:generator]}
        options.merge!(opts)
        result = post('write', options)
      end
      
      private

      def escape(string)
        URI::encode(string, /[^a-z0-9]/i)
      end
      
      def get(*args)
        open(make_get_url(*args)) {|u| u.read }
      end
      
      def post(*args)
        url = make_post_url(args.shift)
        post_params = {}
        args.shift.each { |k, v| post_params[k.to_s]=v.to_s }
        Net::HTTP.post_form(URI.parse(url),post_params)
      end

      def base_url(method)
        url = (ROOT % Tumblr::defaults[:account]) + '/' + method + '/'
      end

      def make_get_url(*args)
        url = base_url(args.shift) + '?'
        args.shift.each { |k, v| url += "#{k}=#{escape(v.to_s)}&" }
        return url.chomp('&')
      end

      def make_post_url(method)
        url = base_url(method)
      end

    end
  
  end

end