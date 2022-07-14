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
--  $Id: sgl-reverse_bidirectional_constant_iterators.adb,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

package body SGL.Reverse_Bidirectional_Constant_Iterators is

   procedure Inc(I: in out Constant_Reverse_Iterator) is
   begin
      Bidirectional_Constant_Iterators.Dec(I.Iter);
   end Inc;

   function Next(I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator is
      N : Constant_Reverse_Iterator;
   begin
      N.Iter := Bidirectional_Constant_Iterators.Prev(I.Iter);
      return(N);
   end Next;

   procedure Dec(I: in out Constant_Reverse_Iterator) is
   begin
      Bidirectional_Constant_Iterators.Inc(I.Iter);
   end Dec;

   function Prev(I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator is
      N : Constant_Reverse_Iterator;
   begin
      N.Iter := Bidirectional_Constant_Iterators.Next(I.Iter);
      return(N);
   end Prev;

   function "=" (I, J : in Constant_Reverse_Iterator) return Boolean is
   begin
      return(Bidirectional_Constant_Iterators."="(I.Iter, J.Iter));
   end "=";
   pragma Inline ("=");

   function Val(I: in Constant_Reverse_Iterator) return Value_Type is
   begin
      return(Bidirectional_Constant_Iterators.Val
             (Bidirectional_Constant_Iterators.Prev(I.Iter)));
   end Val;

   function Ref(I: in Constant_Reverse_Iterator) return Constant_Pointer is
   begin
      return(Bidirectional_Constant_Iterators.Ref
             (Bidirectional_Constant_Iterators.Prev(I.Iter)));
   end Ref;

   function Make_Reverse(I: in Constant_Iterator)
                         return Constant_Reverse_Iterator is
      R : Constant_Reverse_Iterator;
   begin
      R.Iter := I;
      return(R);
   end Make_Reverse;

   function Get_Iterator(I: in Constant_Reverse_Iterator)
                         return Constant_Iterator is
   begin
      return(I.Iter);
   end Get_Iterator;

end SGL.Reverse_Bidirectional_Constant_Iterators;
