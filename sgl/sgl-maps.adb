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

with SGL.Input_Iterators;
with SGL.Basic_Algorithms;

package body SGL.Maps is

   package Input_Constant_Iterators is
     new SGL.Input_Iterators
     (Value_Type, Constant_Iterator, Size_Type_Operations,
      Iterator_Category, Inc, "=", Val);

   function Select1st(P : in Pair_Type) return Key_T is
   begin
      return(First(P));
   end Select1st;


   procedure Initialize(M: in out Map) is
   begin
      Rep_Type.Set_Insert_Always(M.T, False);
   end Initialize;

   -- accessors

   function Ref_Second(P: in Pointer) return Map_Pairs.Data_Pointer is
   begin
      return Map_Pairs.Ref_Second(Map_Pairs.Pair_Type_Pointer(P));
   end Ref_Second;

   function Start(M: in Map_Pointer) return Iterator is
   begin
      return(Rep_Type.Start(M.T'Unchecked_Access));
   end Start;

   function Start(M: in Map) return Constant_Iterator is
   begin
      return(Rep_Type.Start(M.T));
   end Start;

   function Finish(M: in Map_Pointer) return Iterator is
   begin
      return(Rep_Type.Finish(M.T'Unchecked_Access));
   end Finish;

   function Finish(M: in Map) return Constant_Iterator is
   begin
      return(Rep_Type.Finish(M.T));
   end Finish;

   function Empty(M: in Map) return Boolean is
   begin
      return(Rep_Type.Empty(M.T));
   end Empty;

   function Size(M: in Map) return Size_Type is
   begin
      return(Rep_Type.Size(M.T));
   end Size;

   function Max_Size(M: in Map) return Size_Type is
   begin
      return(Rep_Type.Max_Size(M.T));
   end Max_Size;

   function Value(M: in Map; K: Key_Type) return Data_T is
   begin
      return(Second(Val(Rep_Type.Find(M.T, K))));
   end Value;

   -- modifiers

   procedure Assign(M: in out Map; K: in Key_Type; E: in Data_T) is
      P : Pair_Type;
      I : Iterator;
      Success : Boolean;
   begin
      Map_Pairs_Extension.Set_First(P, K);
      Set_Second(P, E);
      Rep_Type.Insert(M.T, P, I, Success);
      if (not Success) then  -- The Key already exists
         Set_Second(Ref(I).all, E);
      end if;
   end Assign;

   procedure Swap(M1, M2: in out Map) is
   begin
      Rep_Type.Swap(M1.T, M2.T);
   end Swap;

   -- insert/erase

   procedure Insert(M: in out Map; X: in Value_Type;
                                  I: out Iterator;
                                  Success : out Boolean) is
   begin
      Rep_Type.Insert(M.T, X, I, Success);
   end Insert;

   procedure Insert(M: in out Map; Position: in Iterator;
                                   X: in Value_Type;
                                   I: out Iterator) is
   begin
      Rep_Type.Insert(M.T, Position, X, I);
   end Insert;

   procedure Insert(M: in out Map; First, Last : in Constant_Pointer) is
   begin
      Rep_Type.Insert(M.T, First, Last);
   end Insert;

   procedure Erase(M: in out Map; Position : in Iterator) is
   begin
      Rep_Type.Erase(M.T, Position);
   end Erase;

   procedure Erase(M: in out Map; K : in Key_Type; S : out Size_Type) is
   begin
      Rep_Type.Erase(M.T, K, S);
   end Erase;

   procedure Erase(M: in out Map; First, Last : in Iterator) is
   begin
      Rep_Type.Erase(M.T, First, Last);
   end Erase;

   -- map operations

   function "="(M1, M2: in Map) return Boolean is
      function Equal is new SGL.Basic_Algorithms.Equal
        (Input_Constant_Iterators, Input_Constant_Iterators, Map_Pairs."=");
--       use Size_Type_Operations;
   begin
      return ( Size_Type_Operations."="(Size(M1), Size(M2)) and then
               Equal(Start(M1), Finish(M1), Start(M2)) );
   end "=";

   function "<"(M1, M2: in Map) return Boolean is
      function Lexicographical_Compare is
        new SGL.Basic_Algorithms.Lexicographical_Compare
        (Input_Constant_Iterators, Input_Constant_Iterators,
         Map_Pairs."<", Map_Pairs."<");
   begin
      return Lexicographical_Compare(Start(M1), Finish(M1),
                                     Start(M2), Finish(M2));
   end "<";

   function Find(M: in Map_Pointer; K : in Key_Type) return Iterator is
   begin
      return(Rep_Type.Find(M.T'Unchecked_Access, K));
   end ;

   function Find(M: in Map; K : in Key_Type) return Constant_Iterator is
   begin
      return(Rep_Type.Find(M.T, K));
   end ;

   function Count(M: in Map; K : in Key_Type) return Size_Type is
   begin
      return(Rep_Type.Count(M.T, K));
   end ;

   function Lower_Bound(M: in Map_Pointer; K : in Key_Type) return Iterator is
   begin
      return(Rep_Type.Lower_Bound(M.T'Unchecked_Access, K));
   end ;

   function Lower_Bound(M: in Map; K : in Key_Type) return Constant_Iterator is
   begin
      return(Rep_Type.Lower_Bound(M.T, K));
   end ;

   function Upper_Bound(M: in Map_Pointer; K : in Key_Type) return Iterator is
   begin
      return(Rep_Type.Upper_Bound(M.T'Unchecked_Access, K));
   end ;

   function Upper_Bound(M: in Map; K : in Key_Type) return Constant_Iterator is
   begin
      return(Rep_Type.Upper_Bound(M.T, K));
   end ;

   function Equal_Range(M: in Map; X : in Key_Type)
                        return Pairs_CIterator_CIterator.Pair is
      First, Second : Constant_Iterator;
   begin
      Rep_Type.Equal_Range(M.T, X, First, Second);
      return(Pairs_CIterator_CIterator.Make_Pair(First, Second));
   end Equal_Range;

end SGL.Maps;
