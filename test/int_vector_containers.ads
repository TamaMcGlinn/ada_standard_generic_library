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
--  $Id: int_vector_containers.ads,v 2.1 1997/07/12 00:40:37 akonstan Exp $
--

with SGL.Containers;
with Int_Vectors;
with Int_Vector_Signatures;

use Int_Vectors;
use Int_Vector_Signatures;

package Int_Vector_Containers is
  new SGL.Containers(Vector, Vector_Pointer, Vector_Constant_Pointer,
                     Vector_Input_Iterators, Constant_Iterator,
                     Size_Type_Operations, Difference_Type_Operations,
                     Iterator_Category, Verify_Tag);
