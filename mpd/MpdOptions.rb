module MpdOptions

  # commands sent to mpd
  
  # add_music examples:
  # music_from = 'Artist', content = 'They Might Be Giants'
  # music_from = 'path', content = '~/username/podcasts/mike_detective'
  def add_music (music_from, content)
    @mpd.clear if !@mpd.playing? && !@mpd.paused?
    case music_from
    when 'track'
    when 'path'
      @mpd.add(content)
    when 'artist'
      # add first track, then add remaining in background
      # this prevents the menu from blocking while songs get added
      tracks = @mpd.where(:artist => content)
      @mpd.add(tracks.first)
      Thread.new{ add_track_list(tracks.drop(1)) }
    when 'album'
      tracks = @mpd.where(:album => content)
      @mpd.add(tracks.first)
      Thread.new{ add_track_list(tracks.drop(1)) }
    end
    # if not deliberatly paused, start music
    @mpd.play if !@mpd.paused?
  end
  
  def add_track_list (tracks)
    tracks.each { |track| @mpd.add(track) }
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
