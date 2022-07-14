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
--  $Id: sgl-iterator_adaptors.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL.Sequence_Containers;
with SGL.Front_Insertion_Sequence_Containers;
with SGL.Back_Insertion_Sequence_Containers;

with SGL.Iterator_Tags;

package SGL.Iterator_Adaptors is

   -- Back Insert

   generic
      with package Containers is
       new SGL.Back_Insertion_Sequence_Containers(<>);
   package Back_Insert_Iterators is
      subtype Container_Pointer is Containers.Container_Pointer;

      subtype Value_Type is Containers.Value_Type;
      procedure Assign(To: in out Value_Type; From: Value_Type)
        renames Containers.Forward_Iterators.Assign;

      type Iterator is private;

      package Distance_Type_Operations
        renames Containers.Distance_Type_Operations;

      subtype Iterator_Category is SGL.Iterator_Tags.Output_Iterator_Tag;
      function Identity(T: Iterator_Category) return Iterator_Category
        renames SGL.Iterator_Tags.Identity;

      procedure Inc(I: in out Iterator);
      pragma Inline(Inc);

      procedure Assign(I: in out Iterator; V: Value_Type);
      pragma Inline(Assign);

      function Make_Iterator(C: in Container_Pointer) return Iterator;
      pragma Inline(Make_Iterator);

   private
      type Iterator is record
         C_Ptr : Container_Pointer := null;
      end record;

   end Back_Insert_Iterators;

   -- Front Insert

   generic
      with package Containers is
       new SGL.Front_Insertion_Sequence_Containers(<>);

   package Front_Insert_Iterators is
      subtype Container_Pointer is Containers.Container_Pointer;

      subtype Value_Type is Containers.Value_Type;
      procedure Assign(To: in out Value_Type; From: Value_Type)
        renames Containers.Forward_Iterators.Assign;

      type Iterator is private;

      package Distance_Type_Operations
        renames Containers.Distance_Type_Operations;

      subtype Iterator_Category is SGL.Iterator_Tags.Output_Iterator_Tag;
      function Identity(T: Iterator_Category) return Iterator_Category
        renames SGL.Iterator_Tags.Identity;

      procedure Inc(I: in out Iterator);
      pragma Inline(Inc);

      procedure Assign(I: in out Iterator; V: Value_Type);
      pragma Inline(Assign);

      function Make_Iterator(C: in Container_Pointer) return Iterator;
      pragma Inline(Make_Iterator);

   private
      type Iterator is record
         C_Ptr : Container_Pointer := null;
      end record;

   end Front_Insert_Iterators;

   -- Insert

   generic
      with package Containers is
       new SGL.Sequence_Containers(<>);

   package Insert_Iterators is
      subtype Container_Pointer is Containers.Container_Pointer;

      subtype Value_Type is Containers.Value_Type;
      procedure Assign(To: in out Value_Type; From: in Value_Type)
        renames Containers.Forward_Iterators.Assign;

      type Iterator is private;

      package Distance_Type_Operations
        renames Containers.Distance_Type_Operations;

      subtype Iterator_Category is SGL.Iterator_Tags.Output_Iterator_Tag;
      function Identity(T: Iterator_Category) return Iterator_Category
        renames SGL.Iterator_Tags.Identity;

      procedure Inc(I: in out Iterator);
      pragma Inline(Inc);

      procedure Assign(I: in out Iterator; V: Value_Type);
      pragma Inline(Assign);

      function Make_Iterator(C: in Container_Pointer;
                             J: in Containers.Iterator) return Iterator;
      pragma Inline(Make_Iterator);

   private
      type Iterator is record
         C_Ptr : Container_Pointer := null;
         Iter  : Containers.Iterator;
      end record;

   end Insert_Iterators;

   -- XXX : Missing istream and ostream adaptors.  Currently ostream
   --       is available as a separate package, but should really be
   --       moved here.  An istream package should also be created.

end SGL.Iterator_Adaptors;
