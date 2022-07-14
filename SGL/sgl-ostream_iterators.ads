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
--  $Id: sgl-ostream_iterators.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL.Integer_Operations;

generic
   type T is limited private;
   with procedure Assign(To: in out T; From: in T);

   with procedure Put(V: in T);

   -- XXX - Gnat 3.09 bug forces renaming
   with package Distance_Type_Operations_GNAT is
    new SGL.Integer_Operations(<>);
   type Iterator_Category_GNAT is private;

package SGL.Ostream_Iterators is
   -- XXX - Gnat 3.09 bug forces renaming
   package Distance_Type_Operations renames Distance_Type_Operations_GNAT;
   subtype Iterator_Category is Iterator_Category_GNAT;

   subtype Value_Type is T;
   type Iterator is private;
   type Constant_Iterator is private;

   procedure Inc(I: in out Iterator);
   procedure Inc(I: in out Constant_Iterator);
   pragma Inline(Inc);

   procedure Assign(I: in out Iterator; V: in value_type);
   pragma Inline(Assign);

   function Make_Constant(I : in Iterator) return Constant_Iterator;
   pragma Inline(Make_Constant);

private
   type Iterator is null record;
   type Constant_Iterator is null record;

end SGL.Ostream_Iterators;
