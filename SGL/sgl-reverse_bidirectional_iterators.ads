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
--  $Id: sgl-reverse_bidirectional_iterators.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL.Bidirectional_Iterators;

generic
   with package Bidirectional_Iterators is new SGL.Bidirectional_Iterators(<>);

package SGL.Reverse_Bidirectional_Iterators is
   type Reverse_Iterator is private;
   type Constant_Reverse_Iterator is private;

   subtype Value_Type is Bidirectional_Iterators.Value_Type;
   procedure Assign(To: in out Value_Type; From: in Value_Type)
     renames Bidirectional_Iterators.Assign;

   subtype Iterator is Bidirectional_Iterators.Iterator;
   subtype Constant_Iterator is Bidirectional_Iterators.Constant_Iterator;
   subtype Pointer is Bidirectional_Iterators.Pointer;
   subtype Constant_Pointer is Bidirectional_Iterators.Constant_Pointer;
   subtype Distance_Type is Bidirectional_Iterators.Distance_Type;
   package Distance_Type_Operations renames
     Bidirectional_Iterators.Distance_Type_Operations;
   subtype Iterator_Category is Bidirectional_Iterators.Iterator_Category;

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

   function "=" (I, J : in Reverse_Iterator) return Boolean;
   function "=" (I, J : in Constant_Reverse_Iterator) return Boolean;
   pragma Inline ("=");

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

end SGL.Reverse_Bidirectional_Iterators;
