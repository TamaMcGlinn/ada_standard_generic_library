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
--  $Id: sgl-input_iterators.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL.Integer_Operations;

generic
   type Value_Type is limited private;
   type Iterator is private;

   with package Distance_Type_Operations is new SGL.Integer_Operations(<>);

   type Iterator_Category is private;

   with procedure Inc(I: in out Iterator) is <>;
   with function "="(I, J : Iterator) return Boolean is <>;
   with function Val(I: in Iterator) return Value_Type is <>;

package SGL.Input_Iterators is
   subtype Distance_Type is Distance_Type_Operations.T;

end SGL.Input_Iterators;
