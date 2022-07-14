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
--  $Id: sgl-set_signatures.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--
--  Instantiates Set iterator signature packages for general iterators,
--  constant iterators, and restricted (general iterators with only constant
--  operations) iterators.  Also instantiates Reverse_Iterators and their
--  iterator signatures.
--

with SGL;
with SGL.Sets;
with SGL.Containers;
with SGL.Reverse_Constant_Iterator_Operations;
with SGL.Function_Adaptors;

with SGL.Input_Iterators;
with SGL.Forward_Constant_Iterators;
with SGL.Bidirectional_Constant_Iterators;
with SGL.Reverse_Bidirectional_Constant_Iterators;

generic
   with package Instance_Sets is new SGL.Sets(<>);

package SGL.Set_Signatures is
   use Instance_Sets;

   -- Input

   package Set_Input_Iterators is new SGL.Input_Iterators
     (Value_Type, Constant_Iterator, Distance_Type_Operations,
      Iterator_Category);

   package Set_Input_Constant_Iterators is new SGL.Input_Iterators
     (Value_Type, Constant_Iterator, Distance_Type_Operations,
      Iterator_Category);

   -- Forward

   package Set_Forward_Constant_Iterators is
     new SGL.Forward_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   -- Bidirectional

   package Set_Bidirectional_Constant_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   -- Instantiate container signature

    package Set_Containers is new SGL.Containers
      (Set, Set_Pointer, Set_Constant_Pointer,
       Set_Input_Iterators, Constant_Iterator,
       Size_Type_Operations, Difference_Type_Operations,
       Iterator_Category, Verify_Tag);

   -- Reverse Iterators

   package Set_Reverse_Bidirectional_Constant_Iterators is
     new SGL.Reverse_Bidirectional_Constant_Iterators
     (Set_Bidirectional_Constant_Iterators);

   -- Instantiate iterator signature packages with Reverse Iterators

   use Set_Reverse_Bidirectional_Constant_Iterators;

   -- Input Reverse Bidirectional Iterators

   package Set_Input_RIterators is new SGL.Input_Iterators
     (Set_Reverse_Bidirectional_Constant_Iterators.Value_Type,
      Set_Reverse_Bidirectional_Constant_Iterators.Constant_Reverse_Iterator,
      Set_Reverse_Bidirectional_Constant_Iterators.Distance_Type_Operations,
      Set_Reverse_Bidirectional_Constant_Iterators.Iterator_Category);

   package Set_Input_Constant_RIterators is new SGL.Input_Iterators
     (Set_Reverse_Bidirectional_Constant_Iterators.Value_Type,
      Set_Reverse_Bidirectional_Constant_Iterators.Constant_Reverse_Iterator,
      Set_Reverse_Bidirectional_Constant_Iterators.Distance_Type_Operations,
      Set_Reverse_Bidirectional_Constant_Iterators.Iterator_Category);

   -- Forward Reverse Bidirectional Iterators

   package Set_Forward_Constant_RIterators is
     new SGL.Forward_Constant_Iterators
     (Set_Reverse_Bidirectional_Constant_Iterators.Value_Type,
      Set_Reverse_Bidirectional_Constant_Iterators.Constant_Reverse_Iterator,
      Set_Reverse_Bidirectional_Constant_Iterators.Constant_Pointer,
      Set_Reverse_Bidirectional_Constant_Iterators.Distance_Type_Operations,
      Set_Reverse_Bidirectional_Constant_Iterators.Iterator_Category);

   -- Bidirectional Reverse Bidirectional Iterators

   package Set_Bidirectional_Constant_RIterators is
     new SGL.Bidirectional_Constant_Iterators
     (Set_Reverse_Bidirectional_Constant_Iterators.Value_Type,
      Set_Reverse_Bidirectional_Constant_Iterators.Constant_Reverse_Iterator,
      Set_Reverse_Bidirectional_Constant_Iterators.Constant_Pointer,
      Set_Reverse_Bidirectional_Constant_Iterators.Distance_Type_Operations,
      Set_Reverse_Bidirectional_Constant_Iterators.Iterator_Category);

   -- Instantiate Reverse Iterators operations (RStart, RFinish) ...

   function Identity is new SGL.Function_Adaptors.Identity
     (Set_Containers.Constant_Iterator);

   package Set_Reverse_Bidirectional_Constant_Iterator_Operations is
     new SGL.Reverse_Constant_Iterator_Operations
     (Set_Containers,
      Set_Reverse_Bidirectional_Constant_Iterators.Constant_Reverse_Iterator);

end SGL.Set_Signatures;
