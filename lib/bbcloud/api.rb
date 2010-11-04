module Brightbox
  class Api
    attr_reader :id
    class ApiError < StandardError ; end
    class NotFound < ApiError ; end
    class Conflict < ApiError ; end
    class InvalidRecord < ApiError ; end
    class Forbidden < ApiError ; end

    @@api = nil

    def self.conn
      if @@api
        @@api
      else
        @@api = Fog::Brightbox::Compute.new CONFIG.to_fog
      end
    end

    def initialize(m = nil)
      if m.is_a? String
        @id = m
      elsif !m.nil?
        @fog_model = m
        @id = m.id
      end
    end

    def fog_model
      @fog_model ||= self.class.find(@id)
    end

    def exists?
      !fog_model.nil?
    rescue NotFound
      false
    end

    def to_s
      @id
    end

    def self.find(args = :all, options = {})
      return nil if args.nil?
      options = {
        :order => :created_at,
      }.merge options
      objects = []
      # get the data from the Api
      if args == :all or (args.respond_to?(:empty?) and args.empty?)
        objects = all
      elsif args.respond_to? :collect
        objects = args.collect do |arg|
          cached_get(arg)
        end
      end
      # wrap in our objects
      objects.collect! { |o| new(o) unless o.nil? }
      # Sort
      objects.sort! do |a,b| 
        sort_method = options[:order]
        begin
          a.send(sort_method) <=> b.send(sort_method)
        rescue NoMethodError
          0
        end
      end
      if objects.size <= 1 and args.is_a? String
        # This was a single lookup
        objects.first
      else
        objects
      end
    end

    def method_missing(m, *args)
      if fog_model
        fog_model.send(m, *args)
      else
        raise NoMethodError
      end
    end

    def self.cached_get(id)
      @cache = {} if @cache.nil?
      value = @cache[id]
      if value
        value
      else
        debug "writing cache entry #{id}"
        @cache[id] = get(id)
      end
    end

    def self.find_by_handle(h)
      find(:all).find { |o| o.handle == h }
    end

    def self.cache_all!
      @cache = {}
      all.each do |f|
        @cache[f.id] = f
      end
    end

  end
end
