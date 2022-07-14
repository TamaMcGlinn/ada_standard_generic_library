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
--  $Id: sgl-priority_queues.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

generic
   type Container is private;
   type Value_Type is private;
   type Size_Type is range <>;

   -- Compare operation (explicitely passed)
   with function "<"(A, B: Value_Type) return Boolean;

   -- Container operations imported

   with function Empty(C: in Container) return Boolean is <>;
   with function Size(C: in Container) return Size_Type is <>;
   with function "="(C1, C2: in Container) return Boolean is <>;
   with function "<"(C1, C2: in Container) return Boolean is <>;
   with function Front(C: in Container) return Value_Type is <>;
   with function Back(C: in Container) return Value_Type is <>;
   with procedure Push_Back(C: in out Container; V: in Value_Type) is <>;
   with procedure Pop_Front(C: in out Container) is <>;

   -- Value_Type operations imported
   with function "="(A, B: Value_Type) return Boolean is <>;

   -- Size_Type operations imported

   with function "="(A, B: Size_Type) return Boolean is <>;
   with function "<"(A, B: Size_Type) return Boolean is <>;
   with function ">"(A, B: Size_Type) return Boolean is <>;
   with function "<="(A,B: Size_Type) return Boolean is <>;
   with function ">="(A,B: Size_Type) return Boolean is <>;
   with function "-"(A, B: Size_Type) return Size_Type is <>;
   with function "+"(A, B: Size_Type) return Size_Type is <>;
   with function "*"(A, B: Size_Type) return Size_Type is <>;
   with function "/"(A, B: Size_Type) return Size_Type is <>;

package SGL.Priority_Queues is
   type Priority_Queue is private;

   function Empty(Q: in Priority_Queue) return Boolean;
   pragma Inline(Empty);

   function Size(Q: in Priority_Queue) return Size_Type;
   pragma Inline(Size);

   function Front(Q: in Priority_Queue) return Value_Type;
   pragma Inline(Front);

   function Back(Q: in Priority_Queue) return Value_Type;
   pragma Inline(Back);

   procedure Push(Q: in out Priority_Queue; V: Value_Type);
   pragma Inline(Push);

   procedure Pop(Q: in out Priority_Queue);
   pragma Inline(Pop);

   function "="(Q1, Q2: in Priority_Queue) return Boolean;
   pragma Inline("=");

   function "<"(Q1, Q2: in Priority_Queue) return Boolean;
   pragma Inline("<");

private
   type Priority_Queue is
      record
         C: Container;
      end record;
end SGL.Priority_Queues;
