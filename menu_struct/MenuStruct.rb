module MenuStruct

  # set of structs to describe a menu tree
  
  # Menu represents a menu populated with Rows
  # :prompt is the message at the top right of the menu
  # :rows is an array of Row, RowsOf, and RowIf structs, representing all the 
  # options to scroll through and select from
  Menu = Struct.new(:prompt, :rows)

  # Row represents the contents of one menu row
  # :text is the visible content the user will see in the row
  # :action is what happens when the row is selected, either a method that will
  # be executed, or a new menu to generate
  Row = Struct.new(:text, :action)
  
  # RowsOf represents a number of rows generated from a set of data
  # :format_function is a function that returns an array of rows. The function
  # should take as arguments a formatter proc, that defines the layout of each
  # row, and whatever search strings are needed to narrow the data set
  RowsOf = Struct.new(:format_function)

  # RowIf represents a row that is only present under certain conditions
  # :text is the visible content the user will see, if the row is used
  # :condition is the boolean function used to determine when to use the row
  # :action is what happens when the row is selected, either a method that will
  # be executed, or a new menu to generate
  RowIf = Struct.new(:text, :condition, :action)
  
end
