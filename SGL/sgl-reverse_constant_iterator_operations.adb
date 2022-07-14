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
--  $Id: sgl-reverse_constant_iterator_operations.adb,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

package body SGL.Reverse_Constant_Iterator_Operations is

   function RStart(C: in Containers.Container)
                   return Constant_Reverse_Iterator is
   begin
      return(Make_Reverse(Containers.Finish(C)));
   end RStart;

   function RFinish(C: in Containers.Container)
                    return Constant_Reverse_Iterator is
   begin
      return(Make_Reverse(Containers.Start(C)));
   end RFinish;

end SGL.Reverse_Constant_Iterator_Operations;



