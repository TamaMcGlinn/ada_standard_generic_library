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

package body SGL.Queues is

   function Empty(Q: in Queue) return Boolean is
   begin
      return(Empty(Q.C));
   end Empty;

   function Size(Q: in Queue) return Size_Type is
   begin
      return(Size(Q.C));
   end ;

   function Front(Q: in Queue) return Value_Type is
   begin
      return(Front(Q.C));
   end ;

   function Back(Q: in Queue) return Value_Type is
   begin
      return(Back(Q.C));
   end ;

   procedure Push(Q: in out Queue; V: Value_Type) is
   begin
      Push_Back(Q.C, V);
   end ;

   procedure Pop(Q: in out Queue) is
   begin
      Pop_Front(Q.C);
   end ;

   function "="(Q1, Q2: in Queue) return Boolean is
   begin
      return(Q1.C = Q2.C);
   end ;

end SGL.Queues;
