require 'ovto'

module Components
  class RemainedTime < Ovto::Component
    def render(remain_seconds:)
      abs_remain_seconds = remain_seconds.abs
      minutes = (abs_remain_seconds / 60).floor
      seconds = (abs_remain_seconds % 60).floor

      # Maybe this is too hacky.
      $$.document.title = "#{remain_seconds.negative? ? '-' : ''}#{minutes}min #{seconds}sec"

      classes =
        if minutes.positive?
          %w[big small]
        else
          %w[small big]
        end

      o 'div' do
        o 'span', { class: "label #{classes[0]}" }, '-' if remain_seconds.negative?
        o 'span', { class: "minutes #{classes[0]}" }, minutes
        o 'span', { class: 'label' }, 'min'
        o 'span', { class: "seconds #{classes[1]}" }, seconds
        o 'span', { class: 'label' }, 'sec'
      end
    end
  end
end
