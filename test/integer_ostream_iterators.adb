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

with Ada.Text_IO;
with Gnat.IO; use Gnat.IO;
with SGL.Integer_Operations;
with SGL.Ostream_Iterators;
with SGL.Output_Iterators;

package body Integer_Ostream_Iterators is

   procedure Put_Comma(I : in Integer) is
   begin
      Integer_IO.Put(I);
      Put(", ");
   end Put_Comma;

   procedure Integer_Assign(To: in out Integer; From: in Integer) is
   begin
      To := From;
   end Integer_Assign;

end Integer_Ostream_Iterators;
