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

with SGL.Integer_Operations;

generic
   type Value_Type is limited private;
   with procedure Assign(To: in out Value_Type; From: in Value_Type) is <>;

   type Iterator is private;
   type Constant_Iterator is private;
   type Pointer is private;
   type Constant_Pointer is private;

   with package Distance_Type_Operations is new SGL.Integer_Operations(<>);

   type Iterator_Category is private;

   with procedure Inc(I: in out Iterator) is <>;
   with procedure Inc(I: in out Constant_Iterator) is <>;

   with function Next(I: in Iterator) return Iterator is <>;
   with function Next(I: in Constant_Iterator) return Constant_Iterator is <>;

   with procedure Dec(I: in out Iterator) is <>;
   with procedure Dec(I: in out Constant_Iterator) is <>;

   with function Prev(I: in Iterator) return Iterator is <>;
   with function Prev(I: in Constant_Iterator) return Constant_Iterator is <>;

   with function "="(I, J: Iterator) return Boolean is <>;
   with function "="(I, J: Constant_Iterator) return Boolean is <>;

   with function Val(I: in Iterator) return Value_Type is <>;
   with function Val(I: in Constant_Iterator) return Value_Type is <>;

   with procedure Assign(I: in out Iterator; V: in Value_Type) is <>;

   with function Ref(I: in Iterator) return Pointer is <>;
   with function Ref(I: in Constant_Iterator) return Constant_Pointer is <>;

   with function Make_Constant(I: in Iterator) return Constant_Iterator is <>;

package SGL.Bidirectional_Iterators is
   subtype Distance_Type is Distance_Type_Operations.T;

end SGL.Bidirectional_Iterators;


