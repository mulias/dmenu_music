class MusicController

  # display menus and parse user row selection
  
  # identify new menus to generate
  require_relative './../menu_struct/MenuStruct'
  include MenuStruct
  # send sommands to mpd
  require_relative './../mpd/MpdOptions'
  include MpdOptions

  # menu_struct is the menu system defined as MenuStruct items
  # history is a stack to keep track of current position in the menu structure
  def initialize (view, model, menu_struct)
    @view = view
    @mpd = model
    @main_menu = menu_struct
    @history = [@main_menu]
  end
  
  # render the menu, execute the action attached to the selected row, then loop
  def view_and_parse
    # Show the menu at the top of history
    # until the user hits ESC, parse each selected row
    menu = @view.build_menu(@history.last)
    if (row = menu.run) != nil
      selected = row.value
      # if the row leads to a new menu, put that on top of history
      # if it's a command, execute with any given arguments
      (selected.instance_of? Menu) ? @history << selected : send(*selected)
      view_and_parse
    end
  end
  
  # go back one menu level
  def back_history
    @history.pop
    # make sure that we don't back up past main menu
    @history << @main_menu if @history.empty?
  end
  
end
