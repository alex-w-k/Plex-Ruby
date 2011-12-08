module Plex
  class Section

    GROUPS = %w(all unwatched newest recentlyAdded recentlyViewed onDeck)

    attr_reader :library, :refreshing, :type, :title, :art, :agent, :scanner, 
      :language, :updated_at

    # @param [Library] library this Section belongs to
    # @param [Nokogiri::XML::Element] nokogiri element that represents this
    #   Section
    def initialize(library, node)
      @library = library
      @refreshing = node.attr('refreshing')
      @key        = node.attr('key')
      @type       = node.attr('type')
      @title      = node.attr('title')
      @art        = node.attr('art')
      @agent      = node.attr('agent')
      @scanner    = node.attr('scanner')
      @language   = node.attr('language')
      @updated_at = node.attr('updatedAt')
    end

    # NOT IMPLEMENTED
    def refresh(deep = false, force = false)
    end


    # Returns a list of shows or movies that are in this Section. 
    #
    # all - all videos in this Section
    # unwatched - videos unwatched in this Section
    # newest - most recent videos in this Section
    # recently_added - recently added videos in this Section
    # recently_viewed - recently viewed videos in this Section
    # on_deck - videos that are "on deck" in this Section
    #
    # @return [Array] list of Shows or Movies in that group
    GROUPS.each { |method|
      class_eval %(
        def #{Plex.snake_case(method)}
          Plex::Parser.new( self, Nokogiri::XML(open(url+key+'/#{method}')) ).parse
        end
      )
    }

    def key
      "/library/sections/#{@key}"
    end
    
    def url
      library.url
    end

  end
end
