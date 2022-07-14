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
--  $Id: test_algorithms.adb,v 2.1 1997/07/12 00:40:37 akonstan Exp $
--

with Gnat.IO; use Gnat.IO;

with SGL;
with SGL.Basic_Algorithms;
with SGL.Algorithms;
with SGL.Input_Iterators;
with SGL.Output_Iterators;
with SGL.Input_Iterators;

with Int_Vectors;
with Int_Vector_Signatures;
with Int_Lists;
with Int_List_Signatures;
with Integer_Ostream_Iterators;

with Test_Assert;

procedure Test_Algorithms is
   -- Use clauses
   use Int_Vectors;
   use Int_Lists;

   -- Local variables

   A, A1, B, B1, C, C1 : aliased Int_Vectors.Vector;
   L : aliased Int_Lists.List;
   DontCare, Iter : Int_Vectors.Iterator;
   Constant_DontCare, CIter : Int_Vectors.Constant_Iterator;
   Sum  : Integer := 0;
   Sum2 : Integer := 0;

   -- Renaming

   package Int_Vector_Input_Iterators
     renames Int_Vector_Signatures.Vector_Input_Iterators;
   package Int_Vector_Input_Constant_Iterators
     renames Int_Vector_Signatures.Vector_Input_Constant_Iterators;
   package Int_Vector_Output_Iterators
     renames Int_Vector_Signatures.Vector_Output_Iterators;
   package Int_Vector_Forward_Iterators
     renames Int_Vector_Signatures.Vector_Forward_Iterators;
   package Int_Vector_Forward_Constant_Iterators
     renames Int_Vector_Signatures.Vector_Forward_Constant_Iterators;
   package Int_Vector_Random_Access_Iterators
     renames Int_Vector_Signatures.Vector_Random_Access_Iterators;
   package Int_Vector_Random_Access_Constant_Iterators
     renames Int_Vector_Signatures.Vector_Random_Access_Constant_Iterators;


    package Int_List_Input_Constant_Iterators
      renames Int_List_Signatures.List_Input_Constant_Iterators;
    package Int_List_Output_Iterators
      renames Int_List_Signatures.List_Output_Iterators;
    package Int_List_Bidirectional_Iterators
      renames Int_List_Signatures.List_Bidirectional_Iterators;

   -- Import Size_Type operations as needed

   function "="(A,B : in Int_Vectors.Size_Type) return Boolean
     renames Int_Vectors.Size_Type_Operations."=";
   function "="(A,B : in Int_Vectors.Difference_Type) return Boolean
     renames Int_Vectors.Difference_Type_Operations."=";
   --
   -- Test functions and procedures
   --

   -- Global_Sum: add parameter to global variable Sum
   procedure Global_Sum(I: in Integer) is
   begin
      Sum := Sum + I;
   end Global_Sum;

   -- Is_Even : returns true if the number is even
   function Is_Even(I: in Integer) return Boolean is
   begin
      return(I mod 2 = 0);
   end Is_Even;

   -- Square : returns x^2
   function Square(I: in Integer) return Integer is
   begin
      return(I*I);
   end Square;

   --
   -- Generic function instantiations
   --

   procedure Iter_Swap is new SGL.Basic_Algorithms.Iter_Swap
     (Int_Vector_Forward_Iterators,
      Int_Vector_Forward_Iterators, Val, Val);

   procedure Swap is new SGL.Basic_Algorithms.Swap(Integer);
   function Min is new SGL.Basic_Algorithms.Generic_Min(Integer, "<");
   function Max is new SGL.Basic_Algorithms.Generic_Max(Integer, "<");

   procedure For_Each_Global_Sum is new SGL.Algorithms.For_Each
     (Int_Vector_Input_Constant_Iterators, Global_Sum);

    procedure For_Each_Global_Sum is new SGL.Algorithms.For_Each
      (Int_List_Input_Constant_Iterators, Global_Sum);

   function Find is new SGL.Algorithms.Find
     (Int_Vector_Input_Constant_Iterators, "=");

   function Find_If_Even is new SGL.Algorithms.Find_If
     (Int_Vector_Input_Constant_Iterators, Is_Even);

   function Count is new SGL.Algorithms.Count
     (Int_Vector_Input_Constant_Iterators, "=");

   function Count_If_Even is new SGL.Algorithms.Count_If
     (Int_Vector_Input_Constant_Iterators, Is_Even, Int_Vectors.Size_Type);

   procedure Distance is new SGL.Basic_Algorithms.Random_Access_Distance
     (Int_Vector_Random_Access_Constant_Iterators, Int_Vectors.Verify_Tag);

   function Search is new SGL.Algorithms.Generic_Search
     (Int_Vector_Forward_Constant_Iterators,
      Int_Vector_Forward_Constant_Iterators,
      Distance, Distance,
      Int_Vectors."=",
      Int_Vectors.Difference_Type_Operations."=",
      Int_Vectors.Difference_Type_Operations."<");

   function Copy is new SGL.Basic_Algorithms.Copy
     (Int_Vector_Input_Constant_Iterators, Int_Vector_Output_Iterators);

   function Swap_Ranges is new SGL.Algorithms.Swap_Ranges
     (Int_Vector_Forward_Iterators, Int_Vector_Forward_Iterators,
      Val, Val);

   function Square_Transform is new SGL.Algorithms.Unary_Transform
     (Int_Vector_Input_Constant_Iterators,
      Int_Vector_Output_Iterators, Square);

   function Additive_Transform is new SGL.Algorithms.Binary_Transform
     (Int_Vector_Input_Constant_Iterators,
      Int_Vector_Input_Constant_Iterators,
      Int_Vector_Output_Iterators, "+");

   procedure Replace is new SGL.Algorithms.Replace
     (Int_Vector_Forward_Iterators, "=");

   procedure Replace_If_Even is new SGL.Algorithms.Replace_If
     (Int_Vector_Forward_Iterators, Is_Even);

   procedure Replace_Copy is new SGL.Algorithms.Replace_Copy
     (Int_Vector_Input_Constant_Iterators,
      Int_Vector_Output_Iterators,
      Int_Vectors.Val, Int_Vectors.Value_Allocators."=");

   procedure Replace_Copy_If_Even is new SGL.Algorithms.Replace_Copy_If
     (Int_Vector_Input_Constant_Iterators,
      Int_Vector_Output_Iterators, Is_Even,
      Int_Vectors.Val);

    procedure Bidirectional_Reverse is
      new SGL.Algorithms.Bidirectional_Reverse
      (Int_List_Bidirectional_Iterators, Int_Lists.Verify_Tag);

   procedure Random_Access_Reverse is
     new SGL.Algorithms.Random_Access_Reverse
     (Int_Vector_Random_Access_Iterators, Int_Vectors.Verify_Tag);


   function Copy is new SGL.Basic_Algorithms.Copy
     (Int_List_Input_Constant_Iterators,
      Integer_Ostream_Iterators.Output_Iterators);

   -- More local variables

   StdOut : Integer_Ostream_Iterators.Ostream_Iterators.Iterator;

