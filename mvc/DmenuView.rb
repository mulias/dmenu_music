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
    menu.items = build_menu_rows(format_dynamic_rows(menu_struct.rows))
    return menu
  end

  def format_dynamic_rows (struct_rows)
    all_rows = struct_rows.flat_map do |row|
      (row.instance_of? RowsOf) ? send(*row.format_function) : row
    end
    return all_rows
  end

  def build_menu_rows (struct_rows) 
    items = struct_rows.map do |row|
      # if text is a symbol, execute as a method that returns needed text line
      text = (row.text.is_a? Symbol) ? send(row.text) : row.text
      Dmenu::Item.new(text, row.action)
    end 
    return items
  end
  
  def format_tracks (formatter, search)
    data = @mpd.where(:album => search)
    format_rows(data, formatter)
  end

  def format_albums (formatter, search)
    data = @mpd.albums(search)
    format_rows(data, formatter)
  end

  def format_queue (formatter)
    # first track in queue is the currently playing track
    # max of 98 tracks (5 menu screens) for display speed
    first_pos = @mpd.current_song ? @mpd.current_song.pos : 0
    last_pos = 97 + first_pos
    data = @mpd.queue(first_pos .. last_pos)
    format_rows(data, formatter)
  end

  def format_artists (formatter)
    data = @mpd.artists
    format_rows(data, formatter)
  end

  
  # format each Row struct as specified by the formatter proc
  def format_rows (data, formatter)
    # call the proc in MusicMenus for each row
    data.map do |row_data|
      formatter.call(row_data)
    end
  end
  
end
