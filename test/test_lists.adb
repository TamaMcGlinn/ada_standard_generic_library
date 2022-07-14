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

with Gnat.IO; use Gnat.IO;

with SGL.Basic_Algorithms;
with SGL.Algorithms;
with SGL.Output_Iterators;

with Int_Lists;
with Int_List_Signatures;
with Integer_Ostream_Iterators;
with Test_Assert;

procedure Test_Lists is
   -- use clauses
   use Int_Lists;
   use Int_Lists.Size_Type_Operations;
   use Int_List_Signatures.List_Reverse_Bidirectional_Iterators;
   use Int_List_Signatures.List_Reverse_Bidirectional_Iterator_Operations;

   package Int_List_Sequence_Operations is
      new Int_Lists.Sequence_Operations;
   use Int_List_Sequence_Operations;

   package Int_List_Input_Constant_Iterators renames
     Int_List_Signatures.List_Input_Constant_Iterators;

   package Int_List_Input_Constant_RIterators
     renames Int_List_Signatures.List_Input_Constant_RIterators;

   package Int_List_Output_Iterators renames
     Int_List_Signatures.List_Output_Iterators;

   -- Generic algorithm instantiations

   function Find is new SGL.Algorithms.Find
     (Int_List_Signatures.List_Input_Constant_Iterators);

   function Find is new SGL.Algorithms.Find
     (Int_List_Input_Constant_RIterators);

   procedure Bidirectional_Reverse is new
     SGL.Algorithms.Bidirectional_Reverse
     (Int_List_Signatures.List_Bidirectional_Iterators,
      Int_Lists.Verify_Tag);

   function Copy is new SGL.Basic_Algorithms.Copy
     (Int_List_Input_Constant_Iterators,
      Integer_Ostream_Iterators.Output_Iterators);

   -- Local variables

   A, B : aliased Int_Lists.List;
   R : Int_List_Signatures.List_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator;
   StdOut : Integer_Ostream_Iterators.Ostream_Iterators.Iterator;

begin
   Put_Line("*** Welcome to Test_Lists $RCSfile: test_lists.adb,v $ $Revision: 2.1 $ ***"); New_Line;

   -- A = {}, B = {}
   Test_Assert("Checking empty list properties ... ",
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
                 (Val(Next(Start(A))) = 2) ));

   Pop_Back(A);
   -- A = {1}, B = {}
   Test_Assert("Checking A contents after popping back (value 2) ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 1) and then
                 (A = A) and then
                 (A /= B)  and then
                 (Val(Start(A)) = 1) ));

   Pop_Back(A);
   -- A = {},  B = {}
   Test_Assert("Checking A contents after popping back last value (1) ... ",
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
                 (Size(A) = 100000) and then
                 (not Empty(A)) and then
                 (Val(Start(A)) = 1) and then
                 (Val(Next(Start(A))) = 2) and then
                 (Val(Prev(Finish(A))) = 100000) and then
                 (A /= B) ));

   -- A = {1 ... 100000}, B = {}
   Test_Assert("Running Find on A ... ",
               ( (Find(Start(A), Finish(A), 1) /= Finish(A)) and then
                 (Val(Find(Start(A), Finish(A), 1)) = 1) and then
                 (Find(Start(A), Finish(A), 100000) /= Finish(A)) and then
                 (Val(Find(Start(A), Finish(A), 100000)) = 100000) and then
                 (Find(Start(A), Finish(A), 200000) = Finish(A)) ));

  -- A = {1 ... 100000}, B = {}
   R := Find(RStart(A), RFinish(A), 55);
   Test_Assert("Running Find(Reverse_Iterator) on A looking for 55 ... ",
               ( (R /= RFinish(A)) and then
                 (Val(R) = 55) ));


   for I in 1..100000 loop
      if ( Val(Start(A)) /= I ) then
         Test_Assert("Unexpected value poped (Front) ... ", False);
      end if;
      Pop_Front(A);
   end loop;

   -- A = {},  B = {}
   Test_Assert("Checking A after popping (Front) all values ... ",
               ( (Start(A) = Finish(A)) and then
                 Empty(A) and then
                 (Size(A) = 0) and then
                 (A = A) and then
                 (A = B) ));


   for I in reverse 1..5 loop
      Push_Front(A, I);
   end loop;
   -- A={1 2 3 4 5}, B={}
   Test_Assert("Checking A after inserting 1,2,3,4,5 (push front) ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 5) and then
                 (A = A) and then
                 (A /= B) and then
                 (Val(Start(A)) = 1) and then
                 (Val(Prev(Finish(A))) = 5) ));

   Put("A = ");
   StdOut := Copy(Start(A), Finish(A), StdOut);
   New_Line;

   B := A;
   -- A={1 2 3 4 5}, B={1 2 3 4 5}
   Test_Assert("Checking B after B := A = {1,2,3,4,5} ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 5) and then
                 (A = A) and then
                 (Val(Start(A)) = 1) and then
                 (Val(Prev(Finish(A))) = 5) and then
                 (A = B) and then
                 (Start(B) /= Finish(B)) and then
                 (not Empty(B)) and then
                 (Size(B) = 5) and then
                 (A = A) and then
                 (Val(Start(B)) = 1) and then
                 (Val(Prev(Finish(B))) = 5) ));


   Erase(B, Start(B'Unchecked_Access), Finish(B'Unchecked_Access));
   -- A={1 2 3 4 5}, B={}
   Test_Assert("Checking empty list properties after Erase(B)... ",
                ( (Start(B) = Finish(B)) and then
                  Empty(B) and then
                  (Size(B) = 0) and then
                  (B = B) and then
                  (A /= B) ));

   Bidirectional_Reverse(Start(A'Unchecked_Access),
                         Finish(A'Unchecked_Access));

   -- A={5 4 3 2 1}, B={}
   Test_Assert("Checking A after applying bidirectional reverse ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 5) and then
                 (A = A) and then
                 (A /= B) and then
                 (Val(Start(A)) = 5) and then
                 (Val(Prev(Finish(A))) = 1) ));

   Put("A = ");
   StdOut := Copy(Start(A), Finish(A), StdOut);
   New_Line;

   Sort(A);
   Sort(B);
   -- A={1 2 3 4 5}, B={}
   Test_Assert("Checking A and B after sorting ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 5) and then
                 (A = A) and then
                 (A /= B) and then
                 (Val(Start(A)) = 1) and then
                 (Val(Prev(Finish(A))) = 5) and then
                 (Start(B) = Finish(B)) and then
                 (Empty(B)) ));

   B := A;
   Push_Back(A, 6);
   Push_Back(B, 7);
   -- A = {1 2 3 4 5 6}, B = {1 2 3 4 5 6 7}
   Test_Assert("Checking Sequence Operations on A and B ... ",
               ( (A < B) and then
                 (not (B < A)) and then
                 (B > A) and then
                 (Not (A > B)) and then
                 (A <= B) and then
                 (not (B <= A)) and then
                 (B >= A) and then
                 (not (A >= B)) ));

   New_Line; Put("*** End of Test_Lists $RCSfile: test_lists.adb,v $ $Revision: 2.1 $ ***"); New_Line;
end Test_Lists;
