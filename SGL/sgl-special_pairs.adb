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
--  $Id: sgl-special_pairs.adb,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

package body SGL.Special_Pairs is

   function First(P: in Pair_Type) return Key_T is
   begin
      return P.First;
   end First;

   function Second(P: in Pair_Type) return Data_T is
   begin
      return P.Second;
   end Second;

   procedure Set_Second(P: in out Pair_Type; V: in Data_T) is
   begin
      Assign(P.Second, V);
   end Set_Second;

   function Ref_Second(P: in Pair_Type_Pointer) return Data_Pointer is
   begin
      return(P.Second'Access);
   end Ref_Second;

   function "<"(A, B: Pair_Type) return Boolean is
   begin
      return (A.First < B.First);
   end "<";

end SGL.Special_Pairs;