begin
   Put_Line("=== Welcome to $RCSfile: test_algorithms.adb,v $ $Revision: 2.1 $ ==="); New_Line;

   Put_Line("PRECONDITION : The SGL.Vectors package works correctly!");
   New_Line;

   Put_Line("#Pushing values 1..10 into vector A ...");

   -- A = B = {}
   for I in 1..10 loop
      Push_Back(A, I);
   end loop;

   -- A = {1..10 }, B = {}
   Sum := 0;
   For_Each_Global_Sum(Start(A), Finish(A));
   Test_Assert("Testing For_Each (summing A [Sum=55]) ... ",
               ( Sum = 55 ));


   Test_Assert("Testing Find (4 [found] and 44 [not found]) ... ",
               ( (Find(Start(A), Finish(A), 4) /= Finish(A)) and then
                 (Val(Find(Start(A), Finish(A), 4)) = 4) and then
                 (Find(Start(A), Finish(A), 44) = Finish(A)) ));

   Test_Assert("Testing Find_If (first even number = 2) ... ",
               ( (Find_If_Even(Start(A), Finish(A)) /= Finish(A)) and then
                 (Val(Find_If_Even(Start(A), Finish(A))) = 2) ));

   Put_Line("# Pushing values 1..10 into vector A ={1..10,1..10} ...");

   -- A = {1..10 }, B = {}
   for I in 1..10 loop
      Push_Back(A, I);
   end loop;

   -- A = {1..10, 1..10}
   Test_Assert("Testing Count (numbers equal to 5 = 2) ... ",
               ( (Count(Start(A), Finish(A), 5) = 2) ));

   Test_Assert("Testing Count_If (even numbers = 10) ... ",
               ( (Count_If_Even(Start(A), Finish(A)) = 10) ));

   Put_Line("# Pushing values 3..6 into vector B = {3..6} ... ");

   -- A = {1..10, 1..10 }, B = {}
   for I in 3..6 loop
      Push_Back(B, I);
   end loop;

   -- A = {1..10, 1..10 }, B = {3..6}
   Test_Assert("Testing Search (if B is a subsequence in A = true) ... ",
               ( (Search(Start(A), Finish(A), Start(B), Finish(B))
                  /= Finish(A)) and then
                 (Val(Search(Start(A), Finish(A), Start(B), Finish(B)))
                  = 3) and then
                 (Search(Start(A), Finish(A), Start(B), Finish(B))
                  - Start(A) = 2) ));

   Put_Line("# Pushing values 8 into vector B = {3..6,8} ... ");
   Push_Back(B, 8);
   -- A = {1..10, 1..10 }, B = {3..6,8}

   Test_Assert("Testing Search (if B is a subsequence in A = false) ... ",
               ( (Search(Start(A), Finish(A), Start(B), Finish(B))
                  = Finish(A)) ));

   -- A = {1..10, 1..10 }, B = {3..6,8}
   C := A;
   Test_Assert("# Assigning C and D := A = {1..10, 1..10 } ... ",
               ( (C = A) and then (C /= B) ));

   -- A = C = {1..10, 1..10 }, B = {3..6,8}

   Sum := 0;
   DontCare := Copy(Start(B), Finish(B), Start(C'Unchecked_Access));
   For_Each_Global_Sum(Start(C), Finish(C));
   Test_Assert("Testing Copy B to Start(C); C = { 3..6, 8, 6..10, 1..10 } [Sum=121] ... ",
               ( (Sum = 121) ));

   Put_Line("# Backing up A1 := A, and C1 := C");
   A1 := A;
   C1 := C;

   -- A = {1..10, 1..10 }, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
   -- A1 = {1..10, 1..10 }, C1 = {3..6, 8, 6..10, 1..10}
   Iter := Swap_Ranges(Start(A'Unchecked_Access),
                       Start(A'Unchecked_Access) + 3,
                       Start(C'Unchecked_Access));
   -- A = {3..5, 4..10, 1..10 }, B = {3..6,8}, C = {1..3, 6, 8, 6..10, 1..10}
   -- A1 = {1..10, 1..10 }, C1 = {3..6, 8, 6..10, 1..10}
   Sum := 0;
   For_Each_Global_Sum(Start(A), Finish(A));
   Sum2 := Sum;
   Sum := 0;
   For_Each_Global_Sum(Start(C), Finish(C));

   Test_Assert("Swap_Ranges(Start(A), Start(A)+3, Start(C) ... ",
               ( (Make_Constant(Iter) = Start(C) + 3) and then
                 (Sum = 115) and then
                 (Sum2 = 116) ));

   Iter := Swap_Ranges(Start(A'Unchecked_Access),
                       Start(A'Unchecked_Access) + 3,
                       Start(C'Unchecked_Access));
   -- A = {1..10, 1..10 }, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
   -- A1 = {1..10, 1..10 }, C1 = {3..6, 8, 6..10, 1..10}
   Test_Assert("Undoing previous operation by re-applying Swap_Ranges ... ",
               ( (A = A1) and then (C = C1) ));

   Iter := Square_Transform(Start(A1), Finish(A1), Start(A1'Unchecked_Access));
   -- A = {1..10, 1..10 }, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
   -- A1 = {(1,4,9,16,25,36,49,64,81,100)x2 }, C1 = {3..6, 8, 6..10, 1..10}
   Sum := 0;
   For_Each_Global_Sum(Start(A1), Finish(A1));
   Test_Assert("Testing Unary_Transform (Square_Transform A1->A1 [Sum=770]) ... ",
               ( (Sum = 770) and then (Iter = Finish(A1'Unchecked_Access)) ));

   Iter := Additive_Transform(Start(A), Finish(A), Start(A1),
                              Start(A1'Unchecked_Access));
   -- A = {1..10, 1..10 }, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
   -- A1 = {(2,6,12,20,30,42,56,72,90,110)x2 }, C1 = {3..6, 8, 6..10, 1..10}
   Sum := 0;
   For_Each_Global_Sum(Start(A1), Finish(A1));

    Test_Assert("Testing Binary_Transform (Square_Transform A+A1->A1 [Sum=880]) ... ",
               ( (Sum = 880) and then (Iter = Finish(A1'Unchecked_Access)) ));

   Put_Line("# Backing up A1 := A");
   A1 := A;
   -- A = {1..10, 1..10}, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
   -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}

   Replace(Start(A'Unchecked_Access), Finish(A'Unchecked_Access), 1, -1);

   -- A = {-1,2..10, -1,2..10 }, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
   -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}
   Sum := 0;
   For_Each_Global_Sum(Start(A), Finish(A));
   Test_Assert("Testing Replace(A, 1, -1) ... ", (Sum = 106));

   Replace(Start(A'Unchecked_Access), Finish(A'Unchecked_Access), -1, 1);
   -- A = {1..10, 1..10}, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
   -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}
   Test_Assert("Undoing previous operation by reversing Replace ... ",
               (A = A1));


   Replace_If_Even(Start(A'Unchecked_Access), Finish(A'Unchecked_Access), 0);
   -- A = {(1,3,5,7,9)x2}, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
   -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}
   Sum := 0;
   For_Each_Global_Sum(Start(A), Finish(A));
   Test_Assert("Testing Replace_If_Even(A, 0) [Sum=50] ... ",
               (Sum = 50));

   Put_Line("# Restoring A := A1 = {1..10, 1..10}");
   A := A1;
   -- A = {1..10, 1..10}, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
   -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}

  Replace_Copy(Start(A1), Finish(A1), Start(A'Unchecked_Access), 1, -1);

  -- A = {-1,2..10, -1,2..10 }, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
  -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}
  Sum := 0;
  For_Each_Global_Sum(Start(A), Finish(A));
  Test_Assert("Testing Replace_Copy(A1->A, 1, -1) ... ", (Sum = 106));

  Replace_Copy_If_Even(Start(A1), Finish(A1), Start(A'Unchecked_Access), 0);
  -- A = {(1,3,5,7,9)x2}, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
  -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}
  Sum := 0;
  For_Each_Global_Sum(Start(A), Finish(A));
  Test_Assert("Testing Replace_Copy_If_Even(A, 0) [Sum=50] ... ",
              (Sum = 50));

  Put_Line("# Restoring A := A1 = {1..10, 1..10}");
  A := A1;
  -- A = {1..10, 1..10}, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
  -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}

  -- L = {}
  for I in 1..10 loop
      Push_Back(L, I);
  end loop;

  -- L = {1..10}
  Bidirectional_Reverse(Start(L'Unchecked_Access), Finish(L'Unchecked_Access));
  -- StdOut := Copy(Start(L), Finish(L), StdOut); New_Line;

  -- L = {10..1}
  Sum := 0;
  For_Each_Global_Sum(Start(L), Finish(L));
  Test_Assert("Testing Bidirectional_Reverse(L) [Sum=55] ... ",
              ( (Sum = 55) and then
                (Val(Start(L)) = 10) and then
                (Val(Next(Start(L))) = 9) and then
                (Val(Next(Next(Start(L)))) = 8) and then
                (Val(Prev(Finish(L))) = 1) and then
                (Val(Prev(Prev(Finish(L)))) = 2) ));

  -- A = {1..10, 1..10}, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
  -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}
  Random_Access_Reverse(Start(A'Unchecked_Access), Finish(A'Unchecked_Access));
  -- A = {10..1, 10..1}, B = {3..6,8}, C = {3..6, 8, 6..10, 1..10}
  -- A1 = {1..10, 1..10}, C1 = {3..6, 8, 6..10, 1..10}
  Sum := 0;
  For_Each_Global_Sum(Start(A), Finish(A));
  Test_Assert("Testing Random_Access_Reverse(A) [Sum=110] ... ",
              ( (Sum = 110) and then
                (Val(Start(A)) = 10) and then
                (Val(Start(A)+1) = 9) and then
                (Val(Start(A)+2) = 8) and then
                (Val(Finish(A)-1) = 1) and then
                (Val(Finish(A)-2) = 2) ));

  Put_Line("=== End of $RCSfile: test_algorithms.adb,v $ $Revision: 2.1 $ ==="); New_Line;

end Test_Algorithms;
