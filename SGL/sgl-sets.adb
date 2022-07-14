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
--  $Id: sgl-sets.adb,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with Unchecked_Conversion;   -- XXX yikes !
with SGL.Input_Iterators;
with SGL.Basic_Algorithms;

package body SGL.Sets is
   use Rep_Type;
   use Rep_Type.Value_Type_Operations;
   use Rep_Type.Size_Type_Operations;

   package Input_Constant_Iterators is
     new SGL.Input_Iterators
     (Value_Type, Constant_Iterator, Size_Type_Operations,
      Iterator_Category, Inc, "=", Val);

   procedure Initialize(S: in out Set) is
   begin
      Set_Insert_Always(S.T, False);
   end Initialize;

   -- accessors

   function Start(S: in Set_Pointer) return Iterator is
   begin
      return(Start(S.T));
   end Start;

   function Start(S: in Set) return Constant_Iterator is
   begin
      return(Start(S.T));
   end Start;

   function Finish(S: in Set_Pointer) return Iterator is
   begin
      return(Finish(S.T));
   end Finish;

   function Finish(S: in Set) return Constant_Iterator is
   begin
      return(Finish(S.T));
   end Finish;

   function Empty(S: in Set) return Boolean is
   begin
      return(Empty(S.T));
   end Empty;

   function Size(S: in Set) return Size_Type is
   begin
      return(Size(S.T));
   end Size;

   function Max_Size(S: in Set) return Size_Type is
   begin
      return(Max_Size(S.T));
   end Max_Size;

   function Value(S: in Set; K: Key_Type) return Value_Type is
   begin
      return(Val(Find(S.T, K)));
   end Value;

   -- modifiers

   procedure Swap(S1, S2: in out Set) is
   begin
      Swap(S1.T, S2.T);
   end Swap;

   -- insert/erase

   procedure Insert(S: in out Set; X: in Value_Type;
                                   I: out Constant_Iterator;
                                   Success : out Boolean) is
      TI : Rep_Type.Iterator;
   begin
      Insert(S.T, X, TI, Success);
      I := Rep_Type.Make_Constant(TI);
   end Insert;

   procedure Insert(S: in out Set; Position: in Constant_Iterator;
                                   X: in Value_Type;
                                   I: out Constant_Iterator) is
       TI : Rep_Type.Iterator;
       -- XXX - We need a general iterator pointing to position.  The
       --       clean way to do this is by performing a search on the
       --       Tree to obtain the pointer.  We are however inherently
       --       lazy so instead we cast !
       function To_Iterator is new Unchecked_Conversion
         (Constant_Iterator, Rep_Type.Iterator);
   begin
      Insert(S.T, To_Iterator(Position), X, TI);
      I := Rep_Type.Make_Constant(TI);
   end Insert;

   procedure Insert(S: in out Set; First, Last : in Constant_Pointer) is
   begin
      Insert(S.T, First, Last);
   end Insert;

   procedure Erase(S: in out Set; Position : in Constant_Iterator) is
      -- XXX (see previous comment)
      function To_Iterator is new Unchecked_Conversion
        (Constant_Iterator, Rep_Type.Iterator);
  begin
      Erase(S.T, To_Iterator(Position));
   end Erase;

   procedure Erase(S: in out Set; K : in Key_Type; SZ : out Size_Type) is
   begin
      Erase(S.T, K, SZ);
   end Erase;

   procedure Erase(S: in out Set; First, Last : in Constant_Iterator) is
      -- XXX (see previous comment)
      function To_Iterator is new Unchecked_Conversion
        (Constant_Iterator, Rep_Type.Iterator);
   begin
      Erase(S.T, To_Iterator(First), To_Iterator(Last));
   end Erase;

   -- set operations

   function "="(S1, S2: in Set) return Boolean is
      function Equal is new SGL.Basic_Algorithms.Equal
        (Input_Constant_Iterators, Input_Constant_Iterators);
   begin
      return ( (Size(S1) = Size(S2)) and then
               Equal(Start(S1), Finish(S1), Start(S2)) );
   end "=";

   function "<"(S1, S2: in Set) return Boolean is
      function Lexicographical_Compare is
        new SGL.Basic_Algorithms.Lexicographical_Compare
        (Input_Constant_Iterators, Input_Constant_Iterators, "<", "<");
   begin
      return Lexicographical_Compare(Start(S1), Finish(S1),
                                     Start(S2), Finish(S2));
   end "<";

   function Find(S: in Set; K : in Key_Type) return Constant_Iterator is
   begin
      return(Find(S.T, K));
   end Find;

   function Count(S: in Set; K : in Key_Type) return Size_Type is
   begin
      return(Count(S.T, K));
   end Count;

   function Lower_Bound(S: in Set; K : in Key_Type) return Constant_Iterator is
   begin
      return(Lower_Bound(S.T, K));
   end Lower_Bound;

   function Upper_Bound(S: in Set; K : in Key_Type) return Constant_Iterator is
   begin
      return(Upper_Bound(S.T, K));
   end Upper_Bound;

   function Equal_Range(S: in Set; X : in Key_Type)
                        return Pairs_CIterator_CIterator.Pair is
      First, Second : Constant_Iterator;
   begin
      Equal_Range(S.T, X, First, Second);
      return(Pairs_CIterator_CIterator.Make_Pair(First, Second));
   end Equal_Range;

end SGL.Sets;
