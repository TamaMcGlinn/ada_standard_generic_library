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
--  $Id: sgl-integer_operations.ads,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with Ada.Text_IO;

generic
   type T is range <>;
   with function Equal(A, B: in T) return Boolean is <>;
   with function Less_Than(A, B: in T) return Boolean is <>;
   with function Greater_Than(A, B: in T) return Boolean is <>;
   with function Less_Than_Equal(A, B: in T) return Boolean is <>;
   with function Greater_Than_Equal(A, B: in T) return Boolean is <>;
   with function Subtract(A, B: in T) return T is <>;
   with function Add(A, B: in T) return T is <>;
   with function Multiply(A, B: in T) return T is <>;
   with function Divide(A, B: in T) return T is <>;
   with procedure Put_Item(Item  : in T;
                           Width : in Ada.Text_IO.Field;
                           Base  : in Ada.Text_IO.Number_Base) is <>;

   -- XXX - Gnat 3.09 bug requires that we rename the functions (go figure!)

--    with function "=" (A, B: in T) return Boolean is <>;
--    with function "<" (A, B: in T) return Boolean is <>;
--    with function ">" (A, B: in T) return Boolean is <>;
--    with function "<="(A, B: in T) return Boolean is <>;
--    with function ">="(A, B: in T) return Boolean is <>;
--    with function "-" (A, B: in T) return T is <>;
--    with function "+" (A, B: in T) return T is <>;
--    with function "*" (A, B: in T) return T is <>;
--    with function "/" (A, B: in T) return T is <>;
--    with procedure Put(Item  : in T;
--                       Width : in Ada.Text_IO.Field;
--                       Base  : in Ada.Text_IO.Number_Base) is <>;

package SGL.Integer_Operations is
   function "=" (A, B: in T) return Boolean renames Equal;
   function "<" (A, B: in T) return Boolean renames Less_Than;
   function ">" (A, B: in T) return Boolean renames Greater_Than;
   function "<="(A, B: in T) return Boolean renames Less_Than_Equal;
   function ">="(A, B: in T) return Boolean renames Greater_Than_Equal;
   function "-" (A, B: in T) return T renames Subtract;
   function "+" (A, B: in T) return T renames Add;
   function "*" (A, B: in T) return T renames Multiply;
   function "/" (A, B: in T) return T renames Divide;
   procedure Put(Item  : in T;
                      Width : in Ada.Text_IO.Field;
                      Base  : in Ada.Text_IO.Number_Base) renames Put_Item;
end SGL.Integer_Operations;
