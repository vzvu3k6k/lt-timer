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
      [end_time - now, 0].max
    end
  end

  class Actions < Ovto::Actions
    def set_timer
      $$.requestAnimationFrame(-> { actions.set_timer })
      { now: Time.now }
    end
  end

  class MainComponent < Ovto::Component
    def render
      o 'div', class: 'timer' do
        minutes = (state.remain_seconds / 60).floor
        seconds = (state.remain_seconds % 60).floor

        classes =
          if minutes.positive?
            %w[strong weak]
          else
            %w[weak strong]
          end

        o 'span', { class: "minutes #{classes[0]}" }, minutes
        o 'span', { class: "seconds #{classes[1]}" }, seconds

        o 'progress', max: PRESENTATION_TIME, value: state.remain_seconds
      end
    end
  end
end

MyApp.run(id: 'ovto')
