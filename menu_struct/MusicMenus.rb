module MusicMenus

  # provides Row, RowOf, and Menu structs
  require_relative 'MenuStruct'
  include MenuStruct

  # Symbols represent methods to be called. When used as title text, the method
  # will sub in text. When as an action, the method will send a command to mpd 
  #
  # Methods with arguments are placed in an array. The first element is the 
  # symbol for the method, and following elements are arguments, all non-symbols
  #
  # variables ending in _row are procedures to generate additional rows
  
  #procedures
  queued_track_row = Proc.new do |track| 
    Row.new("#{track.artist} -- #{track.title}", [:swap, track.pos])
  end
   
  track_row = Proc.new do |track|
    Row.new("#{track.artist} -- #{track.title}", [:add_music, 'track', track])
  end 
   
  album_row = Proc.new do |album|
    Row.new(album, Menu.new(album,
                            [Row.new('> Back', :back_history),
                             Row.new('> Play Album', [:add_music, 'album', album]),
                             RowsOf.new(track_row, 'tracks', album )
                            ]))
  end
  
  artist_row = Proc.new do |artist|
    Row.new(artist, Menu.new(artist,
                             [Row.new('> Back', :back_history),
                              Row.new('> Play All', [:add_music, 'artist', artist]),
                              RowsOf.new(album_row, 'albums', artist)
                             ]))
  end
   
  # full menu tree, starting from main menu
  MAIN = Menu.new('Music Player',
                  [Row.new('Queue', 
                           Menu.new('Queue',
                                    [Row.new('> Back', :back_history),
                                     Row.new('> Shuffle', :shuffle_queue),
                                     RowsOf.new(queued_track_row, 'queued_tracks')
                                    ])),
                   Row.new('Music', 
                           Menu.new('Music',
                                    [Row.new('> Back', :back_history),
                                     Row.new('> Play All', [:add_music, 'path', '/']),
                                     RowsOf.new(artist_row, 'artists')
                                    ])),
                   Row.new('Playlists', :back_history),
                   Row.new('Podcasts', :back_history),
                   Row.new('Options', 
                           Menu.new('Options',
                                    [Row.new('> Back', :back_history),
                                     Row.new(:play_status, :toggle_play),
                                     Row.new('Previous', :prev_track),
                                     Row.new('Next', :next_track),
                                     Row.new('Clear', :clear_queue), 
                                     Row.new(:random_status, :random),
                                     Row.new(:loop_status, :loop_track),
                                     Row.new(:loop_list_status, :loop_list),
                                     Row.new('Update Database', :update_db)
                                    ]))
                   ])
                         
end