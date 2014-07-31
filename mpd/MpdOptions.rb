module MpdOptions

  def add_music (music_from, content)
    @mpd.clear if !@mpd.playing? && !@mpd.paused?
    case music_from
    when 'track'
    when 'path'
      @mpd.add(content)
    when 'artist'
      @mpd.where(:artist => content).each { |track| @mpd.add(track) }
    when 'album'
      @mpd.where(:album => content).each { |track| @mpd.add(track) }
    end
    @mpd.play if !@mpd.paused?
  end
  
  def shuffle_queue
    @mpd.shuffle
  end

  def toggle_play
    if !@mpd.playing? && !@mpd.paused?
      @mpd.play
    else
      @mpd.pause = !@mpd.paused?
    end
  end
  
  def prev_track
    pause_state = @mpd.paused?
    @mpd.previous
    @mpd.pause = pause_state
  end

  def next_track
    pause_state = @mpd.paused?
    @mpd.next
    @mpd.pause = pause_state
  end

  def clear_queue
    @mpd.clear
  end

  def random
    @mpd.random = !@mpd.random?
  end

  def loop_track
    @mpd.single = !@mpd.single?
  end

  def loop_list
    @mpd.repeat = !@mpd.repeat?
  end
  
  def update_db
    @mpd.update
  end
  
end