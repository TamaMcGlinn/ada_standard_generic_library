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

with Gnat.IO;
use Gnat.IO;

procedure Test_Assert(Msg : in String; Value : in Boolean) is
begin
   Put(Msg);
   if (Value) then
      Put_Line("OK");
   else
      Put_Line("***ERROR***");
   end if;
end Test_Assert;
