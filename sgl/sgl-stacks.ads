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

with SGL.Containers;

generic
   with package Containers is new SGL.Containers(<>);
   use Containers;

   with function Back(C: in Container) return Value_Type is <>;
   with procedure Push_Back(C: in out Container; V: in Value_Type) is <>;
   with procedure Pop_Back(C: in out Container) is <>;

package SGL.Stacks is
   type Stack is private;

   package Size_Type_Operations renames Containers.Size_Type_Operations;

   function Empty(S: in Stack) return Boolean;
   pragma Inline(Empty);

   function Size(S: in Stack) return Size_Type;
   pragma Inline(Size);

   function Top(S: in Stack) return Value_Type;
   pragma Inline(Top);

   procedure Push(S: in out Stack; V: Value_Type);
   pragma Inline(Push);

   procedure Pop(S: in out Stack);
   pragma Inline(Pop);

   function "="(S1, S2: in Stack) return Boolean;
   pragma Inline("=");

private
   type Stack is
      record
         C: Container;
      end record;
end SGL.Stacks;
