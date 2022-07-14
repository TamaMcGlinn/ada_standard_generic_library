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

with SGL.Pairs;
with SGL.Function_Adaptors;

with SGL.Trees;

generic
   type Key_T is limited private;
   with function"<"(A, B: Key_T) return Boolean;
   with procedure Assign(To: in out Key_T; From: in Key_T) is <>;

   with procedure Initialize(X: in out Key_T) is <>;
   with procedure Finalize(X: in out Key_T) is <>;

package SGL.Sets is

   type Set is new Ada.Finalization.Controlled with private;

   type Set_Pointer is access all Set;
   type Set_Constant_Pointer is access constant Set;

   function Identity is new SGL.Function_Adaptors.Identity(Key_T);
   pragma Inline(Identity);

   package Rep_Type is new SGL.Trees(Key_T, "<", Key_T, Assign, Identity);

   subtype Value_Type is Rep_Type.Value_Type;
   subtype Key_Type is Rep_Type.Value_Type;
   subtype Pointer is Rep_Type.Constant_Pointer;
   subtype Constant_Pointer is Rep_Type.Constant_Pointer;
   subtype Constant_Iterator is Rep_Type.Constant_Iterator;
   subtype Iterator is Constant_Iterator;
   subtype Size_Type is Rep_Type.Size_Type;
   subtype Difference_Type is Rep_Type.Difference_Type;

   subtype Iterator_Category is Rep_Type.Iterator_Category;
   function Verify_Tag(T: Iterator_Category) return Iterator_Category
     renames Rep_Type.Verify_Tag;

   -- accessors

   function Start(S: in Set_Pointer) return Iterator;
   function Start(S: in Set) return Constant_Iterator;
   pragma Inline(Start);

   function Finish(S: in Set_Pointer) return Iterator;
   function Finish(S: in Set) return Constant_Iterator;
   pragma Inline(Finish);

   function Empty(S: in Set) return Boolean;
   pragma Inline(Empty);

   function Size(S: in Set) return Size_Type;
   pragma Inline(Size);

   function Max_Size(S: in Set) return Size_Type;
   pragma Inline(Max_Size);

   function Value(S: in Set; K: Key_Type) return Value_Type;
   pragma Inline(Value);

   -- modifiers

   procedure Swap(S1, S2: in out Set);
   pragma Inline(Swap);

   -- insert/erase

   procedure Insert(S: in out Set; X: in Value_Type;
                                   I: out Constant_Iterator;
                                   Success : out Boolean);

   procedure Insert(S: in out Set; Position: in Constant_Iterator;
                                   X: in Value_Type;
                                   I: out Constant_Iterator);
   procedure Insert(S: in out Set; First, Last : in Constant_Pointer);
   pragma Inline(Insert);


   procedure Erase(S: in out Set; Position : in Constant_Iterator);
   procedure Erase(S: in out Set; K : in Key_Type; SZ : out Size_Type);
   procedure Erase(S: in out Set; First, Last : in Constant_Iterator);
   pragma Inline(Erase);

   -- Set operations

   function "="(S1, S2: in Set) return Boolean;
   pragma Inline("=");

   function "<"(S1, S2: in Set) return Boolean;
   pragma Inline("<");

   function Find(S: in Set; K : in Key_Type) return Constant_Iterator;
   pragma Inline(Find);

   function Count(S: in Set; K : in Key_Type) return Size_Type;
   pragma Inline(Count);

   function Lower_Bound(S: in Set; K : in Key_Type) return Constant_Iterator;
   pragma Inline(Lower_Bound);

   function Upper_Bound(S: in Set; K : in Key_Type) return Constant_Iterator;
   pragma Inline(Upper_Bound);

   package Pairs_CIterator_CIterator is new SGL.Pairs
     (Constant_Iterator, Constant_Iterator, Rep_Type."=", Rep_Type."=");

   function Equal_Range(S: in Set; X : in Key_Type)
                        return Pairs_CIterator_CIterator.Pair;
   pragma Inline(Equal_Range);


   -- Export distance operations

   package Size_Type_Operations renames Rep_Type.Size_Type_Operations;
   package Difference_Type_Operations
     renames Rep_Type.Difference_Type_Operations;
   package Distance_Type_Operations renames Rep_Type.Distance_Type_Operations;

   -- export iterator functions

   procedure Inc(I: in out Constant_Iterator)
     renames Rep_Type.Inc;
   function Next(I: in Constant_Iterator) return Constant_Iterator
     renames Rep_Type.Next;
   procedure Dec(I: in out Constant_Iterator)
     renames Rep_Type.Dec;
   function Prev(I: in Constant_Iterator) return Constant_Iterator
     renames Rep_Type.Prev;
   function "=" (I, J: Constant_Iterator) return Boolean
   renames Rep_Type."=";
   function Val(I: in Constant_Iterator) return Value_Type
     renames Rep_Type.Val;
   function Ref(I: in Constant_Iterator) return Constant_Pointer
     renames Rep_Type.Ref;


   --
   --  Private part
   --

private

   procedure Initialize(S: in out Set);

   type Set is new Ada.Finalization.Controlled with
      record
         T : Rep_Type.Tree;
      end record;

end SGL.Sets;
