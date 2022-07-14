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

with System;
with System.Storage_Pools;
with Unchecked_Conversion;

with SGL.Basic_Algorithms;

package body SGL.Default_Allocators is
   use System;
   use System.Storage_Elements;

   -- Assumption : 'Access really returns an address
   function To_Address is new Unchecked_Conversion(Pointer, Address);
   function To_Address is new Unchecked_Conversion(Constant_Pointer, Address);
   -- To_Pointer Void_Pointer covers the one below
   --  function To_Pointer is new Unchecked_Conversion(Address, Pointer);

   -- Size_Type and Difference_Type are defined as new types to force
   -- other packages to use the exported procedures.  Internally we
   -- need to use the operations and conversions provided by System
   -- and System.Storage_Elements
   -- XXX sjw: I don't see how this _forces_ other packages to use the
   -- exported procedures!
   function To_Storage_Count is new
     Unchecked_Conversion(Size_Type, System.Storage_Elements.Storage_Count);
   function To_Size_Type is new
     Unchecked_Conversion(System.Storage_Elements.Storage_Count, Size_Type);
   function To_Difference_Type is new Unchecked_Conversion
     (System.Storage_Elements.Storage_Offset, Difference_Type);
   function To_Storage_Offset is new Unchecked_Conversion
     (Difference_Type, System.Storage_Elements.Storage_Offset);

   function Max is new SGL.Basic_Algorithms.Generic_Max(Size_Type, "<");

   Default_Page_Size : constant Size_Type := 4096;

   function Allocate(Size : in Size_Type) return Pointer is
      A : Address;
      function Malloc (Size : in Storage_Elements.Storage_Count)
                       return System.Address;
      pragma Import (C, malloc, "malloc");
   begin
      --      A := System.Task_Memory.Unsafe_Low_Level_New
      --        (To_Storage_Count(Size * Value_Type_Size));
      A := malloc(To_Storage_Count(Size * Value_Type_Size));
      if (A = To_Address(0)) then
         raise Storage_Error;
      end if;
      return To_Pointer(A);
   end Allocate;

   procedure Deallocate(P : in Pointer) is
      procedure free (Addr : System.Address);
      pragma Import (C, free, "free");

   begin
      --System.Task_Memory.Low_Level_Free(To_Address(P));
      Free(To_Address(P));
   end Deallocate;

   procedure Construct(P : in Pointer; A : in Value_Type) is
   begin
      Assign(P.all, A);
   end Construct;

   procedure Destroy(P: in Pointer) is
   begin
      Finalize(P.all);
   end Destroy;

   function Init_Page_Size return Size_Type is
   begin
      return Max(1, Default_Page_Size/Value_Type_Size);
   end Init_Page_Size;

   function Max_Size return Size_Type is
      Last : System.Storage_Elements.Storage_Count :=
        To_Storage_Offset(Difference_Type'Last);
   begin
      return Max(1, To_Size_Type(Last)/Value_Type_Size);
   end Max_Size;

   function To_Size_Type(X: Difference_Type) return Size_Type is
      Y : System.Storage_Elements.Storage_Count := To_Storage_Offset(X);
   begin
      return(To_Size_Type(Y));
   end To_Size_Type;

   function To_Difference_Type(X: Size_Type) return Difference_Type is
      Y : System.Storage_Elements.Storage_Offset := To_Storage_Count(X);
   begin
      return(To_Difference_Type(Y));
   end To_Difference_Type;

   -- Address operations

   function "+" (Left : Pointer; Right : Difference_Type) return Pointer is
   begin
      return To_Pointer(To_Address(Left) + (Right * Value_Type_Size));
   end "+";

   function "+" (Left : Constant_Pointer; Right : Difference_Type)
                 return Constant_Pointer is
   begin
      return To_Constant_Pointer(To_Address(Left) + (Right * Value_Type_Size));
   end "+";

   function "+" (Left : Difference_Type; Right : Pointer) return Pointer is
   begin
      return To_Pointer((Left * Value_Type_Size) + To_Address(Right));
   end "+";

   function "+" (Left : Difference_Type; Right : Constant_Pointer) return Constant_Pointer is
   begin
      return To_Constant_Pointer((Left * Value_Type_Size) + To_Address(Right));
   end "+";

   function "-" (Left : Pointer; Right : Difference_Type) return Pointer is
   begin
      return To_Pointer(To_Address(Left) - (Right * Value_Type_Size));
   end "-";

   function "-" (Left : Constant_Pointer; Right : Difference_Type) return Constant_Pointer is
   begin
      return To_Constant_Pointer(To_Address(Left) - (Right * Value_Type_Size));
   end "-";

   function "-" (Left, Right : Pointer) return Difference_Type is
   begin
      return (To_Address(Left) - To_Address(Right)) / Value_Type_Size;
   end "-";

   function "-" (Left, Right : Constant_Pointer) return Difference_Type is
   begin
      return (To_Address(Left) - To_Address(Right)) / Value_Type_Size;
   end "-";

   function "<" (Left, Right : Pointer) return Boolean is
   begin
      return To_Address(Left) < To_Address(Right);
   end "<";

   function "<" (Left, Right : Constant_Pointer) return Boolean is
   begin
      return To_Address(Left) < To_Address(Right);
   end "<";

   function ">" (Left, Right : Pointer) return Boolean is
   begin
      return To_Address(Left) > To_Address(Right);
   end ">";

   function ">" (Left, Right : Constant_Pointer) return Boolean is
   begin
      return To_Address(Left) > To_Address(Right);
   end ">";

   function "<=" (Left, Right : Pointer) return Boolean is
   begin
      return To_Address(Left) <= To_Address(Right);
   end "<=";
   function "<=" (Left, Right : Constant_Pointer) return Boolean is
   begin
      return To_Address(Left) <= To_Address(Right);
   end "<=";

   function ">=" (Left, Right : Pointer) return Boolean is
   begin
      return To_Address(Left) >= To_Address(Right);
   end ">=";

   function ">=" (Left, Right : Constant_Pointer) return Boolean is
   begin
      return To_Address(Left) >= To_Address(Right);
   end ">=";

   function Is_Null(P : Pointer) return Boolean is
   begin
     return P = null;
   end Is_Null;

   function Is_Null(P : Constant_Pointer) return Boolean is
   begin
     return P = null;
   end Is_Null;

   -- Mixed Size_Type/Difference_Type functions exported

   function "+"(A: Size_Type; B: Difference_Type) return Difference_Type is
   begin
      return(To_Difference_Type(A) + B);
   end "+";

   function "+"(A: Difference_Type; B: Size_Type) return Difference_Type is
   begin
      return(A + To_Difference_Type(B));
   end "+";

   function "-"(A: Size_Type; B: Difference_Type) return Difference_Type is
   begin
      return(To_Difference_Type(A) - B);
   end "-";

   function "-"(A: Difference_Type; B: Size_Type) return Difference_Type is
   begin
      return(A - To_Difference_Type(B));
   end "-";

   function "*"(A: Size_Type; B: Difference_Type) return Difference_Type is
   begin
      return(To_Difference_Type(A) * B);
   end "*";

   function "*"(A: Difference_Type; B: Size_Type) return Difference_Type is
   begin
      return(A * To_Difference_Type(B));
   end "*";

   function "/"(A: Size_Type; B: Difference_Type) return Difference_Type is
   begin
      return(To_Difference_Type(A) / B);
   end "/";

   function "/"(A: Difference_Type; B: Size_Type) return Difference_Type is
   begin
      return(A / To_Difference_Type(B));
   end "/";

   function "<"(A: Size_Type; B: Difference_Type) return Boolean is
   begin
      return(To_Difference_Type(A) < B);
   end "<";

   function "<"(A: Difference_Type; B: Size_Type) return Boolean is
   begin
      return(A < To_Difference_Type(B));
   end "<";

   function ">"(A: Size_Type; B: Difference_Type) return Boolean is
   begin
      return(To_Difference_Type(A) > B);
   end ">";

   function ">"(A: Difference_Type; B: Size_Type) return Boolean is
   begin
      return(A > To_Difference_Type(B));
   end ">";

   function ">="(A: Size_Type; B: Difference_Type) return Boolean is
   begin
      return(To_Difference_Type(A) >= B);
   end ">=";

   function ">="(A: Difference_Type; B: Size_Type) return Boolean is
   begin
      return(A >= To_Difference_Type(B));
   end ">=";

   function "<="(A: Size_Type; B: Difference_Type) return Boolean is
   begin
      return(To_Difference_Type(A) <= B);
   end "<=";

   function "<="(A: Difference_Type; B: Size_Type) return Boolean is
   begin
      return(A <= To_Difference_Type(B));
   end "<=";

   -- Conversion Functions

   function Make_Constant(P : in Pointer) return Constant_Pointer is
   begin
      return To_Constant_Pointer(P);
   end Make_Constant;

   -- Operations (from STL algobase)

   procedure Destroy_Sequence(First, Last : Iterators.Iterator) is
      use Iterators;
      Cur : Iterator := First;
   begin
      while (Cur /= Last) loop
         Destroy(Ref(Cur));
         Inc(Cur);
      end loop;
   end Destroy_Sequence;

   function Uninitialized_Copy(First, Last: Input_Iterators.Iterator;
                               Result: Forward_Iterators.Iterator)
                               return Forward_Iterators.Iterator is
      Cur : Input_Iterators.Iterator := First;
      Res : Forward_Iterators.Iterator := Result;
   begin
      while (Input_Iterators."/="(Cur, Last)) loop
         Construct(Ref(Res), Val(Cur));
         Forward_Iterators.Inc(Res);
         Input_Iterators.Inc(Cur);
      end loop;

      return Res;
   end Uninitialized_Copy;

   procedure Uninitialized_Fill(First, Last : Iterators.Iterator;
                                X : Value_Type) is
      Cur : Iterators.Iterator := First;
      use Iterators;
   begin
      while (Cur /= Last) loop
         Construct(To_Allocator_Pointer(Ref(Cur)), X);
         Inc(Cur);
      end loop;
   end Uninitialized_Fill;

   function Uninitialized_Fill_N(First : Iterators.Iterator;
                                 N : Size_Type;
                                 X : Value_Type)
                                 return Iterators.Iterator is
      Count : Size_Type := N;
      use Iterators;
      Cur : Iterator := First;
   begin
      while (Count > Zero) loop
         Count := Size_Type'Pred(Count);
         Construct(Ref(Cur), X);
         Inc(Cur);
      end loop;

      return Cur;
   end Uninitialized_Fill_N;

end SGL.Default_Allocators;
