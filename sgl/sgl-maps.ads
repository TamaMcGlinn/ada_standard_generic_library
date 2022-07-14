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

with SGL.Controlled_Stubs;
with SGL.Pairs;
with SGL.Special_Pairs.Extension;

with SGL.Trees;

generic
   type Key_T is limited private;
   with function"<"(A, B: Key_T) return Boolean;
   with procedure Assign(To: in out Key_T; From: in Key_T) is <>;

   type Data_T is limited private;
   with function "="(Left, Right: in Data_T) return Boolean is <>;
   with procedure Assign(To: in out Data_T; From: in Data_T) is <>;

   with procedure Initialize(X: in out Key_T) is <>;
   with procedure Finalize(X: in out Key_T) is <>;

   with procedure Initialize(X: in out Data_T) is <>;
   with procedure Finalize(X: in out Data_T) is <>;

package SGL.Maps is

   type Map is new Ada.Finalization.Controlled with private;

   type Map_Pointer is access all Map;
   type Map_Constant_Pointer is access constant Map;

   -- Defining our own pair since "Pairs" requires that the types have
   -- equality defined, and Ada does not allow for constant record members.

   package Map_Pairs is new SGL.Special_Pairs(Key_T, "<", Assign,
                                              Data_T, "=", Assign);

   -- Following is used for assigning to Pair_Type or initializing Key field;
   -- it should _not_ be used by clients, since Key field shouldn't be changed
   package Map_Pairs_Extension is new Map_Pairs.Extension;

   -- Pair_Type renamings

   subtype Pair_Type is Map_Pairs.Pair_Type;
   function First(P: in Pair_Type) return Key_T
     renames Map_Pairs.First;
   function Second(P: in Pair_Type) return Data_T
     renames Map_Pairs.Second;
   procedure Set_Second(P: in out Pair_Type; V: in Data_T)
     renames Map_Pairs.Set_Second;

   function Select1st(P : in Pair_Type) return Key_T;
   pragma Inline(Select1st);

   package Map_Pairs_Controlled is new SGL.Controlled_Stubs
     (Map_Pairs.Pair_Type);

   package Rep_Type is new SGL.Trees
     (Key_T, "<", Pair_Type, Map_Pairs_Extension.Assign, Select1st,
      Initialize, Finalize,
      Map_Pairs_Controlled.Initialize, Map_Pairs_Controlled.Finalize);

   subtype Iterator_Category is Rep_Type.Iterator_Category;
   function Verify_Tag(T: Iterator_Category) return Iterator_Category
     renames Rep_Type.Verify_Tag;

   subtype Key_Type is Rep_Type.Key_Type;
   subtype Value_Type is Rep_Type.Value_Type;
   subtype Pointer is Rep_Type.Pointer;
   subtype Constant_Pointer is Rep_Type.Constant_Pointer;
   subtype Iterator is Rep_Type.Iterator;
   subtype Constant_Iterator is Rep_Type.Constant_Iterator;
   subtype Size_Type is Rep_Type.Size_Type;
   subtype Difference_Type is Rep_Type.Difference_Type;

   package Size_Type_Operations renames Rep_Type.Size_Type_Operations;
   package Difference_Type_Operations
     renames Rep_Type.Difference_Type_Operations;
   package Distance_Type_Operations renames Rep_Type.Distance_Type_Operations;

   -- accessors

   function Ref_Second(P: in Pointer) return Map_Pairs.Data_Pointer;
   pragma Inline(Ref_Second);

   function Start(M: in Map_Pointer) return Iterator;
   function Start(M: in Map) return Constant_Iterator;
   pragma Inline(Start);

   function Finish(M: in Map_Pointer) return Iterator;
   function Finish(M: in Map) return Constant_Iterator;
   pragma Inline(Finish);

   function Empty(M: in Map) return Boolean;
   pragma Inline(Empty);

   function Size(M: in Map) return Size_Type;
   pragma Inline(Size);

   function Max_Size(M: in Map) return Size_Type;
   pragma Inline(Max_Size);

   function Value(M: in Map; K: Key_Type) return Data_T;
   pragma Inline(Value);

   -- modifiers

   procedure Assign(M: in out Map; K: in Key_Type; E: in Data_T);
   pragma Inline(Assign);

   procedure Swap(M1, M2: in out Map);
   pragma Inline(Swap);

   -- insert/erase

   procedure Insert(M: in out Map; X: in Value_Type;
                                   I: out Iterator;
                                   Success : out Boolean);

   procedure Insert(M: in out Map; Position: in Iterator;
                                   X: in Value_Type;
                                   I: out Iterator);
   procedure Insert(M: in out Map; First, Last : in Constant_Pointer);
   pragma Inline(Insert);


   procedure Erase(M: in out Map; Position : in Iterator);
   procedure Erase(M: in out Map; K : in Key_Type; S : out Size_Type);
   procedure Erase(M: in out Map; First, Last : in Iterator);
   pragma Inline(Erase);

   -- map operations

   function "="(M1, M2: in Map) return Boolean;
   pragma Inline("=");

   function "<"(M1, M2: in Map) return Boolean;
   pragma Inline("<");

   function Find(M: in Map_Pointer; K : in Key_Type) return Iterator;
   function Find(M: in Map; K : in Key_Type) return Constant_Iterator;
   pragma Inline(Find);

   function Count(M: in Map; K : in Key_Type) return Size_Type;
   pragma Inline(Count);

   function Lower_Bound(M: in Map_Pointer; K : in Key_Type) return Iterator;
   function Lower_Bound(M: in Map; K : in Key_Type) return Constant_Iterator;
   pragma Inline(Lower_Bound);

   function Upper_Bound(M: in Map_Pointer; K : in Key_Type) return Iterator;
   function Upper_Bound(M: in Map; K : in Key_Type) return Constant_Iterator;
   pragma Inline(Upper_Bound);


   package Pairs_CIterator_CIterator is new SGL.Pairs
     (Constant_Iterator, Constant_Iterator, Rep_Type."=", Rep_Type."=");

   function Equal_Range(M: in Map; X : in Key_Type)
                        return Pairs_CIterator_CIterator.Pair;
   pragma Inline(Equal_Range);


   -- export iterator functions

   procedure Inc(I: in out Iterator) renames Rep_Type.Inc;
   procedure Inc(I: in out Constant_Iterator) renames Rep_Type.Inc;
   function Next(I: in Iterator) return Iterator renames Rep_Type.Next;
   function Next(I: in Constant_Iterator) return Constant_Iterator
     renames Rep_Type.Next;
   procedure Dec(I: in out Iterator) renames Rep_Type.Dec;
   procedure Dec(I: in out Constant_Iterator) renames Rep_Type.Dec;
   function Prev(I: in Iterator) return Iterator renames Rep_Type.Prev;
   function Prev(I: in Constant_Iterator) return Constant_Iterator
     renames Rep_Type.Prev;
   function "=" (I, J: in Iterator) return Boolean renames Rep_Type."=";
   function "=" (I, J: in Constant_Iterator) return Boolean
     renames Rep_Type."=";
   function Val(I: in Iterator) return Value_Type renames Rep_Type.Val;
   function Val(I: in Constant_Iterator) return Value_Type
     renames Rep_Type.Val;
   function Ref(I: in Iterator) return Pointer renames Rep_Type.Ref;
   function Ref(I: in Constant_Iterator) return Constant_Pointer
     renames Rep_Type.Ref;
   procedure Assign(I: in out Iterator;
                    V: in Value_Type) renames Rep_Type.Assign;
   function Make_Constant(I: in Iterator) return Constant_Iterator
     renames Rep_Type.Make_Constant;

   --
   --  Private part
   --

private

   procedure Initialize(M: in out Map);

   type Map is new Ada.Finalization.Controlled with
      record
         T : aliased Rep_Type.Tree;
      end record;

end SGL.Maps;
