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
--  $Id: test_vectors.adb,v 2.1 1997/07/12 00:40:37 akonstan Exp $
--

with Gnat.IO; use Gnat.IO;

with SGL.Algorithms;

with Int_Vectors;
with Int_Vector_Signatures;
with Test_Assert;

procedure Test_Vectors is
   -- use clauses

   use Int_Vectors;
   use Int_Vectors.Size_Type_Operations;
   use Int_Vector_Signatures.Vector_Reverse_Random_Access_Iterators;
   use Int_Vector_Signatures.Vector_Reverse_Random_Access_Iterator_Operations;

   package Int_Vector_Input_Iterators
     renames Int_Vector_Signatures.Vector_Input_Iterators;
   package Int_Vector_Input_Constant_Iterators
     renames Int_Vector_Signatures.Vector_Input_Constant_Iterators;
   package Int_Vector_Input_Constant_RIterators
     renames Int_Vector_Signatures.Vector_Input_Constant_RA_RIterators;

   package Int_Vector_Sequence_Operations is
      new Int_Vectors.Sequence_Operations("<");
   use Int_Vector_Sequence_Operations;

   -- Local variables
   A, B : aliased Vector;
   I : Int_Vectors.Iterator;
   C : Int_Vectors.Constant_Iterator;
   R : Constant_Reverse_Iterator;

   -- Generic function instantiations
   function Find is new SGL.Algorithms.Find
     (Int_Vector_Input_Constant_Iterators);
   function Find is new SGL.Algorithms.Find
     (Int_Vector_Input_Iterators);
   function Find is new SGL.Algorithms.Find
     (Int_Vector_Input_Constant_RIterators);

begin
   Put_Line("*** Welcome to Test_Vectors $RCSfile: test_vectors.adb,v $ $Revision: 2.1 $ ***"); New_Line;

   -- A = {}, B = {}
   Test_Assert("Checking empty vector properties ... ",
                ( (Start(A) = Finish(A)) and then
                  Empty(A) and then
                  (Size(A) = 0) and then
                  (A = A) and then
                  (A = B) ));

   Push_Back(A, 1);
   Push_Back(A, 2);
   -- A = {1, 2}, B = {}
   Test_Assert("Checking A contents after pushing values 1 and 2 ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 2) and then
                 (A = A) and then
                 (A /= B) and then
                 (Val(Start(A)) = 1) and then
                 (Val(Start(A) + 1) = 2) ));

   -- A = {1, 2}, B = {}
   Test_Assert("Checking contents of A using reverse iterators ... ",
               ( (RStart(A) /= RFinish(A)) and then
                 (Val(RStart(A)) = 2) and then
                 (Val(Prev(RFinish(A))) = 1) ));

   Pop_Back(A);
   -- A = {1}, B = {}
   Test_Assert("Checking A contents after popping (value 2) ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 1) and then
                 (A = A) and then
                 (A /= B)  and then
                 (Val(Start(A)) = 1) ));

   Pop_Back(A);
   -- A = {},  B = {}
   Test_Assert("Checking A contents after popping last value (1) ... ",
               ( (Start(A) = Finish(A)) and then
                 Empty(A) and then
                 (Size(A) = 0) and then
                 (A = A) and then
                 (A = B) ));

   for I in 1..100000 loop
      Push_Back(A, I);
   end loop;
   -- A = {1 ... 100000}, B = {}
   Test_Assert("Checking A after pushing 1..100000 ... ",
               ( (Start(A) /= Finish(A)) and then
                 (Finish(A) > Start(A)) and then
                 (Start (A) < Finish(A)) and then
                 (Size(A) = 100000) and then
                 (not Empty(A)) and then
                 (Val(Start(A)) = 1) and then
                 (Val(Start(A) + 1) = 2) and then
                 (Val(Finish(A) - 1) = 100000) and then
                 (A /= B) ));

   -- A = {1 ... 100000}, B = {}
   Test_Assert("Running Find(Constant) on A looking for 1,100000,200000 ... ",
               ( (Find(Start(A), Finish(A), 1) /= Finish(A)) and then
                 (Val(Find(Start(A), Finish(A), 1)) = 1) and then
                 (Find(Start(A), Finish(A), 100000) /= Finish(A)) and then
                 (Val(Find(Start(A), Finish(A), 100000)) = 100000) and then
                 (Find(Start(A), Finish(A), 200000) = Finish(A)) ));

   -- A = {1 ... 100000}, B = {}
   I := Find(Start(A'Unchecked_Access), Finish(A'Unchecked_Access), 55);
   C := Find(Start(A), Finish(A), 55);
   Test_Assert("Running Find(Constant) and Find(Mutating) on A looking for 55 ... ",
               ( (I /= Finish(A'Unchecked_Access)) and then
                 (C /= Finish(A)) and then
                 (Val(I) = 55) and then
                 (Val(C) = 55) and then
                 (Make_Constant(I) = C) ));

   -- A = {1 ... 100000}, B = {}
   R := Find(RStart(A), RFinish(A), 55);
   Test_Assert("Running Find(Reverse_Iterator) on A looking for 55 ... ",
               ( (R /= RFinish(A)) and then
                 (Val(R) = 55) ));


   for N in reverse 1..100000 loop
      if ( Value(A, Size_Type'Val(N-1) ) /= N ) then
         Test_Assert("Unexpected value in array ... ", False);
      end if;
      if ( Val(Finish(A) - 1) /= N ) then
         Test_Assert("Unexpected value poped ... ", False);
      end if;
      Pop_Back(A);
   end loop;

   -- A = {},  B = {}
   Test_Assert("Checking A after popping all values ... ",
               ( (Start(A) = Finish(A)) and then
                 Empty(A) and then
                 (Size(A) = 0) and then
                 (A = A) and then
                 (A = B) ));

   Push_Back(A, 1);
   Push_Back(A, 2);
   B := A;
   Push_Back(A, 3);
   Push_Back(B, 4);
   -- A = {1 2 3}, B = {1 2 4}
   Test_Assert("Checking Sequence Operations on A={1 2 3}, B={1 2 4} ... ",
               ( (A < B) and then
                 (not (B < A)) and then
                 (B > A) and then
                 (Not (A > B)) and then
                 (A <= B) and then
                 (not (B <= A)) and then
                 (B >= A) and then
                 (not (A >= B)) ));

   New_Line; Put("*** End $RCSfile: test_vectors.adb,v $ $Revision: 2.1 $ ***"); New_Line;

end Test_Vectors;
