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
--  $Id: test_queues.adb,v 2.1 1997/07/12 00:40:37 akonstan Exp $
--

with Gnat.IO; use Gnat.IO;
with Int_Lists;
with Int_List_Queues;
with Test_Assert;

procedure Test_Queues is
   -- use clauses
   use Int_Lists;
   use Int_List_Queues;
   use Int_List_Queues.Size_Type_Operations;

   -- Local variables
   A, B : Int_List_Queues.Queue;

begin
   Put_Line("*** Welcome to Test_Queues $Ver$ ***"); New_Line;

   -- A = {}, B = {}
   Test_Assert("Checking empty Queue properties ... ",
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
                 (Front(A) = 1) and then
                 (Back(A) = 2) ));

   Pop(A);
   -- A = {2}, B = {}
   Test_Assert("Checking A contents after popping (value 1) ... ",
               ( (not Empty(A)) and then
                 (Size(A) = 1) and then
                 (A = A) and then
                 (A /= B)  and then
                 (Front(A) = 2) and then
                 (Back(A) = 2) ));

   Pop(A);
   -- A = {},  B = {}
   Test_Assert("Checking A contents after popping last value (2) ... ",
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
   for I in 1..100000 loop
      if ( Front(A) /= I ) then
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

end Test_Queues;
