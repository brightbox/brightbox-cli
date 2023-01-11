module VolumeHelpers
  def volumes_response
    JSON.dump(
      [
        {
          id: "vol-12345",
          name: "Second volume",
          description: nil,
          boot: false,
          delete_with_server: false,
          encrypted: false,
          filesystem_label: nil,
          filesystem_type: "ext4",
          locked: false,
          serial: "vol-12345",
          size: 10_240,
          source: nil,
          source_type: "raw",
          status: "attached",
          storage_type: "network",
          created_at: "2022-11-09T13:02:10Z",
          updated_at: "2023-01-05T10:38:42Z",
          deleted_at: nil,
          account: {
            id: "acc-12345",
            name: "Test account",
            status: "active"
          },
          image: {
            id: "img-45mb8",
            name: "Blank Disk Image",
            username: nil,
            status: "available",
            locked: false,
            description: "",
            source: "blank-image",
            source_trigger: "manual",
            arch: "x86_64",
            created_at: "2013-05-02T16:40:17.000Z",
            official: true,
            public: true,
            owner: "acc-12345"
          },
          server: {
            id: "srv-12345",
            name: "Multi volume test",
            status: "active",
            locked: false,
            hostname: "srv-12345",
            fqdn: "srv-12345.brightbox.localhost",
            created_at: "2022-11-09T13:04:07.000Z",
            started_at: "2022-11-09T13:04:50.000Z",
            deleted_at: nil
          },
          zone: {
            id: "zon-12345",
            handle: "gb1-a"
          }
        },
        {
          id: "vol-abcde",
          name: nil,
          description: nil,
          boot: true,
          delete_with_server: true,
          encrypted: false,
          filesystem_label: nil,
          filesystem_type: nil,
          locked: false,
          serial: "vol-abcde",
          size: 10_240,
          source: "img-f68lm",
          source_type: "image",
          status: "attached",
          storage_type: "network",
          created_at: "2022-11-09T13:04:07Z",
          updated_at: "2023-01-05T10:38:42Z",
          deleted_at: nil,
          account: {
            id: "acc-12345",
            name: "Test account",
            status: "active"
          },
          image: {
            id: "img-f68lm",
            name: "ubuntu-jammy-22.04-amd64-server",
            username: "ubuntu",
            status: "deprecated",
            locked: false,
            description: "ID: com.ubuntu.cloud:released:download/com.ubuntu.cloud:server:22.04:amd64/20221101.1/disk1.img, Release: release",
            source: "tmp41_g645e",
            source_trigger: "manual",
            arch: "x86_64",
            created_at: "2022-11-03T07:01:15.000Z",
            official: true,
            public: true,
            owner: "acc-kg71m"
          },
          server: {
            id: "srv-12345",
            name: "Multi volume test",
            status: "active",
            locked: false,
            hostname: "srv-12345",
            fqdn: "srv-12345.brightbox.localhost",
            created_at: "2022-11-09T13:04:07.000Z",
            started_at: "2022-11-09T13:04:50.000Z",
            deleted_at: nil
          },
          zone: {
            id: "zon-12345",
            handle: "gb1-a"
          }
        }
      ]
    )
  end

  def volume_response(options)
    default = {
      id: "vol-12345",
      name: SecureRandom.base64,
      description: SecureRandom.base64,
      boot: false,
      delete_with_server: false,
      encrypted: false,
      filesystem_label: nil,
      filesystem_type: "ext4",
      locked: false,
      serial: "vol-12345",
      size: 10_240,
      source: nil,
      source_type: "raw",
      status: "detached",
      storage_type: "network",
      created_at: "2023-01-01T01:01:00Z",
      updated_at: "2023-01-01T01:01:05Z",
      deleted_at: nil,
      account: {
        id: "acc-12345",
        name: "Test account",
        status: "active"
      },
      image: {
        id: "img-12345",
        name: "Blank Disk Image",
        username: nil,
        status: "available",
        locked: false,
        description: "",
        source: "blank-image",
        source_trigger: "manual",
        arch: "x86_64",
        created_at: "2013-05-02T16:40:17.000Z",
        official: true,
        public: true,
        owner: "acc-12345"
      },
      server: nil,
      zone: {
        id: "zon-12345",
        handle: "gb1-a"
      }
    }
    JSON.dump(default.merge!(options))
  end
end
