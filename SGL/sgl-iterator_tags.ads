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
--  $Id: sgl-iterator_tags.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL;

package SGL.Iterator_Tags is
   type Input_Iterator_Tag is null record;
   type Output_Iterator_Tag is null record;
   type Forward_Iterator_Tag is null record;
   type Bidirectional_Iterator_Tag is null record;
   type Random_Access_Iterator_Tag is null record;

   function Identity(T: Input_Iterator_Tag) return Input_Iterator_Tag;
   function Identity(T: Output_Iterator_Tag) return Output_Iterator_Tag;
   function Identity(T: Forward_Iterator_Tag) return Forward_Iterator_Tag;
   function Identity(T: Bidirectional_Iterator_Tag)
                     return Bidirectional_Iterator_Tag;
   function Identity(T: Random_Access_Iterator_Tag)
                     return Random_Access_Iterator_Tag;

   pragma InLine(Identity);

end SGL.Iterator_Tags;
