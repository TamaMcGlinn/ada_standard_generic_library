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
--  $Id: sgl-reverse_bidirectional_iterators.adb,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

package body SGL.Reverse_Bidirectional_Iterators is

   procedure Inc(I: in out Reverse_Iterator) is
   begin
      Bidirectional_Iterators.Dec(I.Iter);
   end Inc;

   procedure Inc(I: in out Constant_Reverse_Iterator) is
   begin
      Bidirectional_Iterators.Dec(I.Iter);
   end Inc;

   function Next(I: in Reverse_Iterator) return Reverse_Iterator is
      N : Reverse_Iterator;
   begin
      N.Iter := Bidirectional_Iterators.Prev(I.Iter);
      return(N);
   end Next;

   function Next(I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator is
      N : Constant_Reverse_Iterator;
   begin
      N.Iter := Bidirectional_Iterators.Prev(I.Iter);
      return(N);
   end Next;

   procedure Dec(I: in out Reverse_Iterator) is
   begin
      Bidirectional_Iterators.Inc(I.Iter);
   end Dec;

   procedure Dec(I: in out Constant_Reverse_Iterator) is
   begin
      Bidirectional_Iterators.Inc(I.Iter);
   end Dec;

   function Prev(I: in Reverse_Iterator) return Reverse_Iterator is
      N : Reverse_Iterator;
   begin
      N.Iter := Bidirectional_Iterators.Next(I.Iter);
      return(N);
   end Prev;

   function Prev(I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator is
      N : Constant_Reverse_Iterator;
   begin
      N.Iter := Bidirectional_Iterators.Next(I.Iter);
      return(N);
   end Prev;

   function "=" (I, J : in Reverse_Iterator) return Boolean is
   begin
      return(Bidirectional_Iterators."="(I.Iter, J.Iter));
   end "=";

   function "=" (I, J : in Constant_Reverse_Iterator) return Boolean is
   begin
      return(Bidirectional_Iterators."="(I.Iter, J.Iter));
   end "=";
   pragma Inline ("=");

   function Val(I: in Reverse_Iterator) return Value_Type is
   begin
      return(Bidirectional_Iterators.Val
             (Bidirectional_Iterators.Prev(I.Iter)));
   end Val;

   function Val(I: in Constant_Reverse_Iterator) return Value_Type is
   begin
      return(Bidirectional_Iterators.Val
             (Bidirectional_Iterators.Prev(I.Iter)));
   end Val;

   procedure Assign(I: in out Reverse_Iterator; V: in Value_Type) is
      P : Bidirectional_Iterators.Iterator :=
        Bidirectional_Iterators.Prev(I.Iter);
   begin
      Bidirectional_Iterators.Assign(P, V);
   end Assign;

   function Ref(I: in Reverse_Iterator) return Pointer is
   begin
      return(Bidirectional_Iterators.Ref
             (Bidirectional_Iterators.Prev(I.Iter)));
   end Ref;

   function Ref(I: in Constant_Reverse_Iterator) return Constant_Pointer is
   begin
      return(Bidirectional_Iterators.Ref
             (Bidirectional_Iterators.Prev(I.Iter)));
   end Ref;

   function Make_Constant(I: in Reverse_Iterator)
                          return Constant_Reverse_Iterator is
      C : Constant_Reverse_Iterator;
   begin
      C.Iter := Bidirectional_Iterators.Make_Constant(I.Iter);
      return(C);
   end Make_Constant;

   function Make_Reverse(I: in Iterator) return Reverse_Iterator is
      R : Reverse_Iterator;
   begin
      R.Iter := I;
      return(R);
   end Make_Reverse;

   function Make_Reverse(I: in Constant_Iterator)
                         return Constant_Reverse_Iterator is
      R : Constant_Reverse_Iterator;
   begin
      R.Iter := I;
      return(R);
   end Make_Reverse;

   function Get_Iterator(I: in Reverse_Iterator) return Iterator is
   begin
      return(I.Iter);
   end Get_Iterator;

   function Get_Iterator(I: in Constant_Reverse_Iterator)
                         return Constant_Iterator is
   begin
      return(I.Iter);
   end Get_Iterator;

end SGL.Reverse_Bidirectional_Iterators;
