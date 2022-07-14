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
--  $Id: test_functions.adb,v 2.1 1997/07/12 00:40:37 akonstan Exp $
--

with Gnat.IO; use Gnat.IO;
-- with Int_Lists;
with Test_Assert;
with SGL.Function_Adaptors;
with Ada.Exceptions;

procedure Test_Functions is
   use SGL.Function_Adaptors;
   use Ada.Exceptions;

   function Greater_Than_7 is
     new Bind2nd(Integer, Integer, Boolean, ">", 7);

   function Less_Than_11(X: Integer) return Boolean is
   begin
      return X < 11;
   end Less_Than_11;

   function Not_Greater_Than_7 is
     new Not1(Integer, Greater_Than_7);

   function Between_7_And_11 is
     new Compose2(Integer, Boolean, Boolean, Boolean, "and",
                  Greater_Than_7, Less_Than_11);

   -- Can't use "and then" in place of "and", but we can use
   -- a function adaptor called Compose_With_And_Then:

   function Remainder_Dividing_60 is
      new Bind1st(Integer, Integer, Integer, "rem", 60);

   function Zero is
     new Bind2nd(Integer, Integer, Boolean, "=", 0);

   function Nonzero is
     new Bind2nd(Integer, Integer, Boolean, "/=", 0);

   function Remainder_Dividing_60_Is_0 is
     new Compose1(Integer, Integer, Boolean, Zero, Remainder_Dividing_60);

   function Divides_60 is
      new Compose_With_And_Then(Integer, Nonzero, Remainder_Dividing_60_Is_0);

   function Square(X: Integer) return Integer is
   begin
      return X * X;
   end Square;

   function Cube(X: Integer) return Integer is
   begin
      return X * X * X;
   end Cube;

   function Sum_Of_Square_And_Cube is
     new Compose2(Integer, Integer, Integer, Integer, "+", Square, Cube);

   package AF1 is new Access_To_Unary_Function(Integer, Boolean);

   function NotAF1 is new Not1(Integer, AF1.Apply);

   package Another_AF1 is new Access_To_Unary_Function(Integer, Boolean);

   package AF2 is new Access_To_Binary_Function(Integer, Integer, Boolean);

   function Less_Equal(X, Y: in Integer) return Boolean is
   begin
      return X <= Y;
   end Less_Equal;

begin
   Put_Line("*** Welcome to Test_Functions $RCSfile: test_functions.adb,v $ $Revision: 2.1 $ ***"); New_Line;

   Test_Assert("Checking Greater_Than_7 ...",
               ( Greater_Than_7(8) and then
                 not Greater_Than_7(5) and then
                 not Greater_Than_7(7) ));

   Test_Assert("Checking Not_Greater_Than_7 ...",
               ( Not_Greater_Than_7(5) and then
                 not Not_Greater_Than_7(8) and then
                 not Not_Greater_Than_7(17) ));

   Test_Assert("Checking Less_Than_11 ...",
               ( Less_Than_11(8) and then
                 not Less_Than_11(15) and then
                 not Less_Than_11(11) ));

   Test_Assert("Checking Between_7_And_11 ...",
               ( Between_7_And_11(8) and then
                 not Between_7_And_11(15) and then
                 not Between_7_And_11(11) ));

   Test_Assert("Checking Divides_60 ... ",
               ( Divides_60(15) and then
                 Divides_60(12) and then
                 not Divides_60(13) and then
                 not Divides_60(0) and then
                 Divides_60(4) ));

   Test_Assert("Checking Sum_Of_Square_and_Cube ...",
               ( Sum_Of_Square_And_Cube(5) = 150 and then
                 Sum_Of_Square_And_Cube(6) = 252 and then
                 Sum_Of_Square_And_Cube(2) = 12 ));

   AF1.Remember(Less_Than_11'Access);

   Test_Assert("Checking Access_To_Unary_Function Less_Than_11 ...",
               ( AF1.Apply(7) and then
                 not AF1.Apply(13) and then
                 not AF1.Apply(11) ));

   AF1.Remember(Greater_Than_7'Access);

   Test_Assert("Checking Access_To_Unary_Function Greater_Than_7 ...",
               ( AF1.Apply(9) and then
                 not AF1.Apply(3) and then
                 not AF1.Apply(7) ));

   AF1.Remember(Less_Than_11'Access);

   Test_Assert("Checking Not1 Access_To_Unary_Function Less_Than_11 ...",
               ( NotAF1(13) and then
                 NotAF1(11) and then
                 not NotAF1(7) ));

   Another_AF1.Remember(Between_7_And_11'Access);

   Test_Assert("Checking Access_To_Unary_Function Between_7_And_11 ...",
               ( Another_AF1.Apply(9) and then
                 Another_AF1.Apply(10) and then
                 not Another_AF1.Apply(7) ));

   Test_Assert("Checking Access_To_Unary_Function Less_Than_11 ...",
               ( AF1.Apply(7) and then
                 not AF1.Apply(13) and then
                 not AF1.Apply(11) ));

   AF2.Remember(Less_Equal'Access);

   Test_Assert("Checking Access_To_Binary_Function Less_Equal ...",
               ( AF2.Apply(7, 8) and then
                 not AF2.Apply(8, 7) and then
                 AF2.Apply(7, 7) ));



   Put_Line("Checking Remainder_Dividing_60_Is_0(0) ... ");
   declare
      Temp: Boolean;
   begin
--      Temp := Remainder_Dividing_60_Is_0(0);
      null;
   exception
      when Constraint_Error =>
         Put("Constraint_Error raised, as expected");
-- actually GNAT raises STATUS_INTEGER_DIVIDE_BY_ZERO, but it
-- doesn't work to try to catch it.
   end;

   New_Line;
   Put_Line("*** End of Test_Functions $RCSfile: test_functions.adb,v $ $Revision: 2.1 $ ***");
   New_Line;

end Test_Functions;






