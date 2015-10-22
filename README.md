# D3HT
A simple Hashtable, which maps fixed length keys to fixed length values.
As key you can use any kind of integer, float, strings with a fixed size or even structures.

## Usage
Create Table:
```
*D3HT_Table = D3HT::Create(SizeOf(Long), SizeOf(Integer), 65536)
```

Map value to key:
```
Key.l = 1111
D3HT::Element_Set_Integer(*D3HT_Table, @Key, 123456)
```

Get mapped value:
```
Key.l = 1111
Debug D3HT::Element_Get_Integer(*D3HT_Table, @Key)
```

## Speed
Even though there is more room for optimisation, this include offers much more speed than the maps of PB.
Well, it's unfair to compare them directly.
But if you don't want to use strings as index but any other type PureBasic offers, then you would you need to convert these types into a string before you can use it as key.
With D3HT you don't have that overhead

D3HT with a base table size of 262144 elements:
```
Created 1000000 elements. It took 0.167s
  List contains now 1000000 elements. Memory Usage: 13.632MB (13.685 MB)
Read and checked 1000000 elements. It took 0.133s
Deleted 1000000 elements. It took 0.060s
  List contains now 0 elements. Memory Usage: 0.000MB (0.008 MB)
```

The same operations with a map:
```
Created 1000000 elements. It took 109.952s
  List contains now 1000000 elements. Memory Usage: 48.554 MB
Read and checked 1000000 elements. It took 107.376s
Deleted 1000000 elements. It took 107.871s
  List contains now 0 elements. Memory Usage: 0.840 MB
```

As you can see D3HT is about 800 times faster and uses less memory if you have around a million elements.
