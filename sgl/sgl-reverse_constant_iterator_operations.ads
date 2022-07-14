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

with SGL;
with SGL.Containers;
with SGL.Bidirectional_Constant_Iterators;

generic
   with package Containers is new SGL.Containers(<>);
   type Constant_Reverse_Iterator is private;
   with function Make_Reverse(I : Containers.Constant_Iterator)
     return Constant_Reverse_Iterator is <>;

package SGL.Reverse_Constant_Iterator_Operations is

   function RStart(C: in Containers.Container)
                   return Constant_Reverse_Iterator;

   function RFinish(C: in Containers.Container)
                    return Constant_Reverse_Iterator;

end SGL.Reverse_Constant_Iterator_Operations;
