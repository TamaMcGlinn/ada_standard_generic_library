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
with Int_Trees;
with Test_Assert;
with Int_Random;

procedure Test_Trees is
   use Int_Trees;
   use Int_Trees.Size_Type_Operations;

   A, B : aliased Tree;
   I    : Iterator;
   Success : Boolean;
   R : Int_Random.Generator;
begin

   Put_Line("*** Welcome to Test_Trees $RCSfile: test_trees.adb,v $ $Revision: 2.1 $ ***"); New_Line;

   -- A = {}, B = {}
   Test_Assert("Checking empty tree properties ... ",
                ( (Start(A) = Finish(A)) and then
                  Empty(A) and then
                  (Size(A) = 0) and then
                  (A = A) and then
                  (A = B) ));

   Insert(A, 1, I, Success);
   Insert(A, 2, I, Success);

   -- A = {1, 2}, B = {}
   Test_Assert("Checking A contents after inserting values 1 and 2 ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 2) and then
                 (A = A) and then
                 (A /= B) and then
                 (Val(Start(A)) = 1) and then
                 (Val(Next(Start(A))) = 2) ));

   Erase(A, Start(A'Unchecked_Access), Finish(A'Unchecked_Access));

   -- A= {}, B = {}
   Test_Assert("Checking empty tree properties after removing all values ... ",
                ( (Start(A) = Finish(A)) and then
                  Empty(A) and then
                  (Size(A) = 0) and then
                  (A = A) and then
                  (A = B) ));

   Int_Random.Reset(R);
   for Count in 1..10000 loop
      Insert(A, Int_Random.Random(R), I, Success);
   end loop;

   Test_Assert("Checking tree properties after inserting 10000 random values ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 10000) and then
                 (A = A) and then
                 (A /= B) ));


   Put("Checking order of values ... ");
   declare
      J : Constant_Iterator := Start(A);
      K : Integer := Val(Start(A));
   begin
      while(J /= Finish(A)) loop
         if (K > Val(J)) then
            Test_Assert("", False);
         end if;
         K := Val(J);
         Inc(J);
      end loop;
   end;
   Put_Line("OK");

   Erase(A, Start(A'Unchecked_Access), Finish(A'Unchecked_Access));

   -- A= {}, B = {}
   Test_Assert("Checking empty tree properties after removing all values ... ",
                ( (Start(A) = Finish(A)) and then
                  Empty(A) and then
                  (Size(A) = 0) and then
                  (A = A) and then
                  (A = B) ));

   Insert(A, 1, I, Success);
   declare
      I : Iterator := Start(A'Unchecked_Access);
   begin
      Assign(I, 2);
   end;

   -- A={2}, B = {}
   Test_Assert("Checking A contents after inserting value 1 and changing it to 2 ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 1) and then
                 (A = A) and then
                 (A /= B) and then
                 (Val(Start(A)) = 2) ));

   Put_Line("*** End of Test_Trees $RCSfile: test_trees.adb,v $ $Revision: 2.1 $ ***"); New_Line;


end Test_Trees;
