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

--  Instantiates every signature imaginable !  For demonstration and testing
--  purposes only since it slows down compilation.  May be removed from SGL.
--

with SGL;
with SGL.Lists;

with SGL.Containers;
with SGL.Forward_Containers;
with SGL.Sequence_Containers;
with SGL.Back_Insertion_Sequence_Containers;
with SGL.Front_Insertion_Sequence_Containers;
with SGL.Reversible_Containers;
with SGL.Random_Access_Containers;

with SGL.Reverse_Iterator_Operations;
with SGL.Function_Adaptors;
with SGL.Input_Iterators;
with SGL.Output_Iterators;
with SGL.Forward_Iterators;
with SGL.Forward_Constant_Iterators;
with SGL.Bidirectional_Iterators;
with SGL.Bidirectional_Constant_Iterators;
with SGL.Reverse_Bidirectional_Iterators;

generic
   with package Instance_Lists is new SGL.Lists(<>);

package SGL.List_Signatures is
   use Instance_Lists;

   -- Input

   package List_Input_Iterators is new SGL.Input_Iterators
     (Value_Type, Iterator, Distance_Type_Operations, Iterator_Category);

   package List_Input_Constant_Iterators is new SGL.Input_Iterators
     (Value_Type, Constant_Iterator, Distance_Type_Operations,
      Iterator_Category);

   -- Output

   package List_Output_Iterators is new SGL.Output_Iterators
     (Value_Type, Assign, Iterator, Distance_Type_Operations,
      Iterator_Category);

   -- Forward

   package List_Forward_Iterators is new SGL.Forward_Iterators
     (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
      Constant_Pointer, Distance_Type_Operations, Iterator_Category);

   package List_Forward_Constant_Iterators is
     new SGL.Forward_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   package List_Forward_Restricted_Iterators is
     new SGL.Forward_Constant_Iterators
     (Value_Type, Iterator, Pointer, Distance_Type_Operations,
      Iterator_Category);

   -- Bidirectional

   package List_Bidirectional_Iterators is new SGL.Bidirectional_Iterators
     (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
      Constant_Pointer, Distance_Type_Operations, Iterator_Category);

   package List_Bidirectional_Constant_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   package List_Bidirectional_Restricted_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);


   -- Instantiate container signature

   package List_Containers is new SGL.Containers
     (List, List_Pointer, List_Constant_Pointer, List_Input_Iterators,
      Constant_Iterator, Size_Type_Operations, Difference_Type_Operations,
      Iterator_Category, Verify_Tag);

   package List_Forward_Containers is new SGL.Forward_Containers
     (List, List_Pointer, List_Constant_Pointer,
      List_Forward_Iterators, Size_Type_Operations,
      Difference_Type_Operations, Iterator_Category,
      Verify_Tag);

   package List_Sequence_Containers is new SGL.Sequence_Containers
     (List, List_Pointer, List_Constant_Pointer,
      List_Forward_Iterators, Size_Type_Operations,
      Difference_Type_Operations, Iterator_Category,
      Verify_Tag);

   package List_Back_Insertion_Sequence_Containers is
     new SGL.Back_Insertion_Sequence_Containers
     (List, List_Pointer, List_Constant_Pointer,
      List_Forward_Iterators, Size_Type_Operations,
      Difference_Type_Operations, Iterator_Category,
      Verify_Tag);

   package List_Front_Insertion_Sequence_Containers is
     new SGL.Front_Insertion_Sequence_Containers
     (List, List_Pointer, List_Constant_Pointer,
      List_Forward_Iterators, Size_Type_Operations,
      Difference_Type_Operations, Iterator_Category,
      Verify_Tag);

   -- Reverse Iterators

   package List_Reverse_Bidirectional_Iterators is
     new SGL.Reverse_Bidirectional_Iterators(List_Bidirectional_Iterators);

   -- Instantiate iterator signature packages with Reverse Iterators

   use List_Reverse_Bidirectional_Iterators;

   -- Input Reverse Bidirectional Iterators

   package List_Input_RIterators is new SGL.Input_Iterators
     (List_Reverse_Bidirectional_Iterators.Value_Type,
      List_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category);

   package List_Input_Constant_RIterators is new SGL.Input_Iterators
     (List_Reverse_Bidirectional_Iterators.Value_Type,
      List_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category);

   -- Output Reverse Bidirectional Iterators

   package List_Output_RIterators is new SGL.Output_Iterators
     (List_Reverse_Bidirectional_Iterators.Value_Type,
      List_Reverse_Bidirectional_Iterators.Assign,
      List_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category);

   -- Forward Reverse Bidirectional Iterators

   package List_Forward_RIterators is new SGL.Forward_Iterators
     (List_Reverse_Bidirectional_Iterators.Value_Type,
      List_Reverse_Bidirectional_Iterators.Assign,
      List_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Pointer,
      List_Reverse_Bidirectional_Iterators.Constant_Pointer,
      List_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category);

   package List_Forward_Constant_RIterators is
     new SGL.Forward_Constant_Iterators
     (List_Reverse_Bidirectional_Iterators.Value_Type,
      List_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Constant_Pointer,
      List_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category);

   package List_Forward_Restricted_RIterators is
     new SGL.Forward_Constant_Iterators
     (List_Reverse_Bidirectional_Iterators.Value_Type,
      List_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Pointer,
      List_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category);

   -- Bidirectional Reverse Bidirectional Iterators

   package List_Bidirectional_RIterators is new SGL.Bidirectional_Iterators
     (List_Reverse_Bidirectional_Iterators.Value_Type,
      List_Reverse_Bidirectional_Iterators.Assign,
      List_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Pointer,
      List_Reverse_Bidirectional_Iterators.Constant_Pointer,
      List_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category);

   package List_Bidirectional_Constant_RIterators is
     new SGL.Bidirectional_Constant_Iterators
     (List_Reverse_Bidirectional_Iterators.Value_Type,
      List_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Constant_Pointer,
      List_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category);

   package List_Bidirectional_Restricted_RIterators is
     new SGL.Bidirectional_Constant_Iterators
     (List_Reverse_Bidirectional_Iterators.Value_Type,
      List_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Pointer,
      List_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category);

   -- Instantiate Reverse Iterators operations (RStart, RFinish) ...

   function Identity is new SGL.Function_Adaptors.Identity
     (List_Containers.Iterator);
   function Identity is new SGL.Function_Adaptors.Identity
     (List_Containers.Constant_Iterator);

   package List_Reverse_Bidirectional_Iterator_Operations is
     new SGL.Reverse_Iterator_Operations
     (List_Containers,
      List_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      List_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator);

   -- Instantiate the remaining container signatures

   use List_Reverse_Bidirectional_Iterator_Operations;

   package List_Reversible_Containers is new SGL.Reversible_Containers
     (List, List_Pointer, List_Constant_Pointer,
      List_Bidirectional_Iterators, List_Bidirectional_RIterators,
      Instance_Lists.Size_Type_Operations,
      Instance_Lists.Difference_Type_Operations,
      List_Reverse_Bidirectional_Iterators.Iterator_Category,
      Verify_Tag);


end SGL.List_Signatures;
