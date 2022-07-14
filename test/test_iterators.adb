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

with Int_Lists;
with Int_List_Signatures;
with SGL.Iterator_Adaptors;
with SGL.Basic_Algorithms;
with SGL.Output_Iterators;
with SGL.Ostream_Iterators;
with Test_Assert;


procedure Test_Iterators is
   -- use clauses
   use Int_Lists;
   use Int_Lists.Size_Type_Operations;
   use SGL.Iterator_Adaptors;

   package Int_List_Input_Constant_Iterators renames
     Int_List_Signatures.List_Input_Constant_Iterators;

   package On_Front is new Front_Insert_Iterators
     (Int_List_Signatures.List_Front_Insertion_Sequence_Containers);

   package On_Front_Output is new
     SGL.Output_Iterators(On_Front.Value_Type,
                          On_Front.Assign,
                          On_Front.Iterator,
                          On_Front.Distance_Type_Operations,
                          On_Front.Iterator_Category,
                          On_Front.Inc,
                          On_Front.Assign);

   function Copy is new SGL.Basic_Algorithms.Copy
     (Int_List_Input_Constant_Iterators,  On_Front_Output);

   package On_Back is new Back_Insert_Iterators
     (Int_List_Signatures.List_Back_Insertion_Sequence_Containers);

   package On_Back_Output is new
     SGL.Output_Iterators(On_Back.Value_Type,
                          On_Back.Assign,
                          On_Back.Iterator,
                          On_Back.Distance_Type_Operations,
                          On_Back.Iterator_Category,
                          On_Back.Inc,
                          On_Back.Assign);

   function Copy is new SGL.Basic_Algorithms.Copy
     (Int_List_Input_Constant_Iterators, On_Back_Output);


   package In_Middle is new Insert_Iterators
     (Int_List_Signatures.List_Sequence_Containers);

   package In_Middle_Output is new
     SGL.Output_Iterators(In_Middle.Value_Type,
                          In_Middle.Assign,
                          In_Middle.Iterator,
                          In_Middle.Distance_Type_Operations,
                          In_Middle.Iterator_Category,
                          In_Middle.Inc,
                          In_Middle.Assign);

   function Copy is new SGL.Basic_Algorithms.Copy
     (Int_List_Input_Constant_Iterators, In_Middle_Output);

   -- Local variables

   A, B : aliased Int_Lists.List;
   H :  Int_Lists.Iterator;
   I :  On_Front.Iterator;
   J :  On_Back.Iterator;
   K :  In_Middle.Iterator;
begin

   Put_Line("*** Welcome to Test_Iterators $RCSfile: test_iterators.adb,v $ $Revision: 2.1 $ ***");
   New_Line;

   -- A = {}, B = {}
   Test_Assert("Checking empty list properties ... ",
                ( (Start(A) = Finish(A)) and then
                  Empty(A) and then
                  (Size(A) = 0) and then
                  (A = A) and then
                  (A = B) ));

   Push_Back(A, 1);
   Push_Back(A, 2);
   Push_Back(A, 3);
   Push_Back(A, 4);

   I := Copy(Start(A), Finish(A),
             On_Front.Make_Iterator(B'Unchecked_Access));

   J := Copy(Start(A), Finish(A),
             On_Back.Make_Iterator(B'Unchecked_Access));

   H := Start(B'Unchecked_Access);
   Inc(H);

   K := Copy(Start(A), Finish(A),
             In_Middle.Make_Iterator(B'Unchecked_Access, H));

   -- A = {1, 2, 3, 5}, B = {4, 4, 3, 2, 1, 3, 2, 1, 1, 2, 3, 4}
   Test_Assert("Checking Size(A) = 4 and Size(B) = 12 ... ",
               ( Size(A) = 4 and then
                 Size(B) = 12 ));

   New_Line;
   Put_Line("*** End of Test_Iterators $RCSfile: test_iterators.adb,v $ $Revision: 2.1 $ ***");
   New_Line;


end Test_Iterators;
