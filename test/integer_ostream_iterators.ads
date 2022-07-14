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
with SGL.Integer_Operations;
with SGL.Ostream_Iterators;
with SGL.Output_Iterators;
with SGL.Iterator_Tags;

package Integer_Ostream_Iterators is
   package Integer_IO is new Ada.Text_IO.Integer_IO(Integer);

   package Integer_Operations is new SGL.Integer_Operations
     (Integer,"=", "<", ">", "<=", ">=", "-", "+", "*", "/", Integer_IO.Put);

   procedure Put_Comma(I : in Integer);
   pragma InLine(Put_Comma);

   procedure Integer_Assign(To: in out Integer; From: in Integer);
   pragma InLine(Integer_Assign);

   package Ostream_Iterators is new SGL.Ostream_Iterators
     (Integer, Integer_Assign, Put_Comma, Integer_Operations,
      SGL.Iterator_Tags.Output_Iterator_Tag);

   package Output_Iterators is new SGL.Output_Iterators
     (Ostream_Iterators.Value_Type,
      Ostream_Iterators.Assign,
      Ostream_Iterators.Iterator,
      Ostream_Iterators.Distance_Type_Operations,
      Ostream_Iterators.Iterator_Category,
      Ostream_Iterators.Inc,
      Ostream_Iterators.Assign);

end Integer_Ostream_Iterators;
