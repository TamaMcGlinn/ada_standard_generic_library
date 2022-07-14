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
--  $Id: int_list_queues.ads,v 2.1 1997/07/12 00:40:37 akonstan Exp $
--

with SGL.Queues;
with Int_Lists; use Int_Lists;
with Int_List_Containers;

package Int_List_Queues is new SGL.Queues(Int_List_Containers);
