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
with Ada.Finalization;

with SGL.Default_Allocators;
with SGL.Controlled_Stubs;
with SGL.Integer_Operations;
with SGL.Iterator_Tags;
with SGL.Input_Iterators;

generic
   type T is limited private;
   with function "="(Left, Right: in T) return Boolean is <>;
   with procedure Assign(To: in out T; From: in T) is <>;
   with procedure Initialize(X: in out T) is <>;
   with procedure Finalize(X: in out T) is <>;

package SGL.Vectors is
   type Vector is new Ada.Finalization.Controlled with private;

   subtype Iterator_Category is SGL.Iterator_Tags.Random_Access_Iterator_Tag;
   function Verify_Tag(T: Iterator_Category) return Iterator_Category
     renames SGL.Iterator_Tags.Identity;

   type Vector_Pointer is access all Vector;
   type Vector_Constant_Pointer is access constant Vector;
   type Iterator is private;
   type Constant_Iterator is private;

   package Value_Allocators is new SGL.Default_Allocators(T);
   subtype Value_Type is Value_Allocators.Value_Type;
   subtype Pointer is Value_Allocators.Pointer;
   subtype Constant_Pointer is Value_Allocators.Constant_Pointer;
   subtype Size_Type is Value_Allocators.Size_Type;
   subtype Difference_Type is Value_Allocators.Difference_Type;
   subtype Distance_Type is Difference_Type;

   -- Size_Type functions exported

   package Size_Type_Operations is new SGL.Integer_Operations
     (Size_Type,
      Value_Allocators."=",
      Value_Allocators."<",
      Value_Allocators.">",
      Value_Allocators."<=",
      Value_Allocators.">=",
      Value_Allocators."-",
      Value_Allocators."+",
      Value_Allocators."*",
      Value_Allocators."/",
      Value_Allocators.Put);

   -- Difference_Type functions exported
   package Difference_Type_Operations is new SGL.Integer_Operations
     (Difference_Type,
      Value_Allocators."=",
      Value_Allocators."<",
      Value_Allocators.">",
      Value_Allocators."<=",
      Value_Allocators.">=",
      Value_Allocators."-",
      Value_Allocators."+",
      Value_Allocators."*",
      Value_Allocators."/",
      Value_Allocators.Put);

   package Distance_Type_Operations renames Difference_Type_Operations;

   -- Iterator functions

   procedure Inc(I: in out Iterator);
   procedure Inc(I: in out Constant_Iterator);
   pragma Inline (Inc);

   function Next(I: in Iterator) return Iterator;
   function Next(I: in Constant_Iterator) return Constant_Iterator;
   pragma Inline (Next);

   procedure Dec(I: in out Iterator);
   procedure Dec(I: in out Constant_Iterator);
   pragma Inline (Dec);

   function Prev(I: in Iterator) return Iterator;
   function Prev(I: in Constant_Iterator) return Constant_Iterator;
   pragma Inline (Prev);

   procedure IncBy(I: in out Iterator; K : Difference_Type);
   procedure IncBy(I: in out Constant_Iterator; K : Difference_Type);
   pragma Inline (IncBy);

   procedure DecBy(I: in out Iterator; K : Difference_Type);
   procedure DecBy(I: in out Constant_Iterator; K : Difference_Type);
   pragma Inline (DecBy);

   function "=" (I, J: in Iterator) return Boolean;
   function "=" (I, J: in Constant_Iterator) return Boolean;
   pragma Inline ("=");

   function "+" (I: in Iterator; K : Difference_Type) return Iterator;
   function "+" (I: in Constant_Iterator; K : Difference_Type)
                 return Constant_Iterator;
   function "+" (K : Difference_Type; I: in Iterator) return Iterator;
   function "+" (K : Difference_Type; I: in Constant_Iterator)
                 return Constant_Iterator;
   pragma Inline ("+");

   function "-" (I, J: in Iterator) return Difference_Type;
   function "-" (I, J: in Constant_Iterator) return Difference_Type;
   function "-" (I: in Iterator;
                 J: in Constant_Iterator) return Difference_Type;
   function "-" (I: in Constant_Iterator;
                 J: in Iterator) return Difference_Type;
   function "-" (I: in Iterator; K: Difference_Type) return Iterator;
   function "-" (I: in Constant_Iterator; K: Difference_Type)
                 return Constant_Iterator;
   pragma Inline ("-");

   function "<" (I, J: in Iterator) return Boolean;
   function "<" (I, J: in Constant_Iterator) return Boolean;
   pragma Inline ("<");

   function ">" (I, J: in Iterator) return Boolean;
   function ">" (I, J: in Constant_Iterator) return Boolean;
   pragma Inline (">");

   function "<=" (I, J: in Iterator) return Boolean;
   function "<=" (I, J: in Constant_Iterator) return Boolean;
   pragma Inline ("<=");

   function ">=" (I, J: in Iterator) return Boolean;
   function ">=" (I, J: in Constant_Iterator) return Boolean;
   pragma Inline (">=");

   function Val(I: in Iterator) return Value_Type;
   function Val(I: in Constant_Iterator) return Value_Type;
   pragma Inline (Val);

   procedure Assign(I: in out Iterator; V: Value_Type);
   pragma Inline (Assign);

   function Ref(I: in Iterator) return Pointer;
   function Ref(I: in Constant_Iterator) return Constant_Pointer;
   pragma Inline (Ref);

   function Make_Constant(I: in Iterator) return Constant_Iterator;
   pragma Inline (Make_Constant);

   -- accessors

   function Start(V: in Vector_Pointer) return Iterator;
   function Start(V: in Vector) return Constant_Iterator;
   pragma Inline (Start);

   function Finish(V: in Vector_Pointer) return Iterator;
   function Finish(V: in Vector) return Constant_Iterator;
   pragma Inline (Finish);

   function Value(V: in Vector; N: in Size_Type) return Value_Type;
   pragma Inline (Value);

   function Empty(V: in Vector) return Boolean;
   pragma Inline (Empty);

   function Size(V: in Vector) return Size_Type;
   pragma Inline (Size);

   function Max_Size(V: in Vector) return Size_Type;
   pragma Inline (Max_Size);

   function Capacity(V: in Vector) return Size_Type;
   pragma Inline (Capacity);

   function "="(V1, V2: in Vector) return Boolean;
   pragma Inline ("=");

   function Front(V: in Vector) return Value_Type;
   pragma Inline (Front);

   function Back(V: in Vector) return Value_Type;
   pragma Inline (Back);

   -- insert/erase

   procedure Push_Back(V: in out Vector; E: in Value_Type);
   pragma Inline (Push_Back);

   procedure Pop_Back(V: in out Vector);
   pragma Inline (Pop_Back);

   procedure Assign(V: in out Vector; N: in Size_Type; E: in Value_Type);
   pragma Inline (Assign);


   procedure Erase(V : in out Vector; Position : in Iterator);
   procedure Erase(V : in out Vector; First, Last : in Iterator);
   pragma Inline (Erase);

   procedure Insert(V: in out Vector;
                   Position: in Iterator;
                   X: in Value_Type;
                   NewPos: out Iterator);
   procedure Insert(V: in out Vector;
                    Position : in Iterator;
                    N : Size_Type;
                    X: in Value_Type);
   pragma Inline (Insert);

   generic
      with package Other_Iterators is new SGL.Input_Iterators(<>);
      with procedure Distance(A,B : in Other_Iterators.Iterator;
                              N : in out Difference_Type);
      with function Val(X: Other_Iterators.Iterator)
                        return Value_Type;
      with function "+"(I: in Other_Iterators.Iterator;
                        V: in Difference_Type)
                        return Other_Iterators.Iterator;
   procedure Insert_Range(V: in out Vector;
                          Position: in Iterator;
                          First, Last : in Other_Iterators.Iterator);
   pragma Inline(Insert_Range);

   -- misc operations

   procedure Swap(V1, V2: in out Vector);
   pragma Inline(Swap);

   procedure Reserve(V : in out Vector; N: Size_Type);
   pragma Inline(Reserve);

 -- Optional sequence operations

   generic
      with function"<"(A, B: Value_Type) return Boolean is <>;
   package Sequence_Operations is

      function "<"(V1, V2: in Vector) return Boolean;
      pragma Inline("<");

      function ">"(V1, V2: in Vector) return Boolean;
      pragma Inline(">");

      function "<="(V1, V2: in Vector) return Boolean;
      pragma Inline("<=");

      function ">="(V1, V2: in Vector) return Boolean;
      pragma Inline(">=");

   end Sequence_Operations;

   --
   -- private
   --

private

   -- Controlled type functions
   procedure Initialize(V: in out Vector);
   procedure Adjust(V: in out Vector);
   procedure Finalize(V: in out Vector);

   -- Private functions
   procedure Insert_Aux(V: in out Vector;
                        Position: in Iterator;
                        X: Value_Type);
   pragma Inline(Insert_Aux);

   type Iterator is
      record
         Ptr : Pointer := null;
      end record;

   type Constant_Iterator is
      record
         Ptr : Constant_Pointer := null;
      end record;

   type Vector is new Ada.Finalization.Controlled with
      record
         VStart  : Iterator;
         VFinish : Iterator;
         End_Of_Storage  : Iterator;
      end record;

end SGL.Vectors;
