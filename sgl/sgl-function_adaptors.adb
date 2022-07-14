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

package body SGL.Function_Adaptors is

   function Identity(I : in T) return T is
   begin
      return(I);
   end Identity;

   function Select1st(P : in T_Pairs.Pair) return T_Pairs.Value_Type1 is
   begin
      return(P.First);
   end Select1st;

   function Select2nd(P : in T_Pairs.Pair) return T_Pairs.Value_Type2 is
   begin
      return(P.Second);
   end Select2nd;

   function Not1(X: in T1) return Boolean is
   begin
      return(not Unary_Predicate(X));
   end Not1;

   function Not2(X: in T1; Y: in T2) return Boolean is
   begin
      return(not Binary_Predicate(X, Y));
   end Not2;

   function Bind1st(B : in T2) return T3 is
   begin
      return(F(Value, B));
   end Bind1st;

   function Bind2nd(A : in T1) return T3 is
   begin
      return(F(A, Value));
   end Bind2nd;


   function Compose1(X: in T1) return T3 is
   begin
      return(Op1(Op2(X)));
   end Compose1;

   function Compose2(X: in T1) return T4 is
   begin
      return(Op1(Op2(X), Op3(X)));
   end Compose2;

   function Compose_With_And_Then(X: in T1) return Boolean is
   begin
      return Op1(X) and then Op2(X);
   end Compose_With_And_Then;

   function Compose_With_Or_Else(X: in T1) return Boolean is
   begin
      return Op1(X) or else Op2(X);
   end Compose_With_Or_Else;

   package body Access_To_Unary_Function is

      procedure Remember(F: in AF) is
      begin
	 Remembered := F;
      end Remember;
  
      function Apply(X: in T1) return T2 is
      begin
	 return Remembered.all(X);
      end Apply;
      
   end Access_To_Unary_Function;


   package body Access_To_Binary_Function is

      procedure Remember(F: in AF) is
      begin
	 Remembered := F;
      end Remember;
  
      function Apply(X1: in T1; X2: in T2) return T3 is
      begin
	 return Remembered.all(X1, X2);
      end Apply;
      
   end Access_To_Binary_Function;


end SGL.Function_Adaptors;
