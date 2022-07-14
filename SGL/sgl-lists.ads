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
--
--  $Id: sgl-lists.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with Ada.Text_IO;
with Ada.Finalization;

with SGL.Default_Allocators;
with SGL.Private_Stubs;
with SGL.Controlled_Stubs;
with SGL.Input_Iterators;
with SGL.Integer_Operations;
with SGL.Iterator_Tags;

generic
   type T is limited private;
   with function "="(Left, Right: in T) return Boolean is <>;
   with procedure Assign(To: in out T; From: in T) is <>;

   with procedure Initialize(X: in out T) is <>;
   with procedure Adjust(X: in out T) is <>;
   with procedure Finalize(X: in out T) is <>;

package SGL.Lists is
   type List is new Ada.Finalization.Controlled with private;

   subtype Iterator_Category is SGL.Iterator_Tags.Bidirectional_Iterator_Tag;
   function Verify_Tag(T: Iterator_Category) return Iterator_Category
     renames SGL.Iterator_Tags.Identity;

   type List_Pointer is access all List;
   type List_Constant_Pointer is access constant List;

   type Iterator is private;
   type Constant_Iterator is private;

   package Value_Allocators is new SGL.Default_Allocators(T);
   subtype Value_Type is Value_Allocators.Value_Type;
   subtype Pointer is Value_Allocators.Pointer;
   subtype Constant_Pointer is Value_Allocators.Constant_Pointer;

   subtype Size_Type is Value_Allocators.Size_Type;
   subtype Difference_Type is Value_Allocators.Difference_Type;

   -- Export Size_Type operations

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

   -- Export Difference_Type operations

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

   -- Iterator operations

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

   function "=" (I, J : in Iterator) return Boolean;
   function "=" (I, J : in Constant_Iterator) return Boolean;
   pragma Inline ("=");

   function Val(I: in Iterator) return Value_Type;
   function Val(I: in Constant_Iterator) return Value_Type;
   pragma Inline (Val);

   procedure Assign(I: in out Iterator; V: in Value_Type);
   pragma Inline (Assign);

   function Ref(I: in Iterator) return Pointer;
   function Ref(I: in Constant_Iterator) return Constant_Pointer;
   pragma Inline (Ref);

   function Make_Constant(I: in Iterator) return Constant_Iterator;
   pragma Inline(Make_Constant);

   -- List operations

   function Empty(L: in List) return Boolean;
   pragma Inline(Empty);

   function Size(L: in List) return Size_Type;
   pragma Inline(Size);

   function Max_Size(L: in List) return Size_Type;
   pragma Inline(Max_Size);

   procedure Swap(L1, L2: in out List);
   pragma Inline(Swap);

   function "="(L1, L2: in List) return Boolean;
   pragma Inline("=");

   function Front(L: in List) return Value_Type;
   pragma Inline (Front);

   function Back(L: in List) return Value_Type;
   pragma Inline (Back);

   -- insert/erase

   procedure Erase(L : in out List; Position : in Iterator);
   procedure Erase(L : in out List; First, Last : in Iterator);
   pragma Inline(Erase);

   procedure Insert(L: in out List; Position : in Iterator;
                                   X: in Value_Type;
                                   I: out Iterator);
   procedure Insert(L: in out List; Position: in Iterator;
                                    N: in Size_Type;
                                    X: in Value_Type);

   generic
      with package Other_Iterators is new SGL.Input_Iterators(<>);
      with function Val(X: Other_Iterators.Iterator)
                        return Value_Type;
   procedure Insert_Range(L: in out List;
                          Position: in Iterator;
                          First, Last : in Other_Iterators.Iterator);
   pragma Inline(Insert_Range);

   procedure Push_Back(L: in out List; X: in Value_Type);
   pragma Inline(Push_Back);

   procedure Pop_Back(L: in out List);
   pragma Inline(Pop_Back);

   procedure Push_Front(L: in out List; X: in Value_Type);
   pragma Inline(Push_Front);

   procedure Pop_Front(L: in out List);
   pragma Inline(Pop_Front);

   function Start(L: in List) return Constant_Iterator;
   function Start(L: in List_Pointer) return Iterator;
   pragma Inline(Start);

   function Finish(L: in List) return Constant_Iterator;
   function Finish(L: in List_Pointer) return Iterator;
   pragma Inline(Finish);

   procedure Splice(L: in out List; Position: in Iterator; X: in out List);
   procedure Splice(L: in out List; Position: in Iterator;
                                    X: in out List;
                                    I: in Iterator);
   procedure Splice(L: in out List; Position: in Iterator;
                                    X: in out List;
                                    First, Last : in Iterator);
   pragma Inline(Splice);

   procedure Remove(L: in out List; Value: Value_Type);
   pragma Inline(Remove);

   procedure Unique(L: in out List);
   pragma Inline(Unique);

   procedure Invert(L: in out List);
   pragma Inline(Invert);

   -- Optional sequence operations

   generic
      with function"<"(A, B: Value_Type) return Boolean is <>;
   package Sequence_Operations is

      procedure Merge(L1: in out List; L2: in out List);
      pragma Inline(Merge);

      procedure Sort(L: in out List);
      pragma Inline(Sort);

      function "<"(L1, L2: in List) return Boolean;
      pragma Inline("<");

      function ">"(L1, L2: in List) return Boolean;
      pragma Inline(">");

      function "<="(L1, L2: in List) return Boolean;
      pragma Inline("<=");

      function ">="(L1, L2: in List) return Boolean;
      pragma Inline(">=");

   end Sequence_Operations;

   type List_Node_Buffer is private;

   procedure Initialize(L: in out List);
   procedure Adjust(L: in out List);
   procedure Finalize(L: in out List);

   --
   -- private
   --

private

   type List_Node is
      record
         Next : Value_Allocators.Void_Pointer;
         Prev : Value_Allocators.Void_Pointer;
         Data : aliased Value_Type;
      end record;

   procedure Assign(To: in out List_Node; From: in List_Node);
   pragma InLine(Assign);

   package List_Node_Controlled_Stubs is new SGL.Controlled_Stubs(List_Node);
   use List_Node_Controlled_Stubs;

   package List_Node_Allocators is new SGL.Default_Allocators
     (List_Node, Assign);

   subtype Link_Type is List_Node_Allocators.Pointer;
   subtype Constant_Link_Type is List_Node_Allocators.Constant_Pointer;

   type Iterator is
      record
         Node : Link_Type := null;
      end record;

   type Constant_Iterator is
      record
         Node : Constant_Link_Type := null;
      end record;

   type List is new Ada.Finalization.Controlled with
      record
         Node    : Link_Type := null;
         Length  : Size_Type := 0;
      end record;

   type List_Node_Buffer is
      record
         Next_Buffer : Value_Allocators.Void_Pointer;
         Buffer      : Link_Type;
      end record;

   package List_Node_Buffer_Controlled_Stubs is
     new SGL.Controlled_Stubs(List_Node_Buffer);
   use List_Node_Buffer_Controlled_Stubs;

   package List_Node_Buffer_Private_Stubs is
      new SGL.Private_Stubs(List_Node_Buffer);

   package Buffer_Allocators is new SGL.Default_Allocators
     (List_Node_Buffer, List_Node_Buffer_Private_Stubs.Assign);

   subtype Buffer_Pointer is Buffer_Allocators.Pointer;

   -- Link_Type helper operations

   function Make_Iterator(X: in Link_Type) return Iterator;
   pragma Inline(Make_Iterator);

   function Make_Iterator(X: in Constant_Link_Type) return Constant_Iterator;
   pragma Inline(Make_Iterator);


end SGL.Lists;
