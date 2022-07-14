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
--  $Id: sgl-special_pairs.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

generic

   type Key_T is limited private;
   with function"<"(A, B: Key_T) return Boolean;
   with procedure Assign(To: in out Key_T; From: in Key_T) is <>;
   type Data_T is limited private;
   with function "="(Left, Right: in Data_T) return Boolean is <>;
   with procedure Assign(To: in out Data_T; From: in Data_T) is <>;

package SGL.Special_Pairs is

   type Data_Pointer is access all Data_T;
   type Pair_Type is limited private;
   type Pair_Type_Pointer is access all Pair_Type;

   -- accessors

   function First(P: in Pair_Type) return Key_T;
   pragma InLine(First);

   function Second(P: in Pair_Type) return Data_T;
   pragma InLine(Second);

   function "<"(A, B: Pair_Type) return Boolean;
   pragma Inline("<");

   -- modifiers

   procedure Set_Second(P: in out Pair_Type; V: in Data_T);
   pragma InLine(Set_Second);

   function Ref_Second(P: in Pair_Type_Pointer) return Data_Pointer;
   pragma InLine(Ref_Second);

private

   type Pair_Type is limited
      record
         First : Key_T;
         Second : aliased Data_T;
      end record;

end SGL.Special_Pairs;

