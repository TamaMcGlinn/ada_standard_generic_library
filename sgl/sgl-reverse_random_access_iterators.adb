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

package body SGL.Reverse_Random_Access_Iterators is

   procedure Inc(I: in out Reverse_Iterator) is
   begin
      Random_Access_Iterators.Dec(I.Iter);
   end Inc;

   procedure Inc(I: in out Constant_Reverse_Iterator) is
   begin
      Random_Access_Iterators.Dec(I.Iter);
   end Inc;

   function Next(I: in Reverse_Iterator) return Reverse_Iterator is
      N : Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators.Prev(I.Iter);
      return(N);
   end Next;

   function Next(I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator is
      N : Constant_Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators.Prev(I.Iter);
      return(N);
   end Next;

   procedure Dec(I: in out Reverse_Iterator) is
   begin
      Random_Access_Iterators.Inc(I.Iter);
   end Dec;

   procedure Dec(I: in out Constant_Reverse_Iterator) is
   begin
      Random_Access_Iterators.Inc(I.Iter);
   end Dec;

   function Prev(I: in Reverse_Iterator) return Reverse_Iterator is
      N : Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators.Next(I.Iter);
      return(N);
   end Prev;

   function Prev(I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator is
      N : Constant_Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators.Next(I.Iter);
      return(N);
   end Prev;

   procedure IncBy(I: in out Reverse_Iterator; K : Distance_Type) is
   begin
      Random_Access_Iterators.DecBy(I.Iter, K);
   end IncBy;

   procedure IncBy(I: in out Constant_Reverse_Iterator; K : Distance_Type) is
   begin
      Random_Access_Iterators.DecBy(I.Iter, K);
   end IncBy;

   procedure DecBy(I: in out Reverse_Iterator; K : Distance_Type) is
   begin
      Random_Access_Iterators.IncBy(I.Iter, K);
   end DecBy;

   procedure DecBy(I: in out Constant_Reverse_Iterator; K : Distance_Type) is
   begin
      Random_Access_Iterators.IncBy(I.Iter, K);
   end DecBy;

   function "=" (I, J : in Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators."="(I.Iter, J.Iter));
   end "=";

   function "=" (I, J : in Constant_Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators."="(I.Iter, J.Iter));
   end "=";
   pragma Inline ("=");

   function "+" (I: in Reverse_Iterator; K : Distance_Type)
                 return Reverse_Iterator is
      N : Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators."-"(I.Iter, K);
      return(N);
   end "+";

   function "+" (I: in Constant_Reverse_Iterator; K : Distance_Type)
                 return Constant_Reverse_Iterator is
      N : Constant_Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators."-"(I.Iter, K);
      return(N);
   end "+";

   function "+" (K : Distance_Type; I: in Reverse_Iterator) return Reverse_Iterator is
      N : Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators."-"(I.Iter, K);
      return(N);
   end "+";

   function "+" (K : Distance_Type; I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator is
      N : Constant_Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators."-"(I.Iter, K);
      return(N);
   end "+";

   function "-" (I, J: in Reverse_Iterator) return Distance_Type is
   begin
      return(Random_Access_Iterators."-"(J.Iter, I.Iter));
   end "-";

   function "-" (I, J: in Constant_Reverse_Iterator) return Distance_Type is
   begin
      return(Random_Access_Iterators."-"(J.Iter, I.Iter));
   end "-";

   function "-" (I: in Reverse_Iterator; K: Distance_Type) return Reverse_Iterator is
      N : Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators."+"(I.Iter, K);
      return(N);
   end "-";

   function "-" (I: in Constant_Reverse_Iterator; K: Distance_Type)
                 return Constant_Reverse_Iterator is
      N : Constant_Reverse_Iterator;
   begin
      N.Iter := Random_Access_Iterators."+"(I.Iter, K);
      return(N);
   end "-";

   function "<" (I, J: in Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators.">"(I.Iter, J.Iter));
   end "<";

   function "<" (I, J: in Constant_Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators.">"(I.Iter, J.Iter));
   end "<";

   function ">" (I, J: in Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators."<"(I.Iter, J.Iter));
   end ">";

   function ">" (I, J: in Constant_Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators."<"(I.Iter, J.Iter));
   end ">";

   function "<=" (I, J: in Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators.">="(I.Iter, J.Iter));
   end "<=";

   function "<=" (I, J: in Constant_Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators.">="(I.Iter, J.Iter));
   end "<=";

   function ">=" (I, J: in Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators."<="(I.Iter, J.Iter));
   end ">=";

   function ">=" (I, J: in Constant_Reverse_Iterator) return Boolean is
   begin
      return(Random_Access_Iterators."<="(I.Iter, J.Iter));
   end ">=";

   function Val(I: in Reverse_Iterator) return Value_Type is
   begin
      return(Random_Access_Iterators.Val
             (Random_Access_Iterators.Prev(I.Iter)));
   end Val;

   function Val(I: in Constant_Reverse_Iterator) return Value_Type is
   begin
      return(Random_Access_Iterators.Val
             (Random_Access_Iterators.Prev(I.Iter)));
   end Val;

   procedure Assign(I: in out Reverse_Iterator; V: in Value_Type) is
      P : Random_Access_Iterators.Iterator :=
        Random_Access_Iterators.Prev(I.Iter);
   begin
      Random_Access_Iterators.Assign(P, V);
   end Assign;

   function Ref(I: in Reverse_Iterator) return Pointer is
   begin
      return(Random_Access_Iterators.Ref
             (Random_Access_Iterators.Prev(I.Iter)));
   end Ref;

   function Ref(I: in Constant_Reverse_Iterator) return Constant_Pointer is
   begin
      return(Random_Access_Iterators.Ref
             (Random_Access_Iterators.Prev(I.Iter)));
   end Ref;

   function Make_Constant(I: in Reverse_Iterator) return
     Constant_Reverse_Iterator is
      C : Constant_Reverse_Iterator;
   begin
      C.Iter := Random_Access_Iterators.Make_Constant(I.Iter);
      return(C);
   end Make_Constant;


   function Make_Reverse(I: in Iterator)  return Reverse_Iterator is
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

end SGL.Reverse_Random_Access_Iterators;
