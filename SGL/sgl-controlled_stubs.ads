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
--  $Id: sgl-controlled_stubs.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

generic
   type T is limited private;

package SGL.Controlled_Stubs is

   procedure Initialize(X: in out T);
   pragma Inline (Initialize);

   procedure Adjust(X: in out T);
   pragma Inline (Initialize);

   procedure Finalize(X: in out T);
   pragma Inline (Initialize);

end SGL.Controlled_Stubs;