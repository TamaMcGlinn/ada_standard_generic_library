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

with SGL.Random_Access_Iterators;

generic
   with package Random_Access_Iterators is
    new SGL.Random_Access_Iterators(<>);

package SGL.Reverse_Random_Access_Iterators is
   type Reverse_Iterator is private;
   type Constant_Reverse_Iterator is private;

   subtype Value_Type is Random_Access_Iterators.Value_Type;
   procedure Assign(To: in out Value_Type; From: in Value_Type)
     renames Random_Access_Iterators.Assign;

   subtype Iterator is Random_Access_Iterators.Iterator;
   subtype Constant_Iterator is Random_Access_Iterators.Constant_Iterator;

   subtype Pointer is Random_Access_Iterators.Pointer;
   subtype Constant_Pointer is Random_Access_Iterators.Constant_Pointer;
   subtype Distance_Type is Random_Access_Iterators.Distance_Type;
   package Distance_Type_Operations renames
     Random_Access_Iterators.Distance_Type_Operations;

   subtype Iterator_Category is Random_Access_Iterators.Iterator_Category;

   procedure Inc(I: in out Reverse_Iterator);
   procedure Inc(I: in out Constant_Reverse_Iterator);
   pragma Inline (Inc);

   function Next(I: in Reverse_Iterator) return Reverse_Iterator;
   function Next(I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator;
   pragma Inline (Next);

   procedure Dec(I: in out Reverse_Iterator);
   procedure Dec(I: in out Constant_Reverse_Iterator);
   pragma Inline (Dec);

   function Prev(I: in Reverse_Iterator) return Reverse_Iterator;
   function Prev(I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator;
   pragma Inline (Prev);

   procedure IncBy(I: in out Reverse_Iterator; K : Distance_Type);
   procedure IncBy(I: in out Constant_Reverse_Iterator; K : Distance_Type);
   pragma Inline (IncBy);

   procedure DecBy(I: in out Reverse_Iterator; K : Distance_Type);
   procedure DecBy(I: in out Constant_Reverse_Iterator; K : Distance_Type);
   pragma Inline (DecBy);

   function "=" (I, J : in Reverse_Iterator) return Boolean;
   function "=" (I, J : in Constant_Reverse_Iterator) return Boolean;
   pragma Inline ("=");

   function "+" (I: in Reverse_Iterator; K : Distance_Type)
                 return Reverse_Iterator;
   function "+" (I: in Constant_Reverse_Iterator; K : Distance_Type)
                 return Constant_Reverse_Iterator;
   function "+" (K : Distance_Type; I: in Reverse_Iterator)
                 return Reverse_Iterator;
   function "+" (K : Distance_Type; I: in Constant_Reverse_Iterator)
                 return Constant_Reverse_Iterator;
   pragma Inline ("+");

   function "-" (I, J: in Reverse_Iterator) return Distance_Type;
   function "-" (I, J: in Constant_Reverse_Iterator) return Distance_Type;
   function "-" (I: in Reverse_Iterator; K: Distance_Type)
                 return Reverse_Iterator;
   function "-" (I: in Constant_Reverse_Iterator; K: Distance_Type)
                 return Constant_Reverse_Iterator;
   pragma Inline ("-");

   function "<" (I, J: in Reverse_Iterator) return Boolean;
   function "<" (I, J: in Constant_Reverse_Iterator) return Boolean;
   pragma Inline ("<");

   function ">" (I, J: in Reverse_Iterator) return Boolean;
   function ">" (I, J: in Constant_Reverse_Iterator) return Boolean;
   pragma Inline (">");

   function "<=" (I, J: in Reverse_Iterator) return Boolean;
   function "<=" (I, J: in Constant_Reverse_Iterator) return Boolean;
   pragma Inline ("<=");

   function ">=" (I, J: in Reverse_Iterator) return Boolean;
   function ">=" (I, J: in Constant_Reverse_Iterator) return Boolean;
   pragma Inline (">=");

   function Val(I: in Reverse_Iterator) return Value_Type;
   function Val(I: in Constant_Reverse_Iterator) return Value_Type;
   pragma Inline (Val);

   procedure Assign(I: in out Reverse_Iterator; V: in Value_Type);
   pragma Inline (Assign);

   function Ref(I: in Reverse_Iterator) return Pointer;
   function Ref(I: in Constant_Reverse_Iterator) return Constant_Pointer;
   pragma Inline (Ref);

   function Make_Constant(I: in Reverse_Iterator)
                          return Constant_Reverse_Iterator;
   pragma Inline(Make_Constant);

   function Make_Reverse(I: in Iterator) return Reverse_Iterator;
   function Make_Reverse(I: in Constant_Iterator)
                         return Constant_Reverse_Iterator;
   pragma Inline(Make_Reverse);

   function Get_Iterator(I: in Reverse_Iterator) return Iterator;
   function Get_Iterator(I: in Constant_Reverse_Iterator)
                         return Constant_Iterator;
   pragma Inline(Get_Iterator);


   --
   -- private
   --
private

   type Reverse_Iterator is record
      Iter : Iterator;
   end record;

   type Constant_Reverse_Iterator is record
      Iter : Constant_Iterator;
   end record;

end SGL.Reverse_Random_Access_Iterators;
