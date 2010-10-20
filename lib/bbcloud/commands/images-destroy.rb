desc 'Destroy images'
arg_name 'image-id...'
command [:destroy] do |c|

  c.action do |global_options,options,args|

    images = Image.find(args).compact

    images.each do |i|
      info "Destroying image #{i}"
      i.destroy
      i.reload
    end

    render_table(images)

  end
end
