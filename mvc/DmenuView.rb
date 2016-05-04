class DmenuView

  # turn MenuStructs into dmenu objects
  
  # makes new menus
  require 'dmenu'
  # procedures to generate menu rows from data
  require_relative './../menu_struct/MusicMenus'
  include MusicMenus
  # print mpd state info, play/pause, random, etc
  require_relative './../mpd/MpdStatus'
  include MpdStatus

  def initialize (model)
    @mpd = model
  end

  # basic settings for all menus
  def dmenu_init
    menu = Dmenu.new
    menu.position = :bottom
    menu.font = 'Sans-10'
    menu.case_insensitive = true
    menu.lines = 20
    return menu
  end
  
  # create a dmenu object from a MenuStruct item
  def build_menu (menu_struct)
    menu = dmenu_init
    menu.prompt = menu_struct.prompt
    menu.items = build_menu_rows(menu_struct.rows)
    return menu
  end

  def build_menu_rows (struct_rows) 
    expand_rows(struct_rows).map do |row|
      # if text is a symbol, execute as a method that returns needed text line
      text = (row.text.is_a? Symbol) ? send(row.text) : row.text
      Dmenu::Item.new(text, row.action)
    end 
  end
 
  def expand_rows (struct_rows)
    format_dynamic_rows(struct_rows).reject do |row| 
      (row.instance_of? RowIf) && !send(*row.condition)
    end
  end

  def format_dynamic_rows (struct_rows)
    struct_rows.flat_map do |row|
      (row.instance_of? RowsOf) ? send(*row.format_function) : row
    end
  end
 
  def format_tracks (formatter, album, artist = nil)
    tracks = artist ? @mpd.where({:album => album, :artist => artist}, {:strict => true}) :
                      @mpd.where({:album => album}, {:strict => true})
    tracks.map { |track| formatter.call(track) }
  end

  def format_albums (formatter, artist)
    return [] if artist == ""
    @mpd.where(albumartist: artist)
        .map { |song| song.album }.uniq.compact
        .map { |album| formatter.call(album, artist) }
  end

  def format_queue (formatter)
    # first track in queue is the currently playing track
    # max of 98 tracks (5 menu screens) for display speed
    first_pos = @mpd.current_song ? @mpd.current_song.pos : 0
    last_pos = 97 + first_pos
    @mpd.queue(first_pos .. last_pos).map { |track| formatter.call(track) }
  end

  def format_artists (formatter)
    artists = @mpd.list :albumartist
    real_artists = artists[0] == "" ? artists.drop(1) : artists
    real_artists.map { |artist| formatter.call(artist) }
  end

  def is_multi_artist (album)
    album_tracks = @mpd.where({:album => album}, {:strict => true})
    an_artist = album_tracks.first.artist
    artist_tracks = @mpd.where({:artist => an_artist, :album => album}, {:strict => true})
    return album_tracks.count != artist_tracks.count
  end

  def has_uncatagorized_music
    misc = @mpd.where({:artist => "", :album => ""}, {:strict => true})
    return misc.count != 0
  end 
  
end
