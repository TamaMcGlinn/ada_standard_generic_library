--  Copyright (c) 1996
--  Rensselaer Polytechnic Institute
--
--  Permission to use, copy, modify, distribute and sell this software
--  and its documentation for any purpose is hereby granted without fee,
--  provided that the above copyright notice appear in all copies and
--  that both that copyright notice and this permission notice appear
--  in supporting documentation.  Rensselaer Polytechnic Institute makes no
--  representations about the suitability of this software for any
--  purpose.  It is provided "as is" without express or implied warranty.
--

with Ada.Text_IO;
with System;
with System.Storage_Elements;
with Unchecked_Conversion;

with SGL.Input_Iterators;
with SGL.Forward_Iterators;

generic
   type T is limited private;
   with procedure Assign(To: in out T; From: in T) is <>;
   with procedure Initialize(X: in out T) is <>;
   with procedure Finalize(X: in out T) is <>;
package SGL.Default_Allocators is

   subtype Value_Type is T;
   type Pointer is access all T;
   pragma Controlled (Pointer);
   subtype Void_Pointer is System.Address;
   type Constant_Pointer is access constant T;
   pragma Controlled (Constant_Pointer);
   type Size_Type is new System.Storage_Elements.Storage_Count;
   type Difference_Type is new System.Storage_Elements.Storage_Offset;

   Value_Type_Size : constant Size_Type := Value_Type'Size/System.Storage_Unit;

   -- Allocation operations

   function Allocate(Size : in Size_Type) return Pointer;
   pragma Inline (Allocate);

   procedure Deallocate(P : in Pointer);
   pragma Inline (Deallocate);

   procedure Construct(P : in Pointer; A : in Value_Type);
   pragma Inline (Construct);

   procedure Destroy(P: in Pointer);
   pragma Inline (Destroy);

   function Init_Page_Size return Size_Type;
   pragma Inline (Init_Page_Size);

   function Max_Size return Size_Type;
   pragma Inline (Max_Size);

   function To_Size_Type(X: Difference_Type) return Size_Type;
   pragma Inline (To_Size_Type);

   function To_Difference_Type(X: Size_Type) return Difference_Type;
   pragma Inline (To_Difference_Type);

   --  Pointer arithmetic

   function "+" (Left : Pointer; Right : Difference_Type) return Pointer;
   function "+" (Left : Constant_Pointer; Right : Difference_Type)
                 return Constant_Pointer;
   function "+" (Left : Difference_Type; Right : Pointer) return Pointer;
   function "+" (Left : Difference_Type; Right : Constant_Pointer)
                 return Constant_Pointer;
   pragma Inline ("+");

   function "-" (Left : Pointer; Right : Difference_Type) return Pointer;
   function "-" (Left : Constant_Pointer; Right : Difference_Type)
                 return Constant_Pointer;
   function "-" (Left, Right : Pointer) return Difference_Type;
   function "-" (Left, Right : Constant_Pointer) return Difference_Type;
   pragma Inline ("-");

   function "<" (Left, Right : Pointer) return Boolean;
   function "<" (Left, Right : Constant_Pointer) return Boolean;
   pragma Inline ("<");

   function ">" (Left, Right : Pointer) return Boolean;
   function ">" (Left, Right : Constant_Pointer) return Boolean;
   pragma Inline (">");

   function "<=" (Left, Right : Pointer) return Boolean;
   function "<=" (Left, Right : Constant_Pointer) return Boolean;
   pragma Inline ("<=");

   function ">=" (Left, Right : Pointer) return Boolean;
   function ">=" (Left, Right : Constant_Pointer) return Boolean;
   pragma Inline (">=");

   function Is_Null(P : Pointer) return Boolean;
   function Is_Null(P : Constant_Pointer) return Boolean;
   pragma InLine (Is_Null);

   -- Mixed Size_Type/Difference_Type functions exported

   function "+"(A: Size_Type; B: Difference_Type) return Difference_Type;
   function "+"(A: Difference_Type; B: Size_Type) return Difference_Type;
   pragma Inline("+");
   function "-"(A: Size_Type; B: Difference_Type) return Difference_Type;
   function "-"(A: Difference_Type; B: Size_Type) return Difference_Type;
   pragma Inline("-");
   function "*"(A: Size_Type; B: Difference_Type) return Difference_Type;
   function "*"(A: Difference_Type; B: Size_Type) return Difference_Type;
   pragma Inline("*");
   function "/"(A: Size_Type; B: Difference_Type) return Difference_Type;
   function "/"(A: Difference_Type; B: Size_Type) return Difference_Type;
   pragma Inline("/");
   function "<"(A: Size_Type; B: Difference_Type) return Boolean;
   function "<"(A: Difference_Type; B: Size_Type) return Boolean;
   pragma Inline("<");
   function ">"(A: Size_Type; B: Difference_Type) return Boolean;
   function ">"(A: Difference_Type; B: Size_Type) return Boolean;
   pragma Inline(">");
   function ">="(A: Size_Type; B: Difference_Type) return Boolean;
   function ">="(A: Difference_Type; B: Size_Type) return Boolean;
   pragma Inline(">=");
   function "<="(A: Size_Type; B: Difference_Type) return Boolean;
   function "<="(A: Difference_Type; B: Size_Type) return Boolean;
   pragma Inline("<=");

   -- Conversion functions

   function Make_Constant(P : in Pointer) return Constant_Pointer;
   pragma Inline(Make_Constant);

   function To_Void    is new Unchecked_Conversion(Pointer, Void_Pointer);
   function To_Pointer is new Unchecked_Conversion(Void_Pointer, Pointer);
   function To_Constant_Pointer is new
     Unchecked_Conversion(Void_Pointer, Constant_Pointer);
   function To_Constant_Pointer is new
     Unchecked_Conversion(Pointer, Constant_Pointer);

   -- Operations

   generic
      with package Iterators is new SGL.Forward_Iterators(<>);
      with function Ref(X: Iterators.Iterator) return Pointer is <>;
   procedure Destroy_Sequence(First, Last : Iterators.Iterator);
   pragma Inline(Destroy_Sequence);

   generic
      with package Input_Iterators is new SGL.Input_Iterators(<>);
      with package Forward_Iterators is new SGL.Forward_Iterators(<>);
      with function Val(X: Input_Iterators.Iterator) return Value_Type is <>;
      with function Ref(X: Forward_Iterators.Iterator) return Pointer is <>;
   function Uninitialized_Copy(First, Last: Input_Iterators.Iterator;
                               Result: Forward_Iterators.Iterator)
                               return Forward_Iterators.Iterator;
   pragma Inline(Uninitialized_Copy);

   generic
      with package Iterators is new SGL.Forward_Iterators(<>);
      with function To_Allocator_Pointer(P:Iterators.Pointer)
                                         return Pointer is <>;
   procedure Uninitialized_Fill(First, Last : Iterators.Iterator;
                                X : Value_Type);
   pragma Inline(Uninitialized_Fill);

   generic
      with package Iterators is new SGL.Forward_Iterators(<>);
      with function Ref(X: Iterators.Iterator) return Pointer is <>;
      with function ">"(A, B: Size_Type) return Boolean is <>;
      Zero : Size_Type := Size_Type'Val(0);
   function Uninitialized_Fill_N(First : Iterators.Iterator;
                                 N : Size_Type;
                                 X : Value_Type)
                                 return Iterators.Iterator;
   pragma Inline(Uninitialized_Fill_N);


   -- I/O Operations
   package Size_Type_IO is new Ada.Text_IO.Integer_IO(Size_Type);
   procedure Put(Item  : in Size_Type;
                 Width : in Ada.Text_IO.Field := Size_Type_IO.Default_Width;
                 Base  : in Ada.Text_IO.Number_Base :=
                   Size_Type_IO.Default_Base)
     renames Size_Type_IO.Put;

   package Difference_Type_IO is new Ada.Text_IO.Integer_IO(Difference_Type);
   procedure Put(Item  : in Difference_Type;
                 Width : in Ada.Text_IO.Field :=
                   Difference_Type_IO.Default_Width;
                 Base  : in Ada.Text_IO.Number_Base :=
                   Difference_Type_IO.Default_Base)
     renames Difference_Type_IO.Put;

end SGL.Default_Allocators;
