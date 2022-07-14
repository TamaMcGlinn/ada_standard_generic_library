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

with SGL;
with SGL.Containers;

with Int_Vectors;
with Int_Vector_Stacks;
with Test_Assert;

procedure Test_Stacks is
   -- use clauses
   use Int_Vectors;
   use Int_Vector_Stacks;

   use Int_Vector_Stacks.Size_Type_Operations;

   -- Local variables
   A, B : Int_Vector_Stacks.Stack;

begin
   Put_Line("*** Welcome to Test_Stacks $RCSfile: test_stacks.adb,v $ $Revision: 2.1 $ ***"); New_Line;

   -- A = {}, B = {}
   Test_Assert("Checking empty Stack properties ... ",
                ( Empty(A) and then
                  (Size(A) = 0) and then
                  (A = A) and then
                  (A = B) ));

   Push(A, 1);
   Push(A, 2);
   -- A = {1, 2}, B = {}
   Test_Assert("Checking A contents after pushing values 1 and 2 ... ",
               ( (not Empty(A)) and then
                 (Size(A) = 2) and then
                 (A = A) and then
                 (A /= B) and then
                 (Top(A) = 2) ));

   Pop(A);
   -- A = {1}, B = {}
   Test_Assert("Checking A contents after popping (value 2) ... ",
               ( (not Empty(A)) and then
                 (Size(A) = 1) and then
                 (A = A) and then
                 (A /= B)  and then
                 (Top(A) = 1) ));

   Pop(A);
   -- A = {},  B = {}
   Test_Assert("Checking A contents after popping last value (1) ... ",
               ( Empty(A) and then
                 (Size(A) = 0) and then
                 (A = A) and then
                 (A = B) ));

   for I in 1..100000 loop
      Push(A, I);
   end loop;
   -- A = {1 ... 100000}, B = {}
   Test_Assert("Checking A after pushing 1..100000 ... ",
               ( (Size(A) = 100000) and then
                 (not Empty(A)) ));


   -- A = {1 ... 100000}, B = {}
   for I in reverse 1..100000 loop
      if ( Top(A) /= I ) then
         Test_Assert("Unexpected value poped ... ", False);
      end if;
      Pop(A);
   end loop;

   -- A = {},  B = {}
   Test_Assert("Checking A after popping all values ... ",
               ( Empty(A) and then
                 (Size(A) = 0) and then
                 (A = A) and then
                 (A = B) ));

   New_Line; Put("*** End of Test_Stacks $RCSfile: test_stacks.adb,v $ $Revision: 2.1 $ ***"); New_Line;
end Test_Stacks;
