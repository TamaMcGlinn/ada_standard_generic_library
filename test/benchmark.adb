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
--  $Id: benchmark.adb,v 2.1 1997/07/12 00:40:37 akonstan Exp $
--

with Gnat.IO; use Gnat.IO;
with Int_Lists;
with Int_Vectors;
with Int_Sets;
with Int_Random;

procedure Benchmark is
   use Int_Lists;
   use Int_Vectors;
   use Int_Sets;

   L : aliased List;
   V : aliased Vector;
   S : aliased Set;
   Max_Count : constant Integer := 1000000;
begin
   Put_Line("*** Welcome to the container benchmark ***"); New_Line;

   for Count in 1..Max_Count loop
      Push_Back(L, Count);
   end loop;

   Erase(L, Start(L'Unchecked_Access), Finish(L'Unchecked_Access));

   for Count in 1..Max_Count loop
      Push_Back(V, Count);
   end loop;

   Erase(V, Start(V'Unchecked_Access), Finish(V'Unchecked_Access));

   declare
      S_I : Int_Sets.Constant_Iterator;
      Success : Boolean;
   begin
      for Count in 1..Max_Count loop
         Insert(S, Count, S_I, Success);
      end loop;
   end;

   -- XXX - this is a problem since we only have constant_iterators on sets...
--   Erase(S, Start(S'Unchecked_Access), Finish(S'Unchecked_Access));

   Put_Line("*** end container benchmark ***"); New_Line;

end Benchmark;
