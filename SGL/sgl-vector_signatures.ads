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
--  $Id: sgl-vector_signatures.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--
--  Instantiates every signature imaginable !  For demonstration and testing
--  purposes only since it slows down compilation.  May be removed from SGL.
--

with SGL;
with SGL.Vectors;

with SGL.Containers;
with SGL.Forward_Containers;
with SGL.Sequence_Containers;
with SGL.Back_Insertion_Sequence_Containers;
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
with SGL.Random_Access_Iterators;
with SGL.Random_Access_Constant_Iterators;
with SGL.Reverse_Bidirectional_Iterators;
with SGL.Reverse_Random_Access_Iterators;

generic
   with package Instance_Vectors is new SGL.Vectors(<>);

package SGL.Vector_Signatures is
   use Instance_Vectors;

   -- Input

   package Vector_Input_Iterators is new SGL.Input_Iterators
     (Value_Type, Iterator, Distance_Type_Operations, Iterator_Category);

   package Vector_Input_Constant_Iterators is new SGL.Input_Iterators
     (Value_Type, Constant_Iterator, Distance_Type_Operations,
      Iterator_Category);

   -- Output

   package Vector_Output_Iterators is new SGL.Output_Iterators
     (Value_Type, Assign, Iterator, Distance_Type_Operations,
      Iterator_Category);

   -- Forward

   package Vector_Forward_Iterators is new SGL.Forward_Iterators
     (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
      Constant_Pointer, Distance_Type_Operations, Iterator_Category);

   package Vector_Forward_Constant_Iterators is
     new SGL.Forward_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   package Vector_Forward_Restricted_Iterators is
     new SGL.Forward_Constant_Iterators
     (Value_Type, Iterator, Pointer, Distance_Type_Operations,
      Iterator_Category);

   -- Bidirectional

   package Vector_Bidirectional_Iterators is new SGL.Bidirectional_Iterators
     (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
      Constant_Pointer, Distance_Type_Operations, Iterator_Category);

   package Vector_Bidirectional_Constant_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   package Vector_Bidirectional_Restricted_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   -- Random Access

   package Vector_Random_Access_Iterators is new SGL.Random_Access_Iterators
     (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
      Constant_Pointer, Distance_Type_Operations, Iterator_Category);

   package Vector_Random_Access_Constant_Iterators is
     new SGL.Random_Access_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   package Vector_Random_Access_Restricted_Iterators is
     new SGL.Random_Access_Constant_Iterators
     (Value_Type, Iterator, Pointer, Distance_Type_Operations,
      Iterator_Category);

   -- Instantiate container signature

   package Vector_Containers is new SGL.Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer, Vector_Input_Iterators,
      Constant_Iterator, Size_Type_Operations, Difference_Type_Operations,
      Iterator_Category, Verify_Tag);

   package Vector_Forward_Containers is new SGL.Forward_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Forward_Iterators, Size_Type_Operations,
      Difference_Type_Operations, Iterator_Category,
      Verify_Tag);

   package Vector_Sequence_Containers is new SGL.Sequence_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Forward_Iterators, Size_Type_Operations,
      Difference_Type_Operations, Iterator_Category,
      Verify_Tag);

   package Vector_Back_Insertion_Sequence_Containers is
     new SGL.Back_Insertion_Sequence_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Forward_Iterators, Size_Type_Operations,
      Difference_Type_Operations, Iterator_Category,
      Verify_Tag);

   -- Reverse Iterators

   package Vector_Reverse_Bidirectional_Iterators is
     new SGL.Reverse_Bidirectional_Iterators(Vector_Bidirectional_Iterators);

   package Vector_Reverse_Random_Access_Iterators is
     new SGL.Reverse_Random_Access_Iterators(Vector_Random_Access_Iterators);

   -- Instantiate iterator signature packages with Reverse Iterators

   use Vector_Reverse_Bidirectional_Iterators;
   use Vector_Reverse_Random_Access_Iterators;

   -- Input Reverse Bidirectional Iterators

   package Vector_Input_RIterators is new SGL.Input_Iterators
     (Vector_Reverse_Bidirectional_Iterators.Value_Type,
      Vector_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category);

   package Vector_Input_Constant_RIterators is new SGL.Input_Iterators
     (Vector_Reverse_Bidirectional_Iterators.Value_Type,
      Vector_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category);

   -- Output Reverse Bidirectional Iterators

   package Vector_Output_RIterators is new SGL.Output_Iterators
     (Vector_Reverse_Bidirectional_Iterators.Value_Type,
      Vector_Reverse_Bidirectional_Iterators.Assign,
      Vector_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category);

   -- Forward Reverse Bidirectional Iterators

   package Vector_Forward_RIterators is new SGL.Forward_Iterators
     (Vector_Reverse_Bidirectional_Iterators.Value_Type,
      Vector_Reverse_Bidirectional_Iterators.Assign,
      Vector_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Pointer,
      Vector_Reverse_Bidirectional_Iterators.Constant_Pointer,
      Vector_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category);

   package Vector_Forward_Constant_RIterators is
     new SGL.Forward_Constant_Iterators
     (Vector_Reverse_Bidirectional_Iterators.Value_Type,
      Vector_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Constant_Pointer,
      Vector_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category);

   package Vector_Forward_Restricted_RIterators is
     new SGL.Forward_Constant_Iterators
     (Vector_Reverse_Bidirectional_Iterators.Value_Type,
      Vector_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Pointer,
      Vector_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category);

   -- Bidirectional Reverse Bidirectional Iterators

   package Vector_Bidirectional_RIterators is new SGL.Bidirectional_Iterators
     (Vector_Reverse_Bidirectional_Iterators.Value_Type,
      Vector_Reverse_Bidirectional_Iterators.Assign,
      Vector_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Pointer,
      Vector_Reverse_Bidirectional_Iterators.Constant_Pointer,
      Vector_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category);

   package Vector_Bidirectional_Constant_RIterators is
     new SGL.Bidirectional_Constant_Iterators
     (Vector_Reverse_Bidirectional_Iterators.Value_Type,
      Vector_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Constant_Pointer,
      Vector_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category);

   package Vector_Bidirectional_Restricted_RIterators is
     new SGL.Bidirectional_Constant_Iterators
     (Vector_Reverse_Bidirectional_Iterators.Value_Type,
      Vector_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Pointer,
      Vector_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category);

   --
   --
   --

   -- Input Reverse Random Access Iterators

   package Vector_Input_RA_RIterators is new SGL.Input_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   package Vector_Input_Constant_RA_RIterators is new SGL.Input_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   -- Output Reverse Random Access Iterators

   package Vector_Output_RA_RIterators is new SGL.Output_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Assign,
      Vector_Reverse_Random_Access_Iterators.Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   -- Forward Reverse Random Access Iterators

   package Vector_Forward_RA_RIterators is new SGL.Forward_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Assign,
      Vector_Reverse_Random_Access_Iterators.Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Pointer,
      Vector_Reverse_Random_Access_Iterators.Constant_Pointer,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   package Vector_Forward_Constant_RA_RIterators is
     new SGL.Forward_Constant_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Constant_Pointer,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   package Vector_Forward_Restricted_RA_RIterators is
     new SGL.Forward_Constant_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Pointer,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   -- Bidirectional Reverse Random Access Iterators

   package Vector_Bidirectional_RA_RIterators is
     new SGL.Bidirectional_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Assign,
      Vector_Reverse_Random_Access_Iterators.Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Pointer,
      Vector_Reverse_Random_Access_Iterators.Constant_Pointer,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   package Vector_Bidirectional_Constant_RA_RIterators is
     new SGL.Bidirectional_Constant_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Constant_Pointer,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   package Vector_Bidirectional_Restricted_RA_RIterators is
     new SGL.Bidirectional_Constant_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Pointer,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   -- Random Access Reverse Random Access Iterators

   package Vector_Random_Access_RA_RIterators is
     new SGL.Random_Access_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Assign,
      Vector_Reverse_Random_Access_Iterators.Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Pointer,
      Vector_Reverse_Random_Access_Iterators.Constant_Pointer,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   package Vector_Random_Access_Constant_RA_RIterators is
     new SGL.Random_Access_Constant_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Constant_Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Constant_Pointer,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   package Vector_Random_Access_Restricted_RA_RIterators is
     new SGL.Random_Access_Constant_Iterators
     (Vector_Reverse_Random_Access_Iterators.Value_Type,
      Vector_Reverse_Random_Access_Iterators.Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Pointer,
      Vector_Reverse_Random_Access_Iterators.Distance_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category);

   -- Instantiate Reverse Iterators operations (RStart, RFinish) ...

   function Identity is new SGL.Function_Adaptors.Identity
     (Vector_Containers.Iterator);
   function Identity is new SGL.Function_Adaptors.Identity
     (Vector_Containers.Constant_Iterator);

   package Vector_Reverse_Bidirectional_Iterator_Operations is
     new SGL.Reverse_Iterator_Operations
     (Vector_Containers,
      Vector_Reverse_Bidirectional_Iterators.Reverse_Iterator,
      Vector_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator);

   package Vector_Reverse_Random_Access_Iterator_Operations is
     new SGL.Reverse_Iterator_Operations
     (Vector_Containers,
      Vector_Reverse_Random_Access_Iterators.Reverse_Iterator,
      Vector_Reverse_Random_Access_Iterators.Constant_Reverse_Iterator);

   use Vector_Reverse_Bidirectional_Iterator_Operations;
   use Vector_Reverse_Random_Access_Iterator_Operations;

   -- Reversible based container signatures

   package Vector_Reversible_Containers is new SGL.Reversible_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Bidirectional_Iterators, Vector_Bidirectional_RIterators,
      Instance_Vectors.Size_Type_Operations,
      Instance_Vectors.Difference_Type_Operations,
      Vector_Reverse_Bidirectional_Iterators.Iterator_Category, Verify_Tag);

   package Vector_Random_Access_Containers is new SGL.Random_Access_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Random_Access_Iterators, Vector_Random_Access_RA_RIterators,
      Instance_Vectors.Size_Type_Operations,
      Instance_Vectors.Difference_Type_Operations,
      Vector_Reverse_Random_Access_Iterators.Iterator_Category, Verify_Tag);


end SGL.Vector_Signatures;
