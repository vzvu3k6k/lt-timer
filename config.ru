require_relative './lib/opal_builder'

use Rack::Static, urls: {
  '/' => 'static/index.html',
  '/main.css' => 'static/main.css'
}

run Proc.new { |env|
  unless env[Rack::PATH_INFO] == '/app.js'
    return ['404', { 'Content-Type' => 'text'}, ['Not Found']]
  end

  [
    '200',
    {
      'Content-Type' => 'application/javascript',
      'Cache-Control' => 'no-store'
    },
    [OpalBuilder.build('app').to_s]
  ]
}
