module MusicMenus

  # a music menu tree using MenuStructs to describe menu elements

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
  queued_row_format = Proc.new do |track| 
    Row.new("#{track.artist} -- #{track.title}", [:swap, track.pos])
  end
   
  track_row_format = Proc.new do |track|
    Row.new("#{track.artist} -- #{track.title}", [:add_track, track])
  end 
   
  album_row_format = Proc.new do |album, artist|
    Row.new(album, 
            Menu.new(album,
                     [Row.new('> Back', :back_history),
                      Row.new('> Play All', [:add_album, album]),
                      RowIf.new("> Only By #{artist}", 
                                [:is_multi_artist, album],
                                Menu.new("#{artist} -- #{album}",
                                         [Row.new('> Back', :back_history),
                                          Row.new('> Play All', [:add_album_by_artist, album, artist]),
                                          RowsOf.new([:format_tracks, track_row_format, album, artist])
                                         ])),
                      RowsOf.new([:format_tracks, track_row_format, album])
                     ]))
  end
  
  artist_row_format = Proc.new do |artist|
    Row.new(artist, 
            Menu.new(artist,
                     [Row.new('> Back', :back_history),
                      Row.new('> Play All', [:add_artist, artist]),
                      RowsOf.new([:format_albums, album_row_format, artist])
                     ]))
  end
   
  # full menu tree, starting from main menu
  MAIN = Menu.new('Music Player',
                  [Row.new('Queue', 
                           Menu.new('Queue',
                                    [Row.new('> Back', :back_history),
                                     Row.new('> Shuffle', :shuffle_queue),
                                     RowsOf.new([:format_queue, queued_row_format])
                                    ])),
                   Row.new('Music', 
                           Menu.new('Music',
                                    [Row.new('> Back', :back_history),
                                     Row.new('> Play All', [:add_path, '/']),
                                     RowsOf.new([:format_artists, artist_row_format])
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
