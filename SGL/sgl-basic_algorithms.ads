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
--  $Id: sgl-basic_algorithms.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL.Pairs;
with SGL.Iterator_Tags;
with SGL.Input_Iterators;
with SGL.Output_Iterators;
with SGL.Forward_Iterators;
with SGL.Forward_Constant_Iterators;
with SGL.Bidirectional_Iterators;
with SGL.Bidirectional_Constant_Iterators;
with SGL.Random_Access_Iterators;
with SGL.Random_Access_Constant_Iterators;
with SGL.Default_Allocators;

package SGL.Basic_Algorithms is

   -- The interface to Iter_Swap is muddled by a deficiency in Ada 95
   -- One has to either state that the generic package parameter is an
   -- instance of a generic package, or specify *ALL* the generic parameters.
   --      formal_package_actual_part ::= (<>) | [generic_actual_part]
   -- In this case we would like to be able to state that
   --
   --     with package Iterators2 is new SGL.Forward_Iterators
   --              (Value_Type=>Iterators1.Value_Type, <>)
   --
   -- Meaning that Iterators{1,2} share the same value type, but not
   -- necessarily the same operations.  The hack is to pass the
   -- Val function externally.

   generic
      with package Iterators1 is new SGL.Forward_Iterators(<>);
      with package Iterators2 is new SGL.Forward_Iterators(<>);
      with function Val2(A:Iterators1.Iterator)
                        return Iterators2.Value_Type is <>;
      with function Val1(A:Iterators2.Iterator)
                         return Iterators1.Value_Type is <>;
   procedure Iter_Swap(A: in out Iterators1.Iterator;
                       B: in out Iterators2.Iterator);
   pragma Inline(Iter_Swap);

   generic
      type T is private;
   procedure Swap(A, B: in out T);
   pragma Inline(Swap);

   generic
      type T is limited private;
      with function "<" (A, B: in T) return Boolean;
   function Generic_Min(A, B: in T) return T;
   pragma Inline(Generic_Min);

   generic
      type T is limited private;
      with function "<" (A, B: in T) return Boolean;
   function Generic_Max(A, B: in T) return T;
   pragma Inline(Generic_Max);

   -- Distance

   generic
      with package Iterators is new SGL.Input_Iterators(<>);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Input_Iterator_Tag is <>;
   procedure Input_Distance(First, Last: Iterators.Iterator;
                            N: in out Iterators.Distance_Type);
   pragma Inline(Input_Distance);

   generic
      with package Iterators is new SGL.Forward_Constant_Iterators(<>);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Forward_Iterator_Tag is <>;
   procedure Forward_Distance(First, Last: Iterators.Constant_Iterator;
                              N: in out Iterators.Distance_Type);
   pragma Inline(Forward_Distance);

   generic
      with package Iterators is new SGL.Bidirectional_Constant_Iterators(<>);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Bidirectional_Iterator_Tag is <>;
   procedure Bidirectional_Distance(First, Last: Iterators.Constant_Iterator;
                                       N: in out Iterators.Distance_Type);
   pragma Inline(Bidirectional_Distance);

   generic
      with package Iterators is new SGL.Random_Access_Constant_Iterators(<>);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Random_Access_Iterator_Tag is <>;
   procedure Random_Access_Distance(First, Last: Iterators.Constant_Iterator;
                                    N: in out Iterators.Distance_Type);
   pragma Inline(Random_Access_Distance);

   -- Advance

   generic
      with package Iterators is new SGL.Input_Iterators(<>);
      Zero : Iterators.Distance_Type := Iterators.Distance_Type'Val(0);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Input_Iterator_Tag is <>;
   procedure Input_Advance(I: in out Iterators.Iterator;
                           N: Iterators.Distance_Type);
   pragma Inline(Input_Advance);

   generic
      with package Iterators is new SGL.Forward_Constant_Iterators(<>);
      Zero : Iterators.Distance_Type := Iterators.Distance_Type'Val(0);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Forward_Iterator_Tag is <>;
   procedure Forward_Advance(I: in out Iterators.Constant_Iterator;
                             N: Iterators.Distance_Type);
   pragma Inline(Forward_Advance);

   generic
      with package Iterators is new
        SGL.Bidirectional_Constant_Iterators(<>);
      Zero : Iterators.Distance_Type := Iterators.Distance_Type'Val(0);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Bidirectional_Iterator_Tag is <>;
   procedure Bidirectional_Advance(I: in out Iterators.Constant_Iterator;
                                   N: Iterators.Distance_Type);
   pragma Inline(Bidirectional_Advance);

   generic
      with package Iterators is new
        SGL.Random_Access_Constant_Iterators(<>);
      Zero : Iterators.Distance_Type := Iterators.Distance_Type'Val(0);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Random_Access_Iterator_Tag is <>;
   procedure Random_Access_Advance(I: in out Iterators.Constant_Iterator;
                                   N: Iterators.Distance_Type);
   pragma Inline(Random_Access_Advance);

   -- Destroy, Uninitialized_Copy, Uninitialized_Fill, Uninitialized_Fill_N
   -- have been moved to the Allocators package.

   generic
      with package Input_Iterators is new SGL.Input_Iterators(<>);
      with package Output_Iterators is new SGL.Output_Iterators(<>);
      with function Val(X: Input_Iterators.Iterator)
                        return  Output_Iterators.Value_Type is <>;
   function Copy(First, Last: Input_Iterators.Iterator;
                 Result: Output_Iterators.Iterator)
                 return Output_Iterators.Iterator;
   pragma Inline (Copy);

   generic
      with package Iterators1 is new SGL.Bidirectional_Constant_Iterators(<>);
      with package Iterators2 is new SGL.Bidirectional_Iterators(<>);
      with function Val(X: Iterators1.Constant_Iterator)
                        return  Iterators2.Value_Type is <>;
   function Copy_Backward(First, Last: Iterators1.Constant_Iterator;
                          Result : Iterators2.Iterator)
                          return Iterators2.Iterator;
   pragma Inline (Copy_Backward);

   generic
      with package Iterators is new SGL.Forward_Iterators(<>);
   procedure Fill(First, Last: Iterators.Iterator;
                  Value: Iterators.Value_Type);
   pragma Inline (Fill);

   generic
      with package Iterators is new SGL.Forward_Iterators(<>);
      type Size_Type is (<>);
      Zero : Size_Type := Size_Type'Val(0);
      with function ">"(A, B: Size_Type) return Boolean is <>;
   function Fill_N(First, Last: Iterators.Iterator;
                   N: Size_Type;
                   Value: Iterators.Value_Type)
                   return Iterators.Iterator;
   pragma Inline (Fill_N);

   generic
      with package Iterators1 is new SGL.Input_Iterators(<>);
      with package Iterators2 is new SGL.Input_Iterators(<>);
      with package Iterator_Pairs is new SGL.Pairs
        (Iterators1.Iterator, Iterators2.Iterator,
         Iterators1."=", Iterators2."=");
      with function "="(A: Iterators1.Value_Type;
                        B: Iterators2.Value_Type) return Boolean is <>;
   function Mismatch(First1, Last1: Iterators1.Iterator;
                     First2: Iterators2.Iterator)
                     return Iterator_Pairs.Pair;
   pragma Inline (Mismatch);

   generic
      with package Iterators1 is new SGL.Input_Iterators(<>);
      with package Iterators2 is new SGL.Input_Iterators(<>);
      with function "="(A: Iterators1.Value_Type;
                        B: Iterators2.Value_Type) return Boolean is <>;
   function Equal(First1, Last1: Iterators1.Iterator;
                  First2: Iterators2.Iterator) return Boolean;
   pragma Inline (Equal);

   generic
      with package Iterators1 is new SGL.Input_Iterators(<>);
      with package Iterators2 is new SGL.Input_Iterators(<>);
      with function Less_Than12(A: Iterators1.Value_Type;
                                B: Iterators2.Value_Type) return Boolean is <>;
      with function Less_Than21(A: Iterators2.Value_Type;
                                B: Iterators1.Value_Type) return Boolean is <>;
   function Lexicographical_Compare(First1, Last1: Iterators1.Iterator;
                                    First2, Last2: Iterators2.Iterator)
                                    return Boolean;
   pragma Inline(Lexicographical_Compare);


end SGL.Basic_Algorithms;
