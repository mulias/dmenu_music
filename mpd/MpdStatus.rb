module MpdStatus

  # displayed text in menus, dependent on mpd state
  
  def play_status
    @mpd.playing? ? 'Pause' : 'Play'
  end
  
  def random_status
    "Random: #{@mpd.random?}"
  end
  
  def loop_status
    "Loop Track: #{@mpd.single?}"
  end
  
  def loop_list_status
    "Loop Playlist: #{@mpd.repeat?}"
  end

end