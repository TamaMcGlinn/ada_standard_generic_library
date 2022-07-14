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
with SGL.Pairs;
with SGL.Integer_Operations;
with SGL.Iterator_Tags;

generic
   type Key_T is limited private;
   with function "<"(A, B: Key_T) return Boolean;

   type Value_T is limited private;
   with procedure Assign(To: in out Value_T; From: in Value_T);
   with function KeyOfValue(A: in Value_T) return Key_T;

   with procedure Initialize(X: in out Key_T) is <>;
   with procedure Finalize(X: in out Key_T) is <>;

   with procedure Initialize(X: in out Value_T) is <>;
   with procedure Finalize(X: in out Value_T) is <>;

package SGL.Trees is
   type Color_Type is ( Red, Black );
   type Tree is new Ada.Finalization.Controlled with private;

   subtype Iterator_Category is SGL.Iterator_Tags.Bidirectional_Iterator_Tag;
   function Verify_Tag(T: Iterator_Category) return Iterator_Category
     renames SGL.Iterator_Tags.Identity;

   type Tree_Pointer is access all Tree;
   type Tree_Constant_Pointer is access constant Tree;

   type Iterator is private;
   type Constant_Iterator is private;

   package Value_Allocators is new SGL.Default_Allocators(Value_T);
   subtype Value_Type is Value_Allocators.Value_Type;
   subtype Pointer is Value_Allocators.Pointer;
   subtype Constant_Pointer is Value_Allocators.Constant_Pointer;

   subtype Key_Type is Key_T;
--   package Key_Allocators is new SGL.Default_Allocators(Key_T);
--   subtype Key_Type is Key_Allocators.Value_Type;
--   subtype Key_Pointer is Key_Allocators.Pointer;
--   subtype Key_Constant_Pointer is Key_Allocators.Constant_Pointer;

   subtype Size_Type is Value_Allocators.Size_Type;
   subtype Difference_Type is Value_Allocators.Difference_Type;
   subtype Distance_Type is Value_Allocators.Difference_Type;

   -- Export the Key_Type Operations

   package Key_Type_Operations is
      function Key_Compare(A, B: Key_T) return Boolean renames "<";
   end Key_Type_Operations;

   -- Export the Value_Type Operations

   package Value_Type_Operations is
      function "="(A, B : Value_Allocators.Value_Type) return Boolean renames
        Value_Allocators."=";
   end Value_Type_Operations;

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

   function "=" (I, J: in Iterator) return Boolean;
   function "=" (I, J: in Constant_Iterator) return Boolean;
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
   pragma Inline (Make_Constant);

   -- Tree operations

   function Empty(T: in Tree) return Boolean;
   pragma Inline(Empty);

   function Size(T: in Tree) return Size_Type;
   pragma Inline(Size);

   function Max_Size(T: in Tree) return Size_Type;
   pragma Inline(Max_Size);

   procedure Swap(T1, T2: in out Tree);
   pragma Inline(Swap);

   function "="(T1, T2: in Tree) return Boolean;
   pragma Inline("=");

   procedure Erase(T: in out Tree; Position : in Iterator);
   procedure Erase(T: in out Tree; K : in Key_Type; S : out Size_Type);
   procedure Erase(T: in out Tree; First_IN, Last : in Iterator);

--   procedure Erase(T: in out Tree; First_IN, Last : in Key_Constant_Pointer);
   pragma Inline(Erase);

   procedure Insert(T: in out Tree; V: in Value_Type;
                                    I: out Iterator;
                                    Success: out Boolean);
   procedure Insert(T: in out Tree; Position_IN : in Iterator;
                                    V: in Value_Type;
                                    I: out Iterator);
   procedure Insert(T: in out Tree; First_IN, Last : in Iterator);
   procedure Insert(T: in out Tree; First_IN, Last : in Constant_Pointer);
   pragma Inline(Insert);

   function Start(T: in Tree) return Constant_Iterator;
   function Start(T: in Tree_Pointer) return Iterator;
   pragma Inline(Start);

   function Finish(T: in Tree) return Constant_Iterator;
   function Finish(T: in Tree_Pointer) return Iterator;
   pragma Inline(Finish);

   procedure Set_Insert_Always(T: in out Tree; B : in Boolean);
   pragma Inline(Set_Insert_Always);

   function Find(T: in Tree; K : in Key_Type) return Constant_Iterator;
   function Find(T: in Tree_Pointer; K : in Key_Type) return Iterator;
   pragma Inline(Find);

   function Count(T: in Tree; K : in Key_Type) return Size_Type;
   pragma Inline(Count);

   function Lower_Bound(T: in Tree; K : in Key_Type) return Constant_Iterator;
   function Lower_Bound(T: in Tree_Pointer; K : in Key_Type) return Iterator;
   pragma Inline(Lower_Bound);

   function Upper_Bound(T: in Tree; K : in Key_Type) return Constant_Iterator;
   function Upper_Bound(T: in Tree_Pointer; K : in Key_Type) return Iterator;
   pragma Inline(Upper_Bound);

   procedure Equal_Range(T: in out Tree;
                         K : in Key_Type;
                         First, Second : out Iterator);
   procedure Equal_Range(T: in Tree;
                         K : in Key_Type;
                         First, Second : out Constant_Iterator);
   pragma Inline(Equal_Range);

   --
   -- private
   --

