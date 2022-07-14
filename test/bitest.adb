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
-- "%Z% %Y% $Id: bitest.adb,v 2.1 1997/07/12 00:40:37 akonstan Exp $ "
--

with Gnat.IO; use Gnat.IO;

-- Containers
with Int_Lists; use Int_Lists;

-- Iterators
with Input_Iterators;
with Output_Iterators;
with Bidirectional_Iterators;
with Forward_Iterators;

-- Algorithms
with Input_Output_Algorithms;
with Forward_Algorithms;
with Bidirectional_Algorithms;

-- Other
with Accumulator;
with Ostream_Iterators;

procedure bitest is
   
   package IL renames Int_Lists;
   use IL.Iterators;
   
   procedure My_Put(V : Integer) is
   begin
      Put(V);
      Put(" ");
   end My_Put;
   
   package OS_Iter is new Ostream_Iterators(Integer, My_Put);
   use OS_Iter;
   
   package IL_Output_Iter is new Output_Iterators(Integer, OS_Iter.Iterator);
     
     -- Instantiate required algorithms packages
     
   package IL_Input_Output_Algo is
     new Input_Output_Algorithms(IL.Input_Iterator, IL_Output_Iter);
   use IL_Input_Output_Algo;
   package IL_Forward_Algo is new Forward_Algorithms(IL.Forward_Iterator); 
   use IL_Forward_Algo;
   package IL_Bidirectional_Algo is
     new Bidirectional_Algorithms(IL.Bidirectional_Iterator); 
   use IL_Bidirectional_Algo;
	   
   -- Instantiate required generic algorithms
   
   function Find is new IL_Forward_Algo.Find( "=" );
   package IL_Accumulator is new Accumulator(Integer,0,"+");
   procedure Sum_Up is new IL_Forward_Algo.Apply( IL_Accumulator.Add );
   
   
   -- Variables
   
   Cnt : Integer;
   I : IL.Iterators.Iterator;
   E : IL.Iterators.Iterator;
   L : List;
   OS : OS_Iter.Iterator;
   
begin
   
   Put_Line ("Welcome to test_bidirectional !");
   New_Line;
   Put ("Please enter a positive integer now followed by <CR> ");
   Get (Cnt);
   
   Put ("Inserting 1..");  Put (Cnt);  Put (" into a list.");  New_Line (2);
   for I in 1 .. Cnt loop
      Push_Back( L, I );
   end loop;
   Put( "The list now contains " ); 
--   Put( Size(L) ); 
   Put( " elements." ); 
   New_Line;
   
   Put_Line("Printing from Start to Finish.");
   OS := Copy(Start(L), Finish(L), OS);
   New_Line; New_Line;
   
   Put( "Removing the latter half of the list using pop_back" ); New_Line;
   for I in 1 .. Cnt/2 loop
      Pop_Back( L );
   end loop;
--   Put( "The list now contains " ); Put( Size(L) ); 
   Put( " elements." ); New_Line;
   
   Put_Line ("Printing from Start to Finish."); 
   OS := Copy(Start(L), Finish(L), OS);
   New_Line; New_Line;
   
   Put_Line( "Reversing the list" ); 
   IL_Bidirectional_Algo.Reverse_Range( Start(L), Finish(L) );
   
   Put_Line ("Printing from Start to Finish.");
   OS := Copy(Start(L), Finish(L), OS);
   New_Line; New_Line;
   
   Put( "Looking for " ); Put( Cnt/4 ); Put( " ... " );
   if Find( Start(L), Finish(L), Cnt/4 ) /= Finish(L) then
      Put_Line( "Found ! (OK)" );
   else
      Put_Line( "Not Found !  (ERROR)" );
   end if;
   
   Put( "Looking for " ); Put( Cnt ); Put( " ... " );
   if Find( Start(L), Finish(L), Cnt ) /= Finish(L) then
      Put_Line( "Found ! (ERROR)" );
   else
      Put_Line( "Not Found ! (OK)" );
   end if;
   
   Put( "Accumulating contents of list ... " );
   Sum_Up( Start(L), Finish(L) );
   Put( "Sum is: " ); Put( IL_Accumulator.Sum ); New_Line;
   
   Put( "Accumulating another pass..." ); New_Line;
   Sum_Up( Start(L), Finish(L) );
   Put( "New sum is: " ); Put( IL_Accumulator.Sum ); New_Line;
   
   Put ("Printing from Start to Finish.");  New_Line;
   OS := Copy(Start(L), Finish(L), OS);
   New_Line; New_Line;
   New_Line;
   Put_Line( "End of Test_Bidirectional");
end Bitest;
