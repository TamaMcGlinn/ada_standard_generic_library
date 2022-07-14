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
--  $Id: sgl-containers.adb,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL.Basic_Algorithms;
with SGL.Input_Constant_Iterators;

package body SGL.Containers is
   use Container_Input_Iterators;

   package Container_Input_Constant_Iterators is
     new SGL.Input_Constant_Iterators(Value_Type, Constant_Iterator,
                                      Size_Type, Inc, "=", Val);

   function "="(C1, C2: in Container) return Boolean is
      function Equal is new SGL.Basic_Algorithms.Equal
        (Container_Input_Constant_Iterators,
         Container_Input_Constant_Iterators);
      use Size_Type_Operations;
   begin
      return (Size(C1) = Size(C2)) and then
        Equal(Start(C1), Finish(C1), Start(C2));
   end "=";

   package body Sequence_Operations is

      function ">"(C1, C2: in Container) return Boolean is
      begin
         return(C2 < C1);
      end ">";

      function "<="(C1, C2: in Container) return Boolean is
      begin
         return(not (C1 > C2));
      end "<=";

      function ">="(C1, C2: in Container) return Boolean is
      begin
         return(not (C1 < C2));
      end ">=";
   end Sequence_Operations;

end SGL.Containers;
