require 'ovto'
require 'native'

class MyApp < Ovto::App
  # 5 minutes by default
  def self.presentation_time
    match = $$.location.hash.match(/^#t=(?:(\d+)m)?(?:(\d+)s)?$/)
    return 3000 unless match # 5 minutes by default
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
      [end_time - now, 0].max
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
        o 'div', class: 'text-container' do
          o 'div', class: 'text-subcontainer' do
            minutes = (state.remain_seconds / 60).floor
            seconds = (state.remain_seconds % 60).floor

            classes =
              if minutes.positive?
                %w[big small]
              else
                %w[small big]
              end

            o 'span', { class: "minutes #{classes[0]}" }, minutes
            o 'span', { class: 'label' }, 'min'
            o 'span', { class: "seconds #{classes[1]}" }, seconds
            o 'span', { class: 'label' }, 'sec'
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
