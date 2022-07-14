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
--  $Id: sgl-ostream_iterators.adb,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

package body SGL.Ostream_Iterators is

  procedure Inc(I: in out Iterator) is
  begin
     null;
  end Inc;

  procedure Inc(I: in out Constant_Iterator) is
  begin
     null;
  end Inc;

  procedure Assign(I: in out Iterator; V: in Value_Type) is
  begin
     Put(V);
  end Assign;

  function Make_Constant(I: in Iterator) return Constant_Iterator is
     C : Constant_Iterator;
  begin
     return(C);
  end Make_Constant;

end SGL.Ostream_Iterators;
