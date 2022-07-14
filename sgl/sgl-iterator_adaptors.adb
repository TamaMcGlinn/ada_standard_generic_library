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

with Unchecked_Conversion;

package body SGL.Iterator_Adaptors is

   -- Back_Insert

   package body Back_Insert_Iterators is
      procedure Inc(I: in out Iterator) is
      begin
         null;
      end;

      procedure Assign(I: in out Iterator; V: Value_Type) is
      begin
         Containers.Push_Back(I.C_Ptr.all, V);
      end;

      function Make_Iterator(C: in Container_Pointer) return Iterator is
         I: Iterator;
      begin
         I.C_Ptr := C;
         return I;
      end Make_Iterator;
   end Back_Insert_Iterators;

   -- Front_Insert

   package body Front_Insert_Iterators is
      procedure Inc(I: in out Iterator) is
      begin
         null;
      end;

      procedure Assign(I: in out Iterator; V: Value_Type) is
      begin
         Containers.Push_Front(I.C_Ptr.all, V);
      end;

      function Make_Iterator(C: in Container_Pointer) return Iterator is
         I: Iterator;
      begin
         I.C_Ptr := C;
         return I;
      end Make_Iterator;

   end Front_Insert_Iterators;

   -- Insert

   package body Insert_Iterators is

      procedure Inc(I: in out Iterator) is
      begin
         null;
      end;

      procedure Assign(I: in out Iterator; V: Value_Type) is
         K: Containers.Iterator;
      begin
         Containers.Insert(I.C_Ptr.all, I.Iter, V, K);
         I.Iter := K;
      end;

      function Make_Iterator(C: in Container_Pointer;
                             J: in Containers.Iterator)
                             return Iterator is
         I: Iterator;
      begin
         I.C_Ptr := C;
         I.Iter := J;
         return I;
      end Make_Iterator;

   end Insert_Iterators;

end SGL.Iterator_Adaptors;
