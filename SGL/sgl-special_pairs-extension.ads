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
--  $Id: sgl-special_pairs-extension.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

generic
package SGL.Special_Pairs.Extension is

   procedure Assign(To: in out Pair_Type; From: in Pair_Type);
   pragma InLine(Assign);

   procedure Set_First(P: in out Pair_Type; K: in Key_T);
   pragma InLine(Set_First);

end SGL.Special_Pairs.Extension;