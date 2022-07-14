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

   -- Input

   package Set_Input_Iterators is new SGL.Input_Iterators
     (Value_Type => Instance_Sets.Value_Type,
      Iterator => Instance_Sets.Constant_Iterator,
      Distance_Type_Operations => Instance_Sets.Distance_Type_Operations,
      Iterator_Category => Instance_Sets.Iterator_Category,
      Inc => Instance_Sets.Inc,
      "=" => Instance_Sets."=",
      Val => Instance_Sets.Val);

   package Set_Input_Constant_Iterators is new SGL.Input_Iterators
     (Value_Type => Instance_Sets.Value_Type,
      Iterator => Instance_Sets.Constant_Iterator,
      Distance_Type_Operations => Instance_Sets.Distance_Type_Operations,
      Iterator_Category => Instance_Sets.Iterator_Category,
      Inc => Instance_Sets.Inc,
      "=" => Instance_Sets."=",
      Val => Instance_Sets.Val);

   -- Forward

   package Set_Forward_Constant_Iterators is
     new SGL.Forward_Constant_Iterators
     (Value_Type => Instance_Sets.Value_Type,
      Constant_Iterator => Instance_Sets.Constant_Iterator,
      Constant_Pointer => Instance_Sets.Constant_Pointer,
      Distance_Type_Operations => Instance_Sets.Distance_Type_Operations,
      Iterator_Category => Instance_Sets.Iterator_Category,
      Inc => Instance_Sets.Inc,
      Next => Instance_Sets.Next,
      "=" => Instance_Sets."=",
      Val => Instance_Sets.Val,
      Ref => Instance_Sets.Ref);

   -- Bidirectional

   package Set_Bidirectional_Constant_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type => Instance_Sets.Value_Type,
      Constant_Iterator => Instance_Sets.Constant_Iterator,
      Constant_Pointer => Instance_Sets.Constant_Pointer,
      Distance_Type_Operations => Instance_Sets.Distance_Type_Operations,
      Iterator_Category => Instance_Sets.Iterator_Category,
      Inc => Instance_Sets.Inc,
      Next => Instance_Sets.Next,
      Dec => Instance_Sets.Dec,
      Prev => Instance_Sets.Prev,
      "=" => Instance_Sets."=",
      Val => Instance_Sets.Val,
      Ref => Instance_Sets.Ref);

   -- Instantiate container signature

-- XXX The overloadings of Start, Finish prevent named associations
--     package Set_Containers is new SGL.Containers
--       (Container => Instance_Sets.Set,
--        Container_Pointer => Instance_Sets.Set_Pointer,
--        Container_Constant_Pointer => Instance_Sets.Set_Constant_Pointer,
--        Input_Iterators => Set_Input_Iterators,
--        Constant_Iterator_GNAT => Instance_Sets.Constant_Iterator,
--        Size_Type_Operations => Instance_Sets.Size_Type_Operations,
--        Difference_Type_Operations => Instance_Sets.Difference_Type_Operations,
--        Iterator_Category_GNAT => Instance_Sets.Iterator_Category,
--        Verify_Tag => Instance_Sets.Verify_Tag,
--        Start => Instance_Sets.Start,
--        Start => Instance_Sets.Start,
--        Finish => Instance_Sets.Finish,
--        Finish => Instance_Sets.Finish,
--        Size => Instance_Sets.Size,
--        Max_Size => Instance_Sets.Max_Size,
--        Empty => Instance_Sets.Empty,
--        Swap => Instance_Sets.Swap);

    package Set_Containers is new SGL.Containers
      (Instance_Sets.Set,
       Instance_Sets.Set_Pointer,
       Instance_Sets.Set_Constant_Pointer,
       Set_Input_Iterators,
       Instance_Sets.Constant_Iterator,
       Instance_Sets.Size_Type_Operations,
       Instance_Sets.Difference_Type_Operations,
       Instance_Sets.Iterator_Category,
       Instance_Sets.Verify_Tag,
       Instance_Sets.Start,
       Instance_Sets.Start,
       Instance_Sets.Finish,
       Instance_Sets.Finish,
       Instance_Sets.Size,
       Instance_Sets.Max_Size,
       Instance_Sets.Empty,
       Instance_Sets.Swap);

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
