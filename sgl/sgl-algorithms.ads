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

package SGL.Algorithms is

   generic
      with package Iterators is new SGL.Input_Iterators(<>);
      with procedure F(Value : Iterators.Value_Type);
   procedure For_Each(First, Last: in Iterators.Iterator);
   pragma Inline(For_Each);

   generic
      with package Iterators is new SGL.Input_Iterators(<>);
      with function "="(Left, Right: in Iterators.Value_Type)
                        return Boolean is <>;
   function Find(First, Last: in Iterators.Iterator;
                 Value: in Iterators.Value_Type)
                 return Iterators.Iterator;
   pragma Inline(Find);

   generic
      with package Iterators is new SGL.Input_Iterators(<>);
      with function Predicate(X: Iterators.Value_Type) return Boolean;
   function Find_If(First, Last: in Iterators.Iterator)
     return Iterators.Iterator;
   pragma Inline(Find_If);

   generic
      with package Iterators is new SGL.Forward_Iterators(<>);
      with function "="(X, Y: Iterators.Value_Type) return Boolean is <>;
   function Adjacent_Find(First, Last : Iterators.Constant_Iterator)
                          Return Iterators.Constant_Iterator;
   pragma Inline(Adjacent_Find);

   generic
      with package Iterators is new SGL.Input_Iterators(<>);
      with function "="(Left, Right: in Iterators.Value_Type)
                        return Boolean is <>;
   function Count(First, Last : Iterators.Iterator;
                  Value: Iterators.Value_Type)
                  return Iterators.Distance_Type;
   pragma Inline(Count);

   generic
      with package Iterators is new SGL.Input_Iterators(<>);
      with function Predicate(Value: Iterators.Value_Type) return Boolean;
      type Size_Type is (<>);
   function Count_If(First, Last : Iterators.Iterator)
                     return Size_Type;
   pragma Inline(Count_If);


   generic
      with package Iterators1 is new SGL.Forward_Constant_Iterators(<>);
      with package Iterators2 is new SGL.Forward_Constant_Iterators(<>);
      with procedure Distance1(First, Last: Iterators1.Constant_Iterator;
                               N: in out Iterators1.Distance_Type);
      with procedure Distance2(First, Last: Iterators2.Constant_Iterator;
                               N: in out Iterators2.Distance_Type);
      with function "="(A: Iterators1.Value_Type;
                        B: Iterators2.Value_Type) return Boolean is <>;
      with function "="(A: Iterators1.Distance_Type;
                        B: Iterators2.Distance_Type) return Boolean is <>;
      with function "<"(A: Iterators1.Distance_Type;
                        B: Iterators2.Distance_Type) return Boolean is <>;
   function Generic_Search(First1, Last1: Iterators1.Constant_Iterator;
                           First2, Last2: Iterators2.Constant_Iterator)
                           return Iterators1.Constant_Iterator;
   pragma Inline(Generic_Search);


   generic
      with package Iterators1 is new SGL.Forward_Iterators(<>);
      with package Iterators2 is new SGL.Forward_Iterators(<>);
      with function Val2(A: Iterators1.Iterator)
                        return Iterators2.Value_Type is <>;
      with function Val1(A: Iterators2.Iterator)
                         return Iterators1.Value_Type is <>;
   function Swap_Ranges(First1, Last1 : Iterators1.Iterator;
                        First2 : Iterators2.Iterator)
                        return Iterators2.Iterator;
   pragma Inline(Swap_Ranges);

   generic
      with package Input_Iterators is new SGL.Input_Iterators(<>);
      with package Output_Iterators is new SGL.Output_Iterators(<>);
      with function Unary_Op(V : Input_Iterators.Value_Type)
                             return Output_Iterators.Value_Type;
   function Unary_Transform(First, Last : Input_Iterators.Iterator;
                            Result : Output_Iterators.Iterator)
                            return Output_Iterators.Iterator;
   pragma Inline(Unary_Transform);


   generic
      with package Iterators1 is new SGL.Input_Iterators(<>);
      with package Iterators2 is new SGL.Input_Iterators(<>);
      with package Output_Iterators is new SGL.Output_Iterators(<>);
      with function Binary_Op(V1 : Iterators1.Value_Type;
                              V2 : Iterators2.Value_Type)
                              return Output_Iterators.Value_Type;
   function Binary_Transform(First1, Last1 : Iterators1.Iterator;
                             First2 : Iterators2.Iterator;
                             Result : Output_Iterators.Iterator)
                             return Output_Iterators.Iterator;
   pragma Inline(Binary_Transform);


   generic
      with package Iterators is new SGL.Forward_Iterators(<>);
      with function "="(Left, Right: in Iterators.Value_Type)
                        return Boolean is <>;
   procedure Replace(First, Last : Iterators.Iterator;
                     Old_Value, New_Value : Iterators.Value_Type);
   pragma Inline(Replace);


   generic
      with package Iterators is new SGL.Forward_Iterators(<>);
      with function Predicate(V : Iterators.Value_Type)
                              return Boolean;
   procedure Replace_If(First, Last : Iterators.Iterator;
                        New_Value : Iterators.Value_Type);
   pragma Inline(Replace_If);


   generic
      with package Input_Iterators is new SGL.Input_Iterators(<>);
      with package Output_Iterators is new SGL.Output_Iterators(<>);
      with function Val(Iter : Input_Iterators.Iterator)
                        return Output_Iterators.Value_Type is <>;
      with function "="(A, B : Input_Iterators.Value_Type)
                        return Boolean is <>;
   procedure Replace_Copy(First, Last : Input_Iterators.Iterator;
                          Result : Output_Iterators.Iterator;
                          Old_Value : Input_Iterators.Value_Type;
                          New_Value : Output_Iterators.Value_Type);
   pragma Inline(Replace_Copy);


   generic
      with package Input_Iterators is new SGL.Input_Iterators(<>);
      with package Output_Iterators is new SGL.Output_Iterators(<>);
      with function Predicate(V : Input_Iterators.Value_Type)
                              return Boolean;
      with function Val(Iter : Input_Iterators.Iterator)
                        return Output_Iterators.Value_Type is <>;
   procedure Replace_Copy_If(First, Last : Input_Iterators.Iterator;
                             Result : Output_Iterators.Iterator;
                             New_Value : Output_Iterators.Value_Type);
   pragma Inline(Replace_Copy);




   -- missing functions from algo.h; for a later version :-)



   generic
      with package Iterators is new SGL.Bidirectional_Iterators(<>);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Bidirectional_Iterator_Tag is <>;
   procedure Bidirectional_Reverse(First, Last: in Iterators.Iterator);
   pragma Inline(Bidirectional_Reverse);

   generic
      with package Iterators is new SGL.Random_Access_Iterators(<>);
      with function Verify_Tag(C : Iterators.Iterator_Category) return
        SGL.Iterator_Tags.Random_Access_Iterator_Tag is <>;
   procedure Random_Access_Reverse(First, Last: in Iterators.Iterator);
   pragma Inline(Random_Access_Reverse);


end SGL.Algorithms;
