require 'opal'
require 'ovto'
require 'native'

require 'components/remained_time'

class MyApp < Ovto::App
  # 5 minutes by default
  def self.presentation_time
    match = $$.location.hash.match(/^#t=(?:(\d+)m)?(?:(\d+)s)?$/)
    return 300 unless match
    min, sec = match.captures.map(&:to_i)
    min * 60 + sec
  end

  def setup
    # TODO: stop the loop on removing this app
    loop = -> {
      actions.update_now
      $$.requestAnimationFrame(loop)
    }
    loop.call
  end

  class State < Ovto::State
    item :start_time, default: Time.now
    item :now, default: Time.now

    def end_time
      start_time + MyApp.presentation_time
    end

    def remain_seconds
      end_time - now
    end
  end

  class Actions < Ovto::Actions
    def update_now
      { now: Time.now }
    end
  end

  class MainComponent < Ovto::Component
    def render
      o 'div', class: 'timer' do
        o 'div', class: "text-container #{'over' if state.remain_seconds.negative?}" do
          o 'div', class: 'text-subcontainer' do
            o Components::RemainedTime, remain_seconds: state.remain_seconds
          end
        end

        o 'div', class: 'progress-container' do
          o 'progress', max: MyApp.presentation_time, value: state.remain_seconds
        end
      end
    end
  end
end

MyApp.run(id: 'ovto')
