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
--  $Id: test_container_signatures.adb,v 2.1 1997/07/12 00:40:37 akonstan Exp $
--

with SGL.Containers;
with SGL.Forward_Containers;
with SGL.Sequence_Containers;
with SGL.Back_Insertion_Sequence_Containers;
with SGL.Front_Insertion_Sequence_Containers;
with SGL.Reversible_Containers;
with SGL.Random_Access_Containers;

with Int_Vectors;
with Int_Vector_Signatures;

with Int_Lists;
with Int_List_Signatures;

procedure Test_Container_Signatures is

   package Int_Vector_Sequence_Operations is
      new Int_Vectors.Sequence_Operations("<");

   use Int_Vectors;
   use Int_Vector_Signatures;
   use Int_Vector_Sequence_Operations;

   use Int_Lists;
   use Int_List_Signatures;

   package Vector_Containers is new SGL.Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer, Vector_Input_Iterators,
      Int_Vectors.Constant_Iterator, Int_Vectors.Size_Type_Operations,
      Int_Vectors.Difference_Type_Operations,
      Int_Vectors.Iterator_Category, Int_Vectors.Verify_Tag);

   package Vector_Forward_Containers is new SGL.Forward_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Forward_Iterators, Int_Vectors.Size_Type_Operations,
      Int_Vectors.Difference_Type_Operations, Int_Vectors.Iterator_Category,
      Int_Vectors.Verify_Tag);

   package Vector_Sequence_Containers is new SGL.Sequence_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Forward_Iterators, Int_Vectors.Size_Type_Operations,
      Int_Vectors.Difference_Type_Operations, Int_Vectors.Iterator_Category,
      Int_Vectors.Verify_Tag);

   package Vector_Back_Insertion_Sequence_Containers is
     new SGL.Back_Insertion_Sequence_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Forward_Iterators, Int_Vectors.Size_Type_Operations,
      Int_Vectors.Difference_Type_Operations, Int_Vectors.Iterator_Category,
      Int_Vectors.Verify_Tag);

   package List_Front_Insertion_Sequence_Containers is
     new SGL.Front_Insertion_Sequence_Containers
     (List, List_Pointer, List_Constant_Pointer,
      List_Forward_Iterators, Int_Lists.Size_Type_Operations,
      Int_Lists.Difference_Type_Operations, Int_Lists.Iterator_Category,
      Int_Lists.Verify_Tag);

   use Int_Vector_Signatures.Vector_Reverse_Bidirectional_Iterator_Operations;
   use Int_Vector_Signatures.Vector_Reverse_Random_Access_Iterator_Operations;

   package Vector_Reversible_Containers is new SGL.Reversible_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Bidirectional_Iterators, Vector_Bidirectional_RIterators,
      Int_Vectors.Size_Type_Operations, Int_Vectors.Difference_Type_Operations,
      Int_Vectors.Iterator_Category, Int_Vectors.Verify_Tag);

   package Vector_Random_Access_Containers is new SGL.Random_Access_Containers
     (Vector, Vector_Pointer, Vector_Constant_Pointer,
      Vector_Random_Access_Iterators, Vector_Random_Access_RA_RIterators,
      Int_Vectors.Size_Type_Operations, Int_Vectors.Difference_Type_Operations,
      Int_Vectors.Iterator_Category, Int_Vectors.Verify_Tag);

begin
   null;
end Test_Container_Signatures;
