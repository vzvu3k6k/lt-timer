require 'ovto'
require 'native'

class MyApp < Ovto::App
  # 5 minutes
  PRESENTATION_TIME = 60 * 5

  def setup
    actions.set_timer
  end

  class State < Ovto::State
    item :start_time, default: Time.now
    item :now, default: Time.now

    def end_time
      start_time + PRESENTATION_TIME
    end

    def remain_seconds
      [end_time - Time.now, 0].max
    end

    def format_time
      seconds = remain_seconds
      '%02d:%02d' % [seconds / 60, seconds % 60]
    end
  end

  class Actions < Ovto::Actions
    def set_timer
      $$.setTimeout(-> { actions.set_timer }, 1000)
      { now: Time.now }
    end
  end

  class MainComponent < Ovto::Component
    def render
      o 'div', class: 'timer' do
        o 'span', state.format_time
        o 'progress', max: PRESENTATION_TIME, value: state.remain_seconds
      end
    end
  end
end

MyApp.run(id: 'ovto')
