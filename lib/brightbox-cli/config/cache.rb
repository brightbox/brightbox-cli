module Brightbox
  module Config
    module Cache
      def cache_path
        File.join(config_directory, "cache")
      end

      def cache_id(cid)
        return if cid.nil?

        unless File.exist?(cache_path)
          begin
            FileUtils.mkpath(cache_path)
          rescue Errno::EEXIST
          end
        end
        FileUtils.touch(File.join(cache_path, cid)) unless cid.nil?
      end
    end
  end
end
