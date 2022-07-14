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
with SGL.Input_Iterators;
with SGL.Output_Iterators;

generic
   -- Types
   type Container is new Ada.Finalization.Controlled with private;
   type Container_Pointer is access Container;
   type Container_Constant_Pointer is access constant Container;

   with package Input_Iterators is new SGL.Input_Iterators(<>);

   -- XXX Gnat 3.09 bug forces renaming
   type Constant_Iterator_GNAT is private;

   with package Size_Type_Operations is new SGL.Integer_Operations(<>);
   with package Difference_Type_Operations is new SGL.Integer_Operations(<>);

   -- XXX Gnat 3.09 bug forces renaming
   type Iterator_Category_GNAT is private;
   with function Verify_Tag(T: Iterator_Category_GNAT)
                            return Iterator_Category_GNAT is <>;

   -- Operations

   with function Start(C: in Container_Pointer)
                       return Input_Iterators.Iterator is <>;
   with function Start(C: in Container)
                       return Constant_Iterator_GNAT is <>;
   with function Finish(C: in Container_Pointer)
                        return Input_Iterators.Iterator is <>;
   with function Finish(C: in Container)
                        return Constant_Iterator_GNAT is <>;

   with function Size(C: in Container) return Size_Type_Operations.T is <>;
   with function Max_Size(C: in Container) return Size_Type_Operations.T is <>;
   with function Empty(C: in Container) return Boolean is <>;
   with procedure Swap(C1, C2: in out Container) is <>;


package SGL.Containers is
   subtype Value_Type is Input_Iterators.Value_Type;
   subtype Iterator is Input_Iterators.Iterator;
   subtype Size_Type is Size_Type_Operations.T;
   subtype Difference_Type is Difference_Type_Operations.T;
   subtype Distance_Type is Difference_Type_Operations.T;
   package Distance_Type_Operations renames Difference_Type_Operations;

   -- XXX Gnat 3.09 bug forces renaming
   subtype Iterator_Category is Iterator_Category_GNAT;
   subtype Constant_Iterator is Constant_Iterator_GNAT;

end SGL.Containers;