private

   procedure Initialize(T: in out Tree);
   procedure Adjust(T: in out Tree);
   procedure Finalize(T: in out Tree);

   type Tree_Node is
      record
         Color_Field : Color_Type;
         Parent_Link : Value_Allocators.Void_Pointer;
         Left_Link : Value_Allocators.Void_Pointer;
         Right_Link : Value_Allocators.Void_Pointer;
         Value_Field : aliased Value_Type;
      end record;

   procedure Assign(To: in out Tree_Node; From: in Tree_Node);
   pragma InLine(Assign);

   package Tree_Node_Controlled_Stubs is new SGL.Controlled_Stubs(Tree_Node);
   use Tree_Node_Controlled_Stubs;

   package Tree_Node_Allocators is new SGL.Default_Allocators
     (Tree_Node, Assign);

   subtype Link_Type is Tree_Node_Allocators.Pointer;
   subtype Constant_Link_Type is Tree_Node_Allocators.Constant_Pointer;

   type Tree is new Ada.Finalization.Controlled with
      record
         Header        : Link_Type := null;
         Node_Count    : Size_Type := 0;
         Insert_Always : Boolean := true;
      end record;

   type Tree_Node_Buffer is
      record
         Next_Buffer : Value_Allocators.Void_Pointer;
         Buffer      : Link_Type;
      end record;

   procedure Assign(To: in out Tree_Node_Buffer; From: in Tree_Node_Buffer);
   pragma InLine(Assign);

   type Iterator is
      record
         Node : Link_Type := null;
      end record;

   type Constant_Iterator is
      record
         Node : Constant_Link_Type := null;
      end record;

   package Tree_Node_Buffer_Controlled_Stubs is
     new SGL.Controlled_Stubs(Tree_Node_Buffer);
   use Tree_Node_Buffer_Controlled_Stubs;

   package Buffer_Allocators is new SGL.Default_Allocators
     (Tree_Node_Buffer, Assign);
   subtype Buffer_Pointer is Buffer_Allocators.Pointer;

   -- Tree Node helper functions

   function Make_Iterator(X: in Link_Type) return Iterator;
   function Make_Iterator(X: in Constant_Link_Type) return Constant_Iterator;
   pragma Inline(Make_Iterator);

   procedure Set_Node(I : in out Iterator; X : in Link_Type);
   procedure Set_Node(I : in out Constant_Iterator; X : in Constant_Link_Type);
   pragma Inline(Set_Node);

   function Left(X : in Link_Type) return Link_Type;
   function Left(X : in Constant_Link_Type) return Constant_Link_Type;
   pragma Inline(Left);

   function Right(X : in Link_Type) return Link_Type;
   function Right(X : in Constant_Link_Type) return Constant_Link_Type;
   pragma Inline(Right);

   function Parent(X : in Link_Type) return Link_Type;
   function Parent(X : in Constant_Link_Type) return Constant_Link_Type;
   pragma Inline(Parent);

   function Value(X : in Link_Type) return Value_Type;
   function Value(X : in Constant_Link_Type) return Value_Type;
   pragma Inline(Value);

   function Key(X : in Link_Type) return Key_Type;
   function Key(X : in Constant_Link_Type) return Key_Type;
   pragma Inline(Key);

   function Color(X : in Link_Type) return Color_Type;
   function Color(X : in Constant_Link_Type) return Color_Type;
   pragma Inline(Color);


   procedure Set_Left(X, Y : in Link_Type);
   pragma Inline(Set_Left);

   procedure Set_Right(X, Y : in Link_Type);
   pragma Inline(Set_Right);

   procedure Set_Parent(X, Y : in Link_Type);
   pragma Inline(Set_Parent);

   procedure Set_Value(X : in Link_Type; V : in Value_Type);
   pragma Inline(Set_Value);

   procedure Set_Color(X : in Link_Type; C : in Color_Type);
   pragma Inline(Set_Color);


   function Minimum(X : in Link_Type) return Link_Type;
   function Minimum(X : in Constant_Link_Type) return Constant_Link_Type;
   pragma Inline(Minimum);

   function Maximum(X : in Link_Type) return Link_Type;
   function Maximum(X : in Constant_Link_Type) return Constant_Link_Type;
   pragma Inline(Maximum);

   -- Tree helper functions

   function Node(I : in Iterator) return Link_Type;
   function Node(I : in Constant_Iterator) return Constant_Link_Type;
   pragma Inline(Node);

   function Root(T : in Tree_Pointer) return Link_Type;
   function Root(T : in Tree) return Constant_Link_Type;
   pragma Inline(Root);

   function Leftmost(T : in Tree_Pointer) return Link_Type;
   function Leftmost(T : in Tree) return Constant_Link_Type;
   pragma Inline(Leftmost);

   function Rightmost(T : in Tree_Pointer) return Link_Type;
   function Rightmost(T : in Tree) return Constant_Link_Type;
   pragma Inline(Rightmost);

   procedure Set_Root(T : in out Tree; X : in Link_Type);
   pragma Inline(Set_Root);

   procedure Set_Leftmost(T : in out Tree; X : in Link_Type);
   pragma Inline(Set_Leftmost);

   procedure Set_Rightmost(T : in out Tree; X : in Link_Type);
   pragma Inline(Set_Rightmost);

   procedure Rotate_Left(T : in out Tree; X : in Link_Type);
   pragma Inline(Rotate_Left);

   procedure Rotate_Right(T : in out Tree; X : in Link_Type);
   pragma Inline(Rotate_Right);

   procedure Insert(T: in out Tree; X_IN, Y_IN : in Link_Type;
                                    V: in Value_Type;
                                    I: out Iterator);
   pragma Inline(Insert);

   function Copy(X_IN, P_IN : in Link_Type) return Link_Type;
   -- Recursive, can't inline

   procedure Erase(X_IN : in Link_Type);
   pragma Inline(Erase);

end SGL.Trees;
