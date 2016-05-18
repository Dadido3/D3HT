; #################################################### Documentation #############################################

; #################################################### Includes ##################################################

; #################################################### Declares ##################################################

; #################################################### Structures ################################################

Structure Table
  *D3HT_Table
  
  Description.s
EndStructure

Structure _PROCESS_MEMORY_COUNTERS_EX
  cb.l
  PageFaultCount.l
  PeakWorkingSetSize.i
  WorkingSetSize.i
  QuotaPeakPagedPoolUsage.i
  QuotaPagedPoolUsage.i
  QuotaPeakNonPagedPoolUsage.i
  QuotaNonPagedPoolUsage.i
  PagefileUsage.i
  PeakPagefileUsage.i
  PrivateUsage.i
EndStructure

; #################################################### Includes ##################################################

OpenConsole()

XIncludeFile "Includes/D3HT.pbi"

; #################################################### Procedures ################################################

Prototype pGetProcessMemoryInfo(a,b,c)

Procedure GetProcessPrivateUsage(pid)
  Protected ppsmemCounters._PROCESS_MEMORY_COUNTERS_EX
  Protected GetProcessMemoryInfo_.pGetProcessMemoryInfo
  Protected hlib = OpenLibrary(#PB_Any, "Psapi.dll")
  If hlib
    GetProcessMemoryInfo_.pGetProcessMemoryInfo = GetFunction(hlib, "GetProcessMemoryInfo")
    If GetProcessMemoryInfo_
      GetProcessMemoryInfo_(pid, ppsmemCounters, SizeOf(_PROCESS_MEMORY_COUNTERS_EX))
    EndIf
    CloseLibrary(hlib)
  EndIf
  ProcedureReturn ppsmemCounters\PrivateUsage

EndProcedure

; #################################################### Startup ###################################################

NewList Table.Table()
AddElement(Table())
Table()\D3HT_Table = D3HT::Create(SizeOf(Long), SizeOf(Integer), 65536*4, D3HT::#Default, D3HT::#Alg_CRC32)
Table()\Description = "Algorithm:CRC32 | Tablesize:65536*4 | Sidesearch_Depth:#Default"
AddElement(Table())
Table()\D3HT_Table = D3HT::Create(SizeOf(Long), SizeOf(Integer), 65536*4, D3HT::#Default, D3HT::#Alg_SDBM)
Table()\Description = "Algorithm:SDBM | Tablesize:65536*4 | Sidesearch_Depth:#Default"
AddElement(Table())
Table()\D3HT_Table = D3HT::Create(SizeOf(Long), SizeOf(Integer), 65536*4, D3HT::#Default, D3HT::#Alg_Bernsteins)
Table()\Description = "Algorithm:Bernsteins | Tablesize:65536*4 | Sidesearch_Depth:#Default"
AddElement(Table())
Table()\D3HT_Table = D3HT::Create(SizeOf(Long), SizeOf(Integer), 65536*4, D3HT::#Default, D3HT::#Alg_STL)
Table()\Description = "Algorithm:STL | Tablesize:65536*4 | Sidesearch_Depth:#Default"
AddElement(Table())
Table()\D3HT_Table = D3HT::Create(SizeOf(Long), SizeOf(Integer), 65536*4, D3HT::#Default, D3HT::#Alg_MurmurHash3)
Table()\Description = "Algorithm:MurmurHash3 | Tablesize:65536*4 | Sidesearch_Depth:#Default"
AddElement(Table())
Table()\D3HT_Table = D3HT::Create(SizeOf(Long), SizeOf(Integer), 65536*4, D3HT::#Default, D3HT::#Alg_MeiyanHash)
Table()\Description = "Algorithm:MeiyanHash | Tablesize:65536*4 | Sidesearch_Depth:#Default"
AddElement(Table())
Table()\D3HT_Table = D3HT::Create(SizeOf(Long), SizeOf(Integer), 65536*4, D3HT::#Default, D3HT::#Alg_FNV32)
Table()\Description = "Algorithm:FNV32 | Tablesize:65536*4 | Sidesearch_Depth:#Default"

; #################################################### Main ######################################################

#Amount = 1000000

Type_Counter = 0

ForEach Table()
  PrintN("")
  PrintN("----------- ~ D3HT | "+Table()\Description+" ~ ---")
  *D3HT_Table = Table()\D3HT_Table
  
  Memory_Start.i = GetProcessPrivateUsage(GetCurrentProcess_())
  
  Time = ElapsedMilliseconds()
  Old_Amount = D3HT::Get_Elements(*D3HT_Table)
  For i = 1 To #Amount
    Test = i;Random(#Amount)
    D3HT::Element_Set_Integer(*D3HT_Table, @Test, i)
    If i & $3FFF = $3FFF
      Print(".")
    EndIf
  Next
  PrintN("")
  PrintN("Created "+Str(D3HT::Get_Elements(*D3HT_Table)-Old_Amount)+" elements. It took "+StrF((ElapsedMilliseconds()-Time)/1000, 3)+"s")
  PrintN("  List contains now "+Str(D3HT::Get_Elements(*D3HT_Table))+" elements. Memory Usage: "+StrF(D3HT::Get_Memoryusage(*D3HT_Table)/1000000, 3)+"MB ("+StrF((GetProcessPrivateUsage(GetCurrentProcess_()) - Memory_Start)/1000000, 3)+" MB)")
  
  
  Time = ElapsedMilliseconds()
  ;D3HT::Clear(*D3HT_Table)
  For i = 1 To #Amount
    Test = i;Random(123000)
    If Not D3HT::Element_Get_Integer(*D3HT_Table, @Test) = i
      ; #### This shouldn't appear
      PrintN("Something is wrong here, the element doesnt have the expected value!")
    EndIf
    If i & $3FFF = $3FFF
      Print(".")
    EndIf
  Next
  PrintN("")
  PrintN("Read and checked "+Str(i-1)+" elements. It took "+StrF((ElapsedMilliseconds()-Time)/1000, 3)+"s")
  
  
  Time = ElapsedMilliseconds()
  Old_Amount = D3HT::Get_Elements(*D3HT_Table)
  For i = 1 To #Amount
    Test = i;Random(123000)
    D3HT::Element_Free(*D3HT_Table, @Test)
    If i & $3FFF = $3FFF
      Print(".")
    EndIf
  Next
  PrintN("")
  ; #### You can also use:
  ;D3HT::Clear(*D3HT_Table)
  ; #### Should be much faster than deleting each element...
  PrintN("Deleted "+Str(Old_Amount-D3HT::Get_Elements(*D3HT_Table))+" elements. It took "+StrF((ElapsedMilliseconds()-Time)/1000, 3)+"s")
  PrintN("  List contains now "+Str(D3HT::Get_Elements(*D3HT_Table))+" elements. Memory Usage: "+StrF(D3HT::Get_Memoryusage(*D3HT_Table)/1000000, 3)+"MB ("+StrF((GetProcessPrivateUsage(GetCurrentProcess_()) - Memory_Start)/1000000, 3)+" MB)")
  
  D3HT::Destroy(*D3HT_Table)
  Table()\D3HT_Table = #Null
Next

PrintN("")
PrintN("-------------- ~ Purebasic Map | Tablesize:65536*4 ~ -------------------")

Memory_Start.i = GetProcessPrivateUsage(GetCurrentProcess_())

NewMap PB_Map.i(65536*4)

Time = ElapsedMilliseconds()
Old_Amount = MapSize(PB_Map())
For i = 1 To #Amount
  Test = i;Random(#Amount)
  PB_Map(Str(Test)) = i
  If i & $3FFF = $3FFF
    Print(".")
  EndIf
Next
PrintN("")
PrintN("Created "+Str(MapSize(PB_Map())-Old_Amount)+" elements. It took "+StrF((ElapsedMilliseconds()-Time)/1000, 3)+"s")
PrintN("  List contains now "+Str(MapSize(PB_Map()))+" elements. Memory Usage: "+StrF((GetProcessPrivateUsage(GetCurrentProcess_()) - Memory_Start)/1000000, 3)+" MB")

Time = ElapsedMilliseconds()
;D3HT::Clear(*D3HT_Table)
For i = 1 To #Amount
  Test = i;Random(123000)
  If Not PB_Map(Str(Test)) = i
    ; #### This shouldn't appear
    PrintN("Something is wrong here, the element doesnt have the expected value!")
  EndIf
  If i & $3FFF = $3FFF
    Print(".")
  EndIf
Next
PrintN("")
PrintN("Read and checked "+Str(i-1)+" elements. It took "+StrF((ElapsedMilliseconds()-Time)/1000, 3)+"s")

Time = ElapsedMilliseconds()
Old_Amount = MapSize(PB_Map())
For i = 1 To #Amount
  Test = i;Random(123000)
  DeleteMapElement(PB_Map(), Str(Test))
  If i & $3FFF = $3FFF
    Print(".")
  EndIf
Next
PrintN("")
; #### You can also use:
;D3HT::Clear(*D3HT_Table)
; #### Should be much faster than deleting each element...
PrintN("Deleted "+Str(Old_Amount-MapSize(PB_Map()))+" elements. It took "+StrF((ElapsedMilliseconds()-Time)/1000, 3)+"s")
PrintN("  List contains now "+Str(MapSize(PB_Map()))+" elements. Memory Usage: "+StrF((GetProcessPrivateUsage(GetCurrentProcess_()) - Memory_Start)/1000000, 3)+" MB")

PrintN("")
PrintN("-------------- ~ Purebasic List: Selecting each element by iterating throught list ~ -------------------")
PrintN("(This will take long)")

Memory_Start.i = GetProcessPrivateUsage(GetCurrentProcess_())

NewList PB_List.i()

Time = ElapsedMilliseconds()
Old_Amount = ListSize(PB_List())
For i = 1 To #Amount
  Test = i;Random(#Amount)
  AddElement(PB_List())
  PB_List() = i
  If i & $3FFF = $3FFF
    Print(".")
  EndIf
Next
PrintN("")
PrintN("Created "+Str(ListSize(PB_List())-Old_Amount)+" elements. It took "+StrF((ElapsedMilliseconds()-Time)/1000, 3)+"s")
PrintN("  List contains now "+Str(ListSize(PB_List()))+" elements. Memory Usage: "+StrF((GetProcessPrivateUsage(GetCurrentProcess_()) - Memory_Start)/1000000, 3)+" MB")

Time = ElapsedMilliseconds()
;D3HT::Clear(*D3HT_Table)
For i = 1 To #Amount
  Test = i;Random(123000)
  ForEach PB_List()
    If PB_List() = Test
      If Not PB_List() = i ; Well, it's not needed. But as the others do that too we simulate the comparison here.
        ; #### This shouldn't appear
        PrintN("Something is wrong here, the element doesnt have the expected value!")
      EndIf
      Break
    EndIf
  Next
  
  If i & $3FFF = $3FFF
    Print(".")
  EndIf
Next
PrintN("")
PrintN("Read and checked "+Str(i-1)+" elements. It took "+StrF((ElapsedMilliseconds()-Time)/1000, 3)+"s")

Time = ElapsedMilliseconds()
Old_Amount = ListSize(PB_List())
While FirstElement(PB_List())
  ;Test = i;Random(123000)
  DeleteElement(PB_List())
  If i & $3FFF = $3FFF
    Print(".")
  EndIf
Wend
PrintN("")
PrintN("Deleted "+Str(Old_Amount-ListSize(PB_List()))+" elements. It took "+StrF((ElapsedMilliseconds()-Time)/1000, 3)+"s")
PrintN("  List contains now "+Str(ListSize(PB_List()))+" elements. Memory Usage: "+StrF((GetProcessPrivateUsage(GetCurrentProcess_()) - Memory_Start)/1000000, 3)+" MB")

Input()
; IDE Options = PureBasic 5.42 LTS (Windows - x64)
; CursorPosition = 152
; FirstLine = 123
; Folding = -
; EnableXP
; DisableDebugger
; Compiler = PureBasic 5.42 LTS (Windows - x64)