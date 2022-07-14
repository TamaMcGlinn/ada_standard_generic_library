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

with Ada.Finalization;

with SGL.Integer_Operations;
with SGL.Forward_Iterators;

generic
   -- Types
   type Container is new Ada.Finalization.Controlled with private;
   type Container_Pointer is access Container;
   type Container_Constant_Pointer is access constant Container;

   with package Forward_Iterators is new SGL.Forward_Iterators(<>);

   with package Size_Type_Operations is new SGL.Integer_Operations(<>);
   with package Difference_Type_Operations is new SGL.Integer_Operations(<>);

   -- XXX Gnat 3.09 bug forces renaming
   type Iterator_Category_GNAT is private;
   with function Verify_Tag(T: Iterator_Category_GNAT)
                            return Iterator_Category_GNAT is <>;

   -- Container Operations

   with function Start(C: in Container_Pointer)
                       return Forward_Iterators.Iterator is <>;
   with function Start(C: in Container)
                       return Forward_Iterators.Constant_Iterator is <>;
   with function Finish(C: in Container_Pointer)
                        return Forward_Iterators.Iterator is <>;
   with function Finish(C: in Container)
                        return Forward_Iterators.Constant_Iterator is <>;

   with function Size(C: in Container) return Size_Type_Operations.T is <>;
   with function Max_Size(C: in Container) return Size_Type_Operations.T is <>;
   with function Empty(C: in Container) return Boolean is <>;
   with procedure Swap(C1, C2: in out Container) is <>;

   -- Forward Container Operations

   with function "="(A, B : in Container) return Boolean is <>;

   -- Sequence Container Operations

   -- XXX : Missing Constructors

   with function Front(C: in Container)
                       return Forward_Iterators.Value_Type is <>;
   with procedure Insert(C: in out Container;
                         Position: in Forward_Iterators.Iterator;
                         N: in Size_Type_Operations.T;
                         X: in Forward_Iterators.Value_Type) is <>;
   with procedure Insert(C: in out Container;
                         Position : in Forward_Iterators.Iterator;
                         X: in Forward_Iterators.Value_Type;
                         I: out Forward_Iterators.Iterator) is <>;

   -- XXX : It is not clear how to pass this generic function.  It seems
   --       like the only way is to add Other_Iterators to the generic
   --       parameters.  However, then we would need a new instantiation
   --       of Sequence for each Other_Iterators type !
   -- generic
   --   with package Other_Iterators is new SGL.Input_Iterators(<>);
   --   with function Val(X: Other_Iterators.Iterator)
   --                     return Value_Type;
   -- procedure Insert_Range(C: in out Container;
   --                        Position: in Iterator;
   --                        First, Last : in Other_Iterators.Iterator);

   with procedure Erase(C : in out Container;
                        Position : in Forward_Iterators.Iterator) is <>;
   with procedure Erase(C : in out Container;
                        First, Last : in Forward_Iterators.Iterator) is <>;

   -- Back Insertion Sequence Container Operations

   with function Back(C: in Container)
                      return Forward_Iterators.Value_Type is <>;
   with procedure Push_Back(C: in out Container;
                            E: in Forward_Iterators.Value_Type) is <>;
   with procedure Pop_Back(C: in out Container) is <>;


package SGL.Back_Insertion_Sequence_Containers is
   subtype Value_Type is Forward_Iterators.Value_Type;
   procedure Assign(To: in out Value_Type; From: Value_Type)
     renames Forward_Iterators.Assign;
   subtype Iterator is Forward_Iterators.Iterator;
   subtype Constant_Iterator is Forward_Iterators.Iterator;
   subtype Pointer is Forward_Iterators.Pointer;
   subtype Constant_Pointer is Forward_Iterators.Constant_Pointer;
   subtype Size_Type is Size_Type_Operations.T;
   subtype Difference_Type is Difference_Type_Operations.T;
   subtype Distance_Type is Difference_Type_Operations.T;
   package Distance_Type_Operations renames Difference_Type_Operations;

   -- XXX Gnat 3.09 bug forces renaming
   subtype Iterator_Category is Iterator_Category_GNAT;

   generic
      with function "<"(A, B : in Container) return Boolean is <>;
      with function ">"(A, B : in Container) return Boolean is <>;
      with function "<="(A, B : in Container) return Boolean is <>;
      with function ">="(A, B : in Container) return Boolean is <>;
   package Optional_Operations is end;

end SGL.Back_Insertion_Sequence_Containers;
