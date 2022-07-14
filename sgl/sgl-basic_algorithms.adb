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

package body SGL.Basic_Algorithms is

   procedure Iter_Swap(A: in out Iterators1.Iterator;
                       B: in out Iterators2.Iterator) is
      Tmp : Iterators2.Value_Type;
   begin
      Iterators2.Assign(Tmp, Val2(A));

      Iterators1.Assign(A, Val1(B));
      Iterators2.Assign(B, Tmp);
   end Iter_Swap;

   procedure Swap(A, B: in out T) is
      Tmp: T := A;
   begin
      A := B;
      B := Tmp;
   end Swap;

   function Generic_Min(A, B: in T) return T is
   begin
      if  (B < A) then
         return B;
      else
         return A;
      end if;
   end Generic_Min;

   function Generic_Max(A, B: in T) return T is
   begin
      if  (A < B) then
         return B;
      else
         return A;
      end if;
   end Generic_Max;


   -- Distance

   procedure Input_Distance(First, Last: Iterators.Iterator;
                            N: in out Iterators.Distance_Type) is
      use Iterators;
      Cur : Iterator := First;
   begin
      while(Cur /= Last) loop
         Inc(Cur);
         N := Distance_Type'Succ(N);
      end loop;
   end Input_Distance;

   procedure Forward_Distance(First, Last: Iterators.Constant_Iterator;
                              N: in out Iterators.Distance_Type) is
     use Iterators;
     Cur : Constant_Iterator := First;
   begin
      while(Cur /= Last) loop
         Inc(Cur);

      end loop;
   end Forward_Distance;

   procedure Bidirectional_Distance(First, Last: Iterators.Constant_Iterator;
                                    N: in out Iterators.Distance_Type) is
     use Iterators;
     Cur : Constant_Iterator := First;
   begin
      while(Cur /= Last) loop
         Inc(Cur);
         N := Distance_Type'Succ(N);
      end loop;
   end Bidirectional_Distance;

   procedure Random_Access_Distance(First, Last: Iterators.Constant_Iterator;
                                    N: in out Iterators.Distance_Type) is
     use Iterators;
     use Iterators.Distance_Type_Operations;
   begin
      N := N + (Last - First);
   end Random_Access_Distance;

   -- Advance

   procedure Input_Advance(I: in out Iterators.Iterator;
                           N: in Iterators.Distance_Type) is
      use Iterators;
      use Iterators.Distance_Type_Operations;

      Count : Distance_Type := N;
   begin
      while (Count > Zero) loop
         Count := Distance_Type'Pred(Count);
         Inc(I);
      end loop;
   end Input_Advance;

   procedure Forward_Advance(I: in out Iterators.Constant_Iterator;
                             N: in Iterators.Distance_Type) is
     use Iterators;
     use Iterators.Distance_Type_Operations;

     Count : Distance_Type := N;
   begin
      while (Count > Zero) loop
         Count := Distance_Type'Pred(Count);
         Inc(I);
      end loop;
   end Forward_Advance;

   procedure Bidirectional_Advance(I: in out Iterators.Constant_Iterator;
                                   N: in Iterators.Distance_Type) is
     use Iterators;
     use Iterators.Distance_Type_Operations;

     Count : Distance_Type := N;
   begin
      if (Zero > Count) then
         while (Zero > Count) loop
            Count := Distance_Type'Succ(Count);
            Dec(I);
         end loop;
      else
         while (Count > Zero) loop
            Count := Distance_Type'Pred(Count);
            Inc(I);
         end loop;
      end if;
   end Bidirectional_Advance;

   procedure Random_Access_Advance(I: in out Iterators.Constant_Iterator;
                                   N: in Iterators.Distance_Type) is
      use Iterators;
   begin
      IncBy(I, N);
   end Random_Access_Advance;

   function Copy(First, Last: Input_Iterators.Iterator;
                 Result: Output_Iterators.Iterator)
                 return Output_Iterators.Iterator is
      Src : Input_Iterators.Iterator := First;
      Dest: Output_Iterators.Iterator := Result;
      function "="(A, B :Input_Iterators.Iterator) return Boolean
        renames Input_Iterators."=";
   begin
      while (Src /= Last) loop
         Output_Iterators.Assign(Dest, Val(Src));
         Output_Iterators.Inc(Dest);
         Input_Iterators.Inc(Src);
      end loop;

      return Dest;
   end Copy;

   function Copy_Backward(First, Last: Iterators1.Constant_Iterator;
                          Result : Iterators2.Iterator)
                          return Iterators2.Iterator is
      Src : Iterators1.Constant_Iterator := Last;
      Dest: Iterators2.Iterator := Result;
      function "="(A, B :Iterators1.Constant_Iterator) return Boolean
        renames Iterators1."=";
   begin
      while (Src /= First) loop
         Iterators2.Dec(Dest);
         Iterators1.Dec(Src);
         Iterators2.Assign(Dest, Val(Src));
      end loop;

      return Dest;
   end Copy_Backward;


   procedure Fill(First, Last: Iterators.Iterator;
                 Value: Iterators.Value_Type) is
      Cur : Iterators.Iterator := First;
      use Iterators;
   begin
      while (Cur /= Last) loop
         Assign(Cur, Value);
         Inc(Cur);
      end loop;
   end Fill;

   function Fill_N(First, Last: Iterators.Iterator;
                   N: Size_Type;
                   Value: Iterators.Value_Type)
                   return Iterators.Iterator is
      Cur   : Iterators.Iterator := First;
      Count : Size_Type := N;
      use Iterators;
   begin
      while (Count > Zero) loop
         Count := Size_Type'Pred(Count);
         Assign(Cur, Value);
         Inc(Cur);
      end loop;

      return Cur;
   end Fill_N;

   function Mismatch(First1, Last1: Iterators1.Iterator;
                     First2: Iterators2.Iterator)
                     return Iterator_Pairs.Pair is
     Cur1 : Iterators1.Iterator := First1;
     Cur2 : Iterators2.Iterator := First2;
     function "="(A, B :Iterators1.Iterator) return Boolean
       renames Iterators1."=";
   begin
      while (Cur1 /= Last1) and then
        (Iterators1.Val(Cur1) = Iterators2.Val(Cur2)) loop
         Iterators1.Inc(Cur1);
         Iterators2.Inc(Cur2);
      end loop;

      return Iterator_Pairs.Make_Pair(Cur1, Cur2);
   end Mismatch;

   function Equal(First1, Last1: Iterators1.Iterator;
                  First2: Iterators2.Iterator) return Boolean is
      -- XXX GNAT BUG !  The following hides the instantiation "="
      --   package Iterator_Pairs is new SGL.Pairs(Iterators1.Iterator,
      --                                        Iterators2.Iterator,
      --                                        Iterators1."=",
      --                                        Iterators2."=");
      --  function M is new Mismatch(Iterators1, Iterators2, Iterator_Pairs);
      --  Tmp_Pair : Iterators_Pairs.Pair := M(First1, Last1, First2);

      -- Workaround : don't use mismatch !
      Cur1 : Iterators1.Iterator := First1;
      Cur2 : Iterators2.Iterator := First2;
   begin
      while (Iterators1."/="(Cur1, Last1)) and then
        (Iterators1.Val(Cur1) = Iterators2.Val(Cur2)) loop
         Iterators1.Inc(Cur1);
         Iterators2.Inc(Cur2);
      end loop;

      return (Iterators1."="(Cur1, Last1));
      --  return (Iterators1."="(Tmp_Pair.First, Last1));
   end Equal;


   function Lexicographical_Compare(First1, Last1: Iterators1.Iterator;
                                    First2, Last2: Iterators2.Iterator)
                                    return Boolean is
      Cur1 : Iterators1.Iterator := First1;
      Cur2 : Iterators2.Iterator := First2;
   begin
      while (Iterators1."/="(Cur1, Last1)) and then
        (Iterators2."/="(Cur2, Last2)) loop
         if (Less_Than12(Iterators1.Val(Cur1), Iterators2.Val(Cur2))) then
            return True;
         end if;
         if (Less_Than21(Iterators2.Val(Cur2), Iterators1.Val(Cur1))) then
            return False;
         else
            Iterators1.Inc(Cur1);
            Iterators2.Inc(Cur2);
         end if;
      end loop;

      return (Iterators1."="(Cur1, Last1) and then
              (Iterators2."/="(Cur2, Last2)));
   end Lexicographical_Compare;

end SGL.Basic_Algorithms;
