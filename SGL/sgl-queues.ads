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
--  $Id: sgl-queues.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL.Containers;

generic
   with package Containers is new SGL.Containers(<>);
   use Containers;

   with function Front(C: in Container) return Value_Type is <>;
   with function Back(C: in Container) return Value_Type is <>;
   with procedure Push_Back(C: in out Container; V: in Value_Type) is <>;
   with procedure Pop_Front(C: in out Container) is <>;

package SGL.Queues is
   type Queue is private;

   package Size_Type_Operations renames Containers.Size_Type_Operations;

   function Empty(Q: in Queue) return Boolean;
   pragma Inline(Empty);

   function Size(Q: in Queue) return Size_Type;
   pragma Inline(Size);

   function Front(Q: in Queue) return Value_Type;
   pragma Inline(Front);

   function Back(Q: in Queue) return Value_Type;
   pragma Inline(Back);

   procedure Push(Q: in out Queue; V: Value_Type);
   pragma Inline(Push);

   procedure Pop(Q: in out Queue);
   pragma Inline(Pop);

   function "="(Q1, Q2: in Queue) return Boolean;
   pragma Inline("=");

   --
   -- private
   --

private
   type Queue is
      record
         C: Container;
      end record;

end SGL.Queues;
