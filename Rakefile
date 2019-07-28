require_relative './lib/opal_builder'

desc 'compile into js'
task :default do
  builder = OpalBuilder.build('app')
  File.write('static/app.js', builder.to_s)
end

desc 'start auto-compiling'
task :watch do
  sh 'ifchanged app.rb -d "bundle exec rake"'
end
