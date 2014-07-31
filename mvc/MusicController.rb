class MusicController

  require_relative './../menu_struct/MenuStruct'
  require_relative './../mpd/MpdOptions'
  include MenuStruct
  include MpdOptions

  def initialize (view, model)
    @view = view
    @mpd = model
    @history = []
  end
    
  def main_menu (menu_struct)
    # kick off the first menu
    @main_menu = menu_struct
    @history << @main_menu
    view_and_parse
  end
  
  def view_and_parse
    # render a menu, select an option, execute option, loop
    menu = @view.build_menu(@history.last)
    if (row = menu.run) != nil
      selected = row.value
      # if it's a new menu, go there next. 
      # else it's a command, execute with any given arguments
      (selected.instance_of? Menu) ? @history << selected : send(*selected)
      view_and_parse
    end
  end
  
  def back_history
    @history.pop
    # make sure that we don't back up past main menu
    @history << @main_menu if @history.empty?
  end
  
end
