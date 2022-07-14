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

package body SGL.Stacks is

   function Empty(S: in Stack) return Boolean is
   begin
      return(Empty(S.C));
   end Empty;

   function Size(S: in Stack) return Size_Type is
   begin
      return(Size(S.C));
   end Size;

   function Top(S: in Stack) return Value_Type is
   begin
      return(Back(S.C));
   end Top;

   procedure Push(S: in out Stack; V: Value_Type) is
   begin
      Push_Back(S.C, V);
   end Push;

   procedure Pop(S: in out Stack) is
   begin
      Pop_Back(S.C);
   end Pop;

   function "="(S1, S2: in Stack) return Boolean is
   begin
      return(S1.C = S2.C);
   end "=";

end SGL.Stacks;
