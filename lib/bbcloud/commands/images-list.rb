desc 'List available images'
arg_name '[image-id...]'
command [:list] do |c|
  c.action do |global_options, options, args|
    images = Image.find args
    render_table(images, global_options)
  end
end
