require 'opal'

class OpalBuilder
  def self.build(*args)
    append_required_paths
    Opal::Builder.build(*args)
  end

  def self.append_required_paths
    return if @appended

    $LOAD_PATH.each do |path|
      Opal.append_path path
    end
    
    Opal.append_path '.'
    Opal.append_path 'lib'

    @appended = true
  end
end
