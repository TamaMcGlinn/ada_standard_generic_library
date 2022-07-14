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

package body SGL.Pairs is

   function "="(A, B: Pair) return Boolean is
   begin
      return (Eq1(A.First, B.First)) and then (Eq2(A.Second, B.Second));
   end "=";

   function Make_Pair(A: Value_Type1; B: Value_Type2) return Pair is
      P : Pair := (A, B);
   begin
      return P;
   end Make_Pair;

end SGL.Pairs;
