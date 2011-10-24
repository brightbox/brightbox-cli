module Brightbox
  class Api
    attr_reader :id
    class ApiError < StandardError ; end
    class NotFound < ApiError ; end
    class Conflict < ApiError ; end
    class InvalidRecord < ApiError ; end
    class Forbidden < ApiError ; end
    class InvalidArguments < ApiError ; end

    @@api = nil

    def self.conn
      if @@api
        @@api
      else
        @@api = Fog::Compute.new CONFIG.to_fog
        @@api.oauth_token = CONFIG.oauth_token
        @@api
      end
    end

    def self.klass_name
      name.split("::").last()
    end

    def initialize(m = nil)
      if m.is_a? String
        @id = m
      elsif m.respond_to? :attributes and m.respond_to? :id
        @fog_model = m
        @id = m.id
      else
        raise InvalidArguments, "Can't initialize #{self.class} with #{m.inspect}"
      end
      CONFIG.cache_id @id
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
      raise InvalidArguments, "find(nil)" if args.nil?
      raise InvalidArguments, "find([])" if args.respond_to?(:empty?) and args.empty?
      options = {
        :order => :created_at,
      }.merge options

      objects = nil
      object = nil
      # get the data from the Api
      if args == :all
        objects = all
      elsif args.is_a? String
        object = cached_get(args.to_s)
        raise NotFound, "Couldn't find '#{args.to_s}'" if object.nil?
      elsif args.respond_to? :collect
        objects = args.collect do |arg|
          o = cached_get(arg.to_s)
          raise NotFound, "Couldn't find '#{arg.to_s}'" if o.nil?
          o
        end
      else
        raise InvalidArguments, "Couldn't find '#{args.class}'"
      end
      if objects
        # wrap in our objects
        objects.collect! { |o| new(o) }
        # Sort
        objects.sort! do |a,b| 
          sort_method = options[:order]
          begin
            a.send(sort_method) <=> b.send(sort_method)
          rescue NoMethodError
            0
          end
        end
        objects
      elsif object
        new(object)
      end
    end

    # Find each id in the given array.  Yield the block with any ids
    # that couldn't be found
    def self.find_or_call(ids, &block)
      objects = []
      ids.each do |id|
        begin
          objects << find(id)
        rescue Api::NotFound
          yield id
        end
      end
      objects
    end

    def method_missing(m, *args)
      if fog_model
        fog_model.send(m, *args)
      else
        raise NoMethodError
      end
    end

    def self.cached_get(id)
      @cache ||= {}
      value = @cache[id]
      if value
        value
      else
        CONFIG.cache_id id
        @cache[id] = get(id)
      end
    end

    def self.find_by_handle(h)
      object = find(:all).find { |o| o.handle == h }
      raise Api::NotFound, "Invalid #{klass_name} #{h}" if object.nil?
      object
    end

    def self.cache_all!
      @cache = {}
      all.each do |f|
        @cache[f.id] = f
        CONFIG.cache_id f.id
      end
    end

  end
end
