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
with Int_Bool_Map_Signatures;
with Test_Assert;
with Bool_Random;

with SGL;
with Integer_Ostream_Iterators;
with SGL.Basic_Algorithms;


procedure Test_Maps is
   use Int_Bool_Maps;
   use Int_Bool_Maps.Size_Type_Operations;

   package Int_Bool_Map_Input_Constant_Iterators renames
     Int_Bool_Map_Signatures.Map_Input_Constant_Iterators;

   package Int_Bool_Map_Output_Iterators renames
     Int_Bool_Map_Signatures.Map_Output_Iterators;

   function Second(I : Int_Bool_Maps.Constant_Iterator) return Boolean is
   begin
      return Second(Val(I));
   end Second;
   pragma Inline(Second);


   A, B : aliased Map;
   I : Iterator;
   R : Bool_Random.Generator;
   -- StdOut : Integer_Ostream_Iterators.Ostream_Iterators.Iterator;

   type Test_Range is new Integer range 1..10000;
   type Boolean_Buffer is array (Test_Range) of Boolean;

   Buffer : Boolean_Buffer;
begin
   Put_Line("*** Welcome to Test_Maps $RCSfile: test_maps.adb,v $ $Revision: 2.1 $ ***"); New_Line;

   -- A = {}, B = {}
   Test_Assert("Checking empty Map properties ... ",
                ( (Start(A) = Finish(A)) and then
                  Empty(A) and then
                  (Size(A) = 0) and then
                  (A = A) and then
                  (A = B) ));

   Assign(A, 1, True);
   Assign(A, 2, False);
   -- A = {(1,T), (2,F)}, B = {}
   Test_Assert("Checking A contents after inserting values 1 and 2 ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 2) and then
                 (A = A) and then
                 (A /= B) and then
                 (Second(Val(Start(A))) = True) and then
                 (Value(A, 1) = True) and then
                 (Second(Val(Next(Start(A)))) = False) and then
                 (Value(A, 2) = False) ));

   Assign(A, 1, False);
   -- A = {(1,F), (2,F)}, B = {}

   Test_Assert("Checking A contents after assigning A[1]=False ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 2) and then
                 (A = A) and then
                 (A /= B) and then
                 (Second(Val(Start(A))) = False) and then
                 (Value(A, 1) = False) and then
                 (Second(Val(Next(Start(A)))) = False) and then
                 (Value(A, 2) = False) ));

   Ref_Second(Ref(Start(A'Unchecked_Access))).all := True;
   -- A = {(1,T), (2,F)}, B = {}

   Test_Assert("Checking A contents after changing A[1] back to True with Ref_Second ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 2) and then
                 (A = A) and then
                 (A /= B) and then
                 (Second(Val(Start(A))) = True) and then
                 (Value(A, 1) = True) and then
                 (Second(Val(Next(Start(A)))) = False) and then
                 (Value(A, 2) = False) ));

   -- StdOut := Copy(Start(A), Finish(A), StdOut); New_Line;


   Erase(A, Start(A'Unchecked_Access), Finish(A'Unchecked_Access));

   -- A= {}, B = {}
   Test_Assert("Checking empty Map properties after removing all values ... ",
                ( (Start(A) = Finish(A)) and then
                  Empty(A) and then
                  (Size(A) = 0) and then
                  (A = A) and then
                  (A = B) ));

   Bool_Random.Reset(R);
   for Count in Test_Range loop
      declare
         Random_Boolean : Boolean;
      begin
         Random_Boolean := Bool_Random.Random(R);
         Assign(A, Integer(Count), Random_Boolean);
         Buffer(Count) := Random_Boolean;
      end;
   end loop;
   -- A = {(1,Random), (2,Random) ... (10000,Random)}, B={}
   Test_Assert("Checking Map properties after inserting 10000 random values ... ",
               ( (Start(A) /= Finish(A)) and then
                 (not Empty(A)) and then
                 (Size(A) = 10000) and then
                 (A = A) and then
                 (A /= B) ));


   Put("Checking values ... ");
   declare
      J : Constant_Iterator := Start(A);
   begin
      for Count in Test_Range loop
         if ( (Value(A, Integer(Count)) /= Second(Val(J))) or else
              (Second(Val(J)) /= Buffer(Count)) ) then
            Test_Assert("", False);
         end if;
         Inc(J);
      end loop;
   end;
   Put_Line("OK");

   New_Line; Put("*** End of Test_Maps $RCSfile: test_maps.adb,v $ $Revision: 2.1 $ ***"); New_Line;

end Test_Maps;
