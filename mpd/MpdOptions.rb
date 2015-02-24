module MpdOptions

  # commands sent to mpd
  
  def add_track (track)
    clear_and_play do
      @mpd.add(track)
    end
  end

  def add_path (path)
    clear_and_play do
      @mpd.add(path)
    end
  end

  def add_artist (artist)
    clear_and_play do
      # add first track, then add remaining in background
      # this prevents the menu from blocking while songs get added
      tracks = @mpd.where(:artist => content)
      @mpd.add(tracks.first)
      Thread.new{ add_track_list(tracks.drop(1)) }
    end
  end

  def add_album (album)
    clear_and_play do
      # add first track, then add remaining in background
      # this prevents the menu from blocking while songs get added
      tracks = @mpd.where(:album => content)
      @mpd.add(tracks.first)
      Thread.new{ add_track_list(tracks.drop(1)) }
    end
  end

  def clear_and_play
    @mpd.clear if !@mpd.playing? && !@mpd.paused?
    yield
    @mpd.play if !@mpd.paused?
  end

  def add_track_list (tracks)
    tracks.each { |track| @mpd.add(track) }
  end

  def shuffle_queue
    @mpd.shuffle
  end

  def swap pos
    current = @mpd.current_song.pos
    if current != nil && pos != current
      @mpd.move(pos, current + 1)
      @mpd.next
      @mpd.move(current, pos)
    end
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
