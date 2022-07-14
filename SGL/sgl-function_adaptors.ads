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
--  $Id: sgl-function_adaptors.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL.Pairs;

package SGL.Function_Adaptors is

   generic
      with package T_Pairs is new SGL.Pairs(<>);
   function Select1st(P : in T_Pairs.Pair) return T_Pairs.Value_Type1;
   pragma Inline(Select1st);

   generic
      with package T_Pairs is new SGL.Pairs(<>);
   function Select2nd(P : in T_Pairs.Pair) return T_Pairs.Value_Type2;
   pragma Inline(Select1st);

   generic
      type T is limited private;
   function Identity(I : in T) return T;
   pragma Inline(Identity);

   generic
      type T1 is limited private;
      with function Unary_Predicate(X: in T1) return Boolean;
   function Not1(X: in T1) return Boolean;
   pragma Inline(Not1);

   generic
      type T1 is limited private;
      type T2 is limited private;
      with function Binary_Predicate(X: in T1; Y: in T2) return Boolean;
   function Not2(X: in T1; Y: in T2) return Boolean;
   pragma Inline(Not2);

   generic
      type T1 is private;
      type T2 is limited private;
      type T3 is limited private;
      with function F(A: in T1; B: in T2) return T3;
      Value : T1;
   function Bind1st(B : in T2) return T3;
   pragma Inline(Bind1st);

   generic
      type T1 is limited private;
      type T2 is private;
      type T3 is limited private;
      with function F(A: in T1; B: in T2) return T3;
      Value : T2;
   function Bind2nd(A : in T1) return T3;
   pragma Inline(Bind1st);

   generic
      type T1 is limited private;
      type T2 is limited private;
      type T3 is limited private;
      with function Op1(Y: in T2) return T3;
      with function Op2(X: in T1) return T2;
   function Compose1(X: in T1) return T3;
   pragma Inline(Compose1);

   generic
      type T1 is limited private;
      type T2 is limited private;
      type T3 is limited private;
      type T4 is limited private;
      with function Op1(Y : in T2; Z: in T3) return T4;
      with function Op2(X: in T1) return T2;
      with function Op3(X: in T1) return T3;
   function Compose2(X: in T1) return T4;
   pragma Inline(Compose1);

   generic
      type T1 is limited private;
      with function Op1(X: in T1) return Boolean;
      with function Op2(X: in T1) return Boolean;
   function Compose_With_And_Then(X: in T1) return Boolean;
   pragma Inline(Compose_With_And_Then);

   generic
      type T1 is limited private;
      with function Op1(X: in T1) return Boolean;
      with function Op2(X: in T1) return Boolean;
   function Compose_With_Or_Else(X: in T1) return Boolean;
   pragma Inline(Compose_With_Or_Else);

   generic
      type T1 is limited private;
      type T2 is limited private;
   package Access_To_Unary_Function is

      type AF is access function (X: in T1) return T2;
      procedure Remember(F: in AF);
      function Apply(X: in T1) return T2;

   private
      Remembered: AF;
   end Access_To_Unary_Function;

   generic
      type T1 is limited private;
      type T2 is limited private;
      type T3 is limited private;
   package Access_To_Binary_Function is
      type AF is access function (X1: in T1; X2: in T2) return T3;
      procedure Remember(F: in AF);
      function Apply(X1: in T1; X2: in T2) return T3;

   private
      Remembered: AF;
   end Access_To_Binary_Function;

end SGL.Function_Adaptors;

