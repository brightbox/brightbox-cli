module Brightbox

  def self.dot_id(id)
    id = id.to_s.gsub(/[-.:\/]/,'_')
    id = "i" + id if id =~ /^[0-9_]/
    id
  end

  desc 'Ouput a summary of firewall policies for use with graphviz'
  command [:graphviz] do |c|
    c.desc "Show servers"
    c.default_value false
    c.switch :e, "show-servers"

    c.action do |global_options,options,args|
      servers = Server.find(:all)

      groups = {}
      ServerGroup.find(:all).each { |g| groups[g.id] = OpenStruct.new(:group => g, :servers => []) }
      servers.each { |s| s.server_groups.each { |g| groups[g["id"]].servers << s } }

      puts "digraph G {"
      puts "node [colorscheme=paired12];"
      puts "edge [colorscheme=paired12];"

      # Render the servers
      if options[:e]
        servers.each do |s|
          puts '%s [label="%s\n%s",shape=box,style=filled,color=1];' % [dot_id(s), s.name, s.id]
          s.server_groups.each { |g| puts '%s -> %s [dir=none];' % [dot_id(g["id"]), dot_id(s.id)] }
        end
      end

      # Render groups
      groups.each do |id, g|
        puts '%s [label="%s\n%s",shape=hexagon,style=filled,color=3];' % [dot_id(id), id, g.group.name]
      end

      # Build a list of things the rules point to and from
      policies = FirewallPolicy.find(:all)
      firewall_nodes = Set.new
      firewall_paths = Set.new
      firewall_services = Set.new
      policies.each do |p|
        next if p.server_group_id.nil?
        g = dot_id(p.server_group_id)
        p.rules.each do |r|
          firewall_nodes.add(r["source"])
          firewall_nodes.add(r["destination"])
          source = dot_id(r["source"])
          source = g if source.empty?
          dest = dot_id(r["destination"])
          dest = g if dest.empty?
          firewall_paths.add([source, dest])
        end
      end

      # Render them
      firewall_paths.each do |fp|
        puts "%s -> %s [color=6];" % fp
      end

      firewall_nodes.each do |n|
        next if n =~ /^(grp|srv)/ or n.nil?
        puts "#{dot_id(n)} [label=\"#{n}\",color=5,shape=box,style=filled];"
      end

      puts "}"
    end
  end
end
