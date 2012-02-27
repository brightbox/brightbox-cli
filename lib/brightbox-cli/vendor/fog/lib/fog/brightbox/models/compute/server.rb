require 'fog/compute/models/server'

module Fog
  module Compute
    class Brightbox

      class Server < Fog::Compute::Server

        identity  :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :state,       :aliases => 'status'

        attribute :hostname
        attribute :user_data
        attribute :console_url
        attribute :fqdn
        attribute :console_token

        # Times
        attribute :created_at, :type => :time
        attribute :started_at, :type => :time
        attribute :console_token_expires, :type => :time
        attribute :deleted_at, :type => :time

        # Links - to be replaced
        attribute :account_id,  :aliases => "account",      :squash => "id"
        attribute :image_id,    :aliases => "image",        :squash => "id"

        attribute :snapshots
        attribute :cloud_ips
        attribute :interfaces
        attribute :server_groups
        attribute :zone
        attribute :server_type

        def initialize(attributes={})
          self.image_id   ||= 'img-4gqhs' # Ubuntu Lucid 10.04 server (i686)
          super
        end

        def zone_id
          if t_zone_id = attributes[:zone_id]
            t_zone_id
          elsif zone
            zone[:id] || zone['id']
          end
        end

        def flavor_id
          if t_flavour_id = attributes[:flavor_id]
            t_flavour_id
          elsif server_type
            server_type[:id] || server_type['id']
          end
        end

        def zone_id=(incoming_zone_id)
          attributes[:zone_id] = incoming_zone_id
        end

        def flavor_id=(incoming_flavour_id)
          attributes[:flavor_id] = incoming_flavour_id
        end

        def snapshot
          requires :identity
          connection.snapshot_server(identity)
        end

        def reboot
          false
        end

        def start
          requires :identity
          connection.start_server(identity)
          true
        end

        def stop
          requires :identity
          connection.stop_server(identity)
          true
        end

        def shutdown
          requires :identity
          connection.shutdown_server(identity)
          true
        end

        def destroy
          requires :identity
          connection.destroy_server(identity)
          true
        end

        def flavor
          requires :flavor_id
          connection.flavors.get(flavor_id)
        end

        def image
          requires :image_id
          connection.images.get(image_id)
        end

        def private_ip_address
          unless interfaces.empty?
            interfaces.first["ipv4_address"]
          else
            nil
          end
        end

        def public_ip_address
          unless cloud_ips.empty?
            cloud_ips.first["public_ip"]
          else
            nil
          end
        end

        def ready?
          self.state == 'active'
        end

        def activate_console
          requires :identity
          response = connection.activate_console_server(identity)
          [response["console_url"], response["console_token"], response["console_token_expires"]]
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :image_id
          options = {
            :image => image_id,
            :name => name,
            :zone => zone_id,
            :user_data => user_data,
            :server_groups => server_groups
          }.delete_if {|k,v| v.nil? || v == "" }
          unless flavor_id.nil? || flavor_id == ""
            options.merge!(:server_type => flavor_id)
          end
          data = connection.create_server(options)
          merge_attributes(data)
          true
        end
      end
    end
  end
end
