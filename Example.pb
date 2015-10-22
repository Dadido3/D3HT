; #################################################### Includes ##################################################

XIncludeFile "Includes/D3HT.pbi"

; #################################################### Startup ###################################################

OpenConsole()

; #### Create table
*D3HT_Table = D3HT::Create(SizeOf(Long), SizeOf(Integer), 65536)

; #################################################### Main ######################################################

; #### Display the amount of elements
PrintN("Elements in the table: "+Str(D3HT::Get_Elements(*D3HT_Table)))

; #### Create the element (456789), set value to 123456
Key.l = 456789
D3HT::Element_Set_Integer(*D3HT_Table, @Key, 123456)
PrintN("Element with the key 456789 and value 123456 created")

; #### Overwrite the element (456789), set value to 789456123
Key.l = 456789
Value.i = 789456123
D3HT::Element_Set(*D3HT_Table, @Key, @Value)
PrintN("Changed the value of the element 456789 to 789456123")

; #### Display the amount of elements
PrintN("Elements in the table: "+Str(D3HT::Get_Elements(*D3HT_Table)))

; #### Return the value of "Test", it should return 789456123
Key.l = 456789
PrintN("Value of (456789): "+Str(D3HT::Element_Get_Integer(*D3HT_Table, @Key)))

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
; CursorPosition = 17
; EnableUnicode
; EnableXP
; DisableDebugger