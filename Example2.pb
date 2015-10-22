; #################################################### Includes ##################################################

XIncludeFile "Includes/D3HT.pbi"

; #################################################### Structures ################################################

Structure Table_Key
  Name.s{100}     ; Only strings with a fixed lengths can be used as a key
  
  X.l
  Y.l
EndStructure

; #################################################### Startup ###################################################

OpenConsole()

; #### Create table
*D3HT_Table = D3HT::Create(SizeOf(Table_Key), SizeOf(Integer), 65536)

; #################################################### Main ######################################################

; #### Display the amount of elements
PrintN("Elements in the table: "+Str(D3HT::Get_Elements(*D3HT_Table)))

; #### Create an element, set value to 123456
Key.Table_Key\Name = "Test"
Key.Table_Key\X = 2
Key.Table_Key\Y = 1
D3HT::Element_Set_Integer(*D3HT_Table, @Key, 123456)
PrintN("Element with the value 123456 created")

; #### Overwrite the previously created element, set value to 789456123
Key.Table_Key\Name = "Test"
Key.Table_Key\X = 2
Key.Table_Key\Y = 1
D3HT::Element_Set_Integer(*D3HT_Table, Key, 789456123)
PrintN("Changed the value of the previously created element to 789456123")

; #### Create a new element, set value to 5
Key.Table_Key\Name = "Test"
Key.Table_Key\X = 3
Key.Table_Key\Y = 1
D3HT::Element_Set_Integer(*D3HT_Table, @Key, 5)
PrintN("Element with the value 5 created")

; #### Display the amount of elements
PrintN("Elements in the table: "+Str(D3HT::Get_Elements(*D3HT_Table)))

; #### Return the value of an element, it should return 789456123
Key.Table_Key\Name = "Test"
Key.Table_Key\X = 2
Key.Table_Key\Y = 1
PrintN("Value of an element: "+Str(D3HT::Element_Get_Integer(*D3HT_Table, @Key)))

; #### Clear all elements from the table
D3HT::Clear(*D3HT_Table)
PrintN("Table cleared")

; #### Display the amount of elements
PrintN("Elements in the table: "+Str(D3HT::Get_Elements(*D3HT_Table)))

; #### Destroy the table. This will free all memory, *D3HT_Table is now invalid
D3HT::Destroy(*D3HT_Table)
*D3HT_Table = #Null

Input()
; IDE Options = PureBasic 5.40 LTS Beta 8 (Windows - x64)
; CursorPosition = 19
; FirstLine = 17
; EnableUnicode
; EnableXP
; DisableDebugger