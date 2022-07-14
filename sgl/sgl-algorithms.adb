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
--

with SGL.Basic_Algorithms;

package body SGL.Algorithms is

   procedure For_Each(First, Last: in Iterators.Iterator) is
      use Iterators;
      Cur : Iterator := First;
   begin
      while (Cur /= Last) loop
         F(Val(Cur));
         Inc(Cur);
      end loop;
   end For_Each;

   function Find(First, Last: in Iterators.Iterator;
                 Value: in Iterators.Value_Type)
                 return Iterators.Iterator is
      use Iterators;
      Cur : Iterator := First;
   begin
      while (Cur /= Last) and then (Val(Cur) /= Value) loop
         Inc(Cur);
      end loop;

      return Cur;
   end Find;

   function Find_If(First, Last: in Iterators.Iterator)
     return Iterators.Iterator is
      use Iterators;
      Cur : Iterator := First;
   begin
      while (Cur /= Last) and then (not Predicate(Val(Cur))) loop
         Inc(Cur);
      end loop;

      return Cur;
   end Find_If;

   function Adjacent_Find(First, Last : Iterators.Constant_Iterator)
                          Return Iterators.Constant_Iterator is
      use Iterators;
      Next : Constant_Iterator := First;
      Cur  : Constant_Iterator := First;
   begin
      if (First = Last) then
         return Last;
      end if;

      Inc(Next);
      while (Next /= Last) loop
         if (Val(Cur) = Val(Next)) then
            return Cur;
         end if;
         Cur := Next;
         Inc(Next);
      end loop;

      return Last;
   end Adjacent_Find;

   function Count(First, Last : Iterators.Iterator;
                  Value: Iterators.Value_Type)
                  return Iterators.Distance_Type is
      use Iterators;
      use Iterators.Distance_Type_Operations;
      Cur : Iterator := First;
      N : Distance_Type := Distance_Type'Val(0);
   begin
      while (Cur /= Last) loop
         if (Val(Cur) = Value) then
            N := Distance_Type'Succ(N);
         end if;
         Inc(Cur);
      end loop;

      return N;
   end Count;

   function Count_If(First, Last : Iterators.Iterator)
                     return Size_Type is
      use Iterators;
      Cur : Iterator := First;
      N : Size_Type := Size_Type'Val(0);
   begin
      while (Cur /= Last) loop
         if (Predicate(Val(Cur))) then
            N := Size_Type'Succ(N);
         end if;
         Inc(Cur);
      end loop;

      return N;
   end Count_If;


   function Generic_Search(First1, Last1: Iterators1.Constant_Iterator;
                           First2, Last2: Iterators2.Constant_Iterator)
                           return Iterators1.Constant_Iterator is
      D1 : Iterators1.Distance_Type := Iterators1.Distance_Type'Val(0);
      D2 : Iterators2.Distance_Type := Iterators2.Distance_Type'Val(0);
      Head1 : Iterators1.Constant_Iterator := First1;
      Current1 : Iterators1.Constant_Iterator := First1;
      Current2 : Iterators2.Constant_Iterator := First2;
   begin
      Distance1(Head1, Last1, D1);
      Distance2(First2, Last2, D2);

      if (D1 < D2) then
         return Last1;
      end if;

      while (Iterators2."/="(Current2, Last2)) loop
         if (Iterators1.Val(Current1) /= Iterators2.Val(Current2)) then
            Iterators1.Inc(Current1);
            Iterators2.Inc(Current2);
            if (D1 = D2) then
               return Last1;
            else
               D1 := Iterators1.Distance_Type'Pred(D1);
               Iterators1.Inc(Head1);
               Current1 := Head1;
               Current2 := First2;
            end if;
         else
            Iterators1.Inc(Current1);
            Iterators2.Inc(Current2);
         end if;
      end loop;

      if (Iterators2."="(Current2, Last2)) then
         return Head1;
      else
         return Last1;
      end if;
   end Generic_Search;

   function Swap_Ranges(First1, Last1 : Iterators1.Iterator;
                        First2 : Iterators2.Iterator)
                        return Iterators2.Iterator is
     Current1 : Iterators1.Iterator := First1;
     Current2 : Iterators2.Iterator := First2;

     -- XXX - GNAT 3.09 bug !!!!
     -- Workaround: do the swap ourselves !
     -- procedure Iter_Swap is new SGL.Basic_Algorithms.Iter_Swap
     --   (Iterators1, Iterators2, Val2, Val1);

     -- begin workaround
     Tmp : Iterators1.Value_Type;
     -- end workaround
   begin
      while (Iterators1."/="(Current1, Last1)) loop
         Iterators1.Inc(Current1);
         Iterators2.Inc(Current2);
         -- Iter_Swap(Current1, Current2);
         -- begin workaround
         Iterators1.Assign(Tmp, Val1(Current2));
         Iterators2.Assign(Current2, Val2(Current1));
         Iterators1.Assign(Current1, Tmp);
         -- end workaround
      end loop;

      return Current2;
   end Swap_Ranges;


   function Unary_Transform(First, Last : Input_Iterators.Iterator;
                            Result : Output_Iterators.Iterator)
                            return Output_Iterators.Iterator is
      Src  : Input_Iterators.Iterator  := First;
      Dest : Output_Iterators.Iterator := Result;
   begin
      while (Input_Iterators."/="(Src, Last)) loop
         Output_Iterators.Assign(Dest, Unary_Op(Input_Iterators.Val(Src)));
         Input_Iterators.Inc(Src);
         Output_Iterators.Inc(Dest);
      end loop;

      return Dest;
   end Unary_Transform;


   function Binary_Transform(First1, Last1 : Iterators1.Iterator;
                             First2 : Iterators2.Iterator;
                             Result : Output_Iterators.Iterator)
                             return Output_Iterators.Iterator is
      Src1 : Iterators1.Iterator := First1;
      Src2 : Iterators2.Iterator := First2;
      Dest : Output_Iterators.Iterator := Result;
   begin
      while (Iterators1."/="(Src1, Last1)) loop
         Output_Iterators.Assign(Dest, Binary_Op(Iterators1.Val(Src1),
                                                 Iterators2.Val(Src2)));
         Iterators1.Inc(Src1);
         Iterators2.Inc(Src2);
         Output_Iterators.Inc(Dest);
      end loop;

      return Dest;
   end Binary_Transform;


   procedure Replace(First, Last : Iterators.Iterator;
                     Old_Value, New_Value : Iterators.Value_Type) is
      use Iterators;

      Current : Iterators.Iterator := First;
   begin
      while(Current /= Last) loop
         if (Val(Current) = Old_Value) then
            Assign(Current, New_Value);
         end if;

         Inc(Current);
      end loop;
   end Replace;


   procedure Replace_If(First, Last : Iterators.Iterator;
                        New_Value : Iterators.Value_Type) is

      use Iterators;

      Current : Iterators.Iterator := First;
   begin
      while(Current /= Last) loop
         if (Predicate(Val(Current))) then
            Assign(Current, New_Value);
         end if;

         Inc(Current);
      end loop;
   end Replace_If;


   procedure Replace_Copy(First, Last : Input_Iterators.Iterator;
                          Result : Output_Iterators.Iterator;
                          Old_Value : Input_Iterators.Value_Type;
                          New_Value : Output_Iterators.Value_Type) is
      Current : Input_Iterators.Iterator := First;
      Dest    : Output_Iterators.Iterator := Result;
   begin
      while (Input_Iterators."/="(Current, Last)) loop
         if (Input_Iterators.Val(Current) = Old_Value) then
            Output_Iterators.Assign(Dest, New_Value);
         else
            Output_Iterators.Assign(Dest, Val(Current));
         end if;
         Input_Iterators.Inc(Current);
         Output_Iterators.Inc(Dest);
      end loop;
   end Replace_Copy;


   procedure Replace_Copy_If(First, Last : Input_Iterators.Iterator;
                             Result : Output_Iterators.Iterator;
                             New_Value : Output_Iterators.Value_Type) is
      Current : Input_Iterators.Iterator := First;
      Dest    : Output_Iterators.Iterator := Result;
   begin
      while (Input_Iterators."/="(Current, Last)) loop
         if (Predicate(Input_Iterators.Val(Current))) then
            Output_Iterators.Assign(Dest, New_Value);
         else
            Output_Iterators.Assign(Dest, Val(Current));
         end if;

         Output_Iterators.Inc(Dest);
         Input_Iterators.Inc(Current);
      end loop;
   end Replace_Copy_If;











   procedure Bidirectional_Reverse(First, Last: in Iterators.Iterator) is
      use Iterators;
      Front : Iterator := First;
      Back  : Iterator := Last;


      -- Gnat 3.09 reports "ambiguous ranaming" if all ops are not
      --   explicitely provided at signature instantiation (?!)
      package FIterators is new SGL.Forward_Iterators
        (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
         Constant_Pointer, Distance_Type_Operations, Iterator_Category,
         Inc, Inc, Next, Next, "=", "=", Val, Val, Assign, Ref,
         Ref, Make_Constant);

      procedure Iter_Swap is new SGL.Basic_Algorithms.Iter_Swap
        (FIterators, FIterators, Val, Val);
   begin
      while True loop
         if (Front = Back) then
            return;
         else
            Dec(Back);
            if (Front = Back) then
               return;
            else
               Iter_Swap(Front, Back);
               Inc(Front);
            end if;
         end if;
      end loop;
   end Bidirectional_Reverse;

   procedure Random_Access_Reverse(First, Last: in Iterators.Iterator) is
      Front : Iterators.Iterator := First;
      Back : Iterators.Iterator := Last;

      use Iterators;

      -- Gnat 3.09 reports "ambiguous ranaming" if all ops are not
      --   explicitely provided at signature instantiation (?!)
      package FIterators is new SGL.Forward_Iterators
        (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
         Constant_Pointer, Distance_Type_Operations, Iterator_Category,
         Inc, Inc, Next, Next, "=", "=", Val, Val, Assign, Ref,
         Ref, Make_Constant);

      procedure Iter_Swap is new SGL.Basic_Algorithms.Iter_Swap
        (FIterators, FIterators, Val, Val);
   begin
      while (Front < Back) loop
         Dec(Back);
         Iter_Swap(Front, Back);
         Inc(Front);
      end loop;
   end Random_Access_Reverse;


end SGL.Algorithms;
