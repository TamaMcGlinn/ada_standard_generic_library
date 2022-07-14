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

generic
   type Value_Type1 is private;
   type Value_Type2 is private;
   with function Eq1(A, B: Value_Type1) return Boolean;
   with function Eq2(A, B: Value_Type2) return Boolean;

   -- At this point < is not defined on pairs in order for pairs
   -- of Input_Iterators to be allowed.

package SGL.Pairs is
   type Pair is record
         First  : Value_Type1;
         Second : Value_Type2;
   end record;

   function "="(A, B: Pair) return Boolean;
   pragma Inline ("=");

   function Make_Pair(A: Value_Type1; B: Value_Type2) return Pair;
   pragma Inline (Make_Pair);

end SGL.Pairs;

