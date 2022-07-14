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
with Unchecked_Deallocation;

with SGL.Output_Iterators;
with SGL.Forward_Iterators;
with SGL.Bidirectional_Iterators;
with SGL.Bidirectional_Constant_Iterators;
with SGL.Containers;
with SGL.Basic_Algorithms;

package body SGL.Vectors is

   -- Instantiate iterator signature packages

   package Vector_Input_Iterators is
     new SGL.Input_Iterators
     (Value_Type, Iterator, Distance_Type_Operations,
      Iterator_Category);

   package Vector_Input_Constant_Iterators is
     new SGL.Input_Iterators
     (Value_Type, Constant_Iterator, Distance_Type_Operations,
      Iterator_Category);

   package Vector_Output_Iterators is
     new SGL.Output_Iterators
     (Value_Type, Assign, Iterator, Distance_Type_Operations,
      Iterator_Category);

   package Vector_Forward_Iterators is
    new SGL.Forward_Iterators
     (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
      Constant_Pointer, Distance_Type_Operations, Iterator_Category);

   package Vector_Bidirectional_Iterators is
     new SGL.Bidirectional_Iterators
     (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
      Constant_Pointer, Distance_Type_Operations, Iterator_Category);

   package Vector_Bidirectional_Constant_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   -- Instantiate container signature


   -- Static variables
   -- (none)


   -- Controlled type procedures

   procedure Initialize(V: in out Vector) is
   begin
      V.VStart.Ptr  := null;
      V.VFinish.Ptr := null;
      V.End_Of_Storage.Ptr := null;
   end Initialize;

   procedure Adjust(V: in out Vector) is
      Copy_VStart  : Iterator := V.VStart;
      Copy_VFinish : Iterator := V.VFinish;
      Copy_Size : Size_Type := Size(V);
      function Uninitialized_Copy is new Value_Allocators.Uninitialized_Copy
        (Vector_Input_Constant_Iterators, Vector_Forward_Iterators);
   begin
      Initialize(V);
      V.VStart.Ptr  := Value_Allocators.Allocate(Copy_Size);
      V.VFinish :=
         V.VStart + Value_Allocators.To_Difference_Type(Copy_Size);
      V.End_Of_Storage := Uninitialized_Copy
        (Make_Constant(Copy_VStart), Make_Constant(Copy_VFinish), V.VStart);
   end Adjust;

   procedure Finalize(V: in out Vector) is
      procedure Destroy_Sequence is new Value_Allocators.Destroy_Sequence
        (Vector_Forward_Iterators);
   begin
      Destroy_Sequence(Start(V'Unchecked_Access), Finish(V'Unchecked_Access));
      Value_Allocators.Deallocate(Start(V'Unchecked_Access).Ptr);
   end Finalize;

   -- Iterator functions

   procedure Inc(I: in out Iterator) is
   begin
      I.Ptr := Value_Allocators."+"(I.Ptr, 1);
   end Inc;

   procedure Inc(I: in out Constant_Iterator) is
   begin
      I.Ptr := Value_Allocators."+"(I.Ptr, 1);
   end Inc;

   function Next(I: in Iterator) return Iterator is
      J : Iterator := I;
   begin
      Inc(J);
      return(J);
   end Next;

   function Next(I: in Constant_Iterator) return Constant_Iterator is
      J : Constant_Iterator := I;
   begin
      Inc(J);
      return(J);
   end Next;

   procedure Dec(I: in out Iterator) is
   begin
      I.Ptr := Value_Allocators."-"(I.Ptr, 1);
   end Dec;

   procedure Dec(I: in out Constant_Iterator) is
   begin
      I.Ptr := Value_Allocators."-"(I.Ptr, 1);
   end Dec;

   function Prev(I: in Iterator) return Iterator is
      J : Iterator := I;
   begin
      Dec(J);
      return(J);
   end Prev;

   function Prev(I: in Constant_Iterator) return Constant_Iterator is
      J : Constant_Iterator := I;
   begin
      Dec(J);
      return(J);
   end Prev;

   procedure IncBy(I: in out Iterator; K : Difference_Type) is
   begin
      I.Ptr := Value_Allocators."+"(I.Ptr, K);
   end IncBy;

   procedure IncBy(I: in out Constant_Iterator; K : Difference_Type) is
   begin
      I.Ptr := Value_Allocators."+"(I.Ptr, K);
   end IncBy;

   procedure DecBy(I: in out Iterator; K : Difference_Type) is
   begin
      I.Ptr := Value_Allocators."-"(I.Ptr, K);
   end DecBy;

   procedure DecBy(I: in out Constant_Iterator; K : Difference_Type) is
   begin
      I.Ptr := Value_Allocators."-"(I.Ptr, K);
   end DecBy;

   function "=" (I, J: in Iterator) return Boolean is
   begin
      return Value_Allocators."="(I.Ptr, J.Ptr);
   end "=";

   function "=" (I, J: in Constant_Iterator) return Boolean is
   begin
      return Value_Allocators."="(I.Ptr, J.Ptr);
   end "=";

   function "+" (I: in Iterator; K: in Difference_Type) return Iterator is
      Tmp : Iterator := I;
   begin
      IncBy(Tmp, K);
      return Tmp;
   end "+";

   function "+" (I: in Constant_Iterator; K: in Difference_Type)
                 return Constant_Iterator is
      Tmp : Constant_Iterator := I;
   begin
      IncBy(Tmp, K);
      return Tmp;
   end "+";

   function "+" (K: in Difference_Type; I: in Iterator) return Iterator is
      Tmp : Iterator := I;
   begin
      IncBy(Tmp, K);
      return Tmp;
   end "+";

   function "+" (K: in Difference_Type; I: in Constant_Iterator)
                 return Constant_Iterator is
      Tmp : Constant_Iterator := I;
   begin
      IncBy(Tmp, K);
      return Tmp;
   end "+";

   function "-"(I, J: in Iterator) return Difference_Type is
   begin
      return Value_Allocators."-"(I.Ptr, J.Ptr);
   end "-";

   function "-"(I, J: in Constant_Iterator) return Difference_Type is
   begin
      return Value_Allocators."-"(I.Ptr, J.Ptr);
   end "-";

   function "-"(I: in Iterator;
                J: in Constant_Iterator) return Difference_Type is
   begin
      return Value_Allocators."-"(Make_Constant(I).Ptr, J.Ptr);
   end "-";

   function "-"(I: in Constant_Iterator;
                J: in Iterator) return Difference_Type is
   begin
      return Value_Allocators."-"(I.Ptr, Make_Constant(J).Ptr);
   end "-";

   function "-" (I: in Iterator; K: Difference_Type) return Iterator is
      Tmp : Iterator := I;
   begin
      DecBy(Tmp, K);
      return Tmp;
   end "-";

   function "-" (I: in Constant_Iterator; K: Difference_Type)
                 return Constant_Iterator is
      Tmp : Constant_Iterator := I;
   begin
      DecBy(Tmp, K);
      return Tmp;
   end "-";

   function "<" (I, J: in Iterator) return Boolean is
   begin
      return Value_Allocators."<"(I.Ptr, J.Ptr);
   end "<";

   function "<" (I, J: in Constant_Iterator) return Boolean is
   begin
      return Value_Allocators."<"(I.Ptr, J.Ptr);
   end "<";

   function ">" (I, J: in Iterator) return Boolean is
   begin
      return Value_Allocators.">"(I.Ptr, J.Ptr);
   end ">";

   function ">" (I, J: in Constant_Iterator) return Boolean is
   begin
      return Value_Allocators.">"(I.Ptr, J.Ptr);
   end ">";

   function "<=" (I, J: in Iterator) return Boolean is
   begin
      return Value_Allocators."<="(I.Ptr, J.Ptr);
   end "<=";

   function "<=" (I, J: in Constant_Iterator) return Boolean is
   begin
      return Value_Allocators."<="(I.Ptr, J.Ptr);
   end "<=";

   function ">=" (I, J: in Iterator) return Boolean is
   begin
      return Value_Allocators.">="(I.Ptr, J.Ptr);
   end ">=";

   function ">=" (I, J: in Constant_Iterator) return Boolean is
   begin
      return Value_Allocators.">="(I.Ptr, J.Ptr);
   end ">=";

   function Val(I: in Iterator) return Value_Type is
   begin
      return (I.Ptr.all);
   end Val;

   function Val(I: in Constant_Iterator) return Value_Type is
   begin
      return (I.Ptr.all);
      end Val;

   procedure Assign(I: in out Iterator; V: in Value_Type) is
   begin
      Assign(I.Ptr.all,  V);
   end Assign;

   function Ref(I: in Iterator) return Pointer is
   begin
      return I.Ptr;
   end Ref;

   function Ref(I: in Constant_Iterator) return Constant_Pointer is
   begin
      return I.Ptr;
   end Ref;

   function Make_Constant(I: in Iterator) return Constant_Iterator is
      C : Constant_Iterator;
   begin
      C.Ptr := Constant_Pointer(I.Ptr);
      return C;
   end Make_Constant;

   -- Vector accessors

   function Start(V: in Vector_Pointer) return Iterator is
   begin
      return V.VStart;
   end Start;

   function Start(V: in Vector) return Constant_Iterator is
   begin
      return(Make_Constant(V.VStart));
   end Start;

   function Finish(V: in Vector_Pointer) return Iterator is
   begin
     return V.VFinish;
   end Finish;

   function Finish(V: in Vector) return Constant_Iterator is
   begin
      return(Make_Constant(V.VFinish));
   end Finish;

   function Value(V: in Vector; N: in Size_Type) return Value_Type is
      I : Constant_Iterator := Start(V) + Value_Allocators.To_Difference_Type(N);
   begin
      return I.Ptr.all;
   end Value;

   function Empty(V: in Vector) return Boolean is
   begin
      return (V.VStart = V.VFinish);
   end Empty;

   function Size(V: in Vector) return Size_Type is
   begin
      -- assert V.VFinish >= V.VStart
      return (Value_Allocators.To_Size_Type(V.VFinish - V.VStart));
   end Size;

   function Max_Size(V: in Vector) return Size_Type is
   begin
      return Value_Allocators.Max_Size;
   end Max_Size;

   function Capacity(V: in Vector) return Size_Type is
   begin
      -- assert V.End_Of_Storage >= V.VStart
      return (Value_Allocators.To_Size_Type(V.End_Of_Storage - V.VStart));
   end Capacity;

   function "="(V1, V2: in Vector) return Boolean is
      function Equal is new SGL.Basic_Algorithms.Equal
        (Vector_Input_Constant_Iterators,
         Vector_Input_Constant_Iterators);
   begin
      return Value_Allocators."="(Size(V1), Size(V2)) and then
         Equal(Start(V1), Finish(V1), Start(V2));
   end "=";

   function Front(V: in Vector) return Value_Type is
   begin
      return(Val(Start(V)));
   end Front;

   function Back(V: in Vector) return Value_Type is
   begin
      return(Val(Prev(Finish(V))));
   end Back;

   -- insert/erase

   procedure Assign(V: in out Vector; N: in Size_Type; E: in Value_Type) is
      I : Iterator :=
         Start(V'Unchecked_Access) + Value_Allocators.To_Difference_Type(N);
   begin
      Value_Allocators.Construct(I.Ptr, E);
   end Assign;

   procedure Push_Back(V: in out Vector; E: in Value_Type) is
   begin
      if (V.VFinish /= V.End_Of_Storage) then
         Value_Allocators.Construct(V.VFinish.Ptr, E);
         Inc(V.VFinish);
      else
         Insert_Aux(V, V.VFinish, E);
      end if;
   end Push_Back;

   procedure Pop_Back(V: in out Vector) is
   begin
      Dec(V.VFinish);
      Value_Allocators.Destroy(V.VFinish.Ptr);
   end Pop_Back;


   procedure Erase(V : in out Vector; Position : in Iterator) is
      function Copy is new SGL.Basic_Algorithms.Copy
        (Vector_Input_Constant_Iterators, Vector_Output_Iterators);
      Tmp: Iterator;
   begin
      if (Position + Difference_Type'Val(1) /= Finish(V'Unchecked_Access)) then
         Tmp := Copy(Make_Constant(Position + Difference_Type'Val(1)),
                     Finish(V), Position);
      end if;
      Dec(V.VFinish);
      Value_Allocators.Destroy(V.VFinish.Ptr);
   end Erase;

   procedure Erase(V : in out Vector; First, Last : in Iterator) is
      function Copy is new SGL.Basic_Algorithms.Copy
        (Vector_Input_Iterators, Vector_Output_Iterators);
      procedure Destroy_Sequence is new Value_Allocators.Destroy_Sequence
        (Vector_Forward_Iterators);
   begin
      Destroy_Sequence(Copy(Last, Finish(V'Unchecked_Access), First),
                       Finish(V'Unchecked_Access));
      V.VFinish := V.VFinish - (Last - First);
   end Erase;

   procedure Insert(V: in out Vector;
                    Position: in Iterator;
                    X: in Value_Type;
                    NewPos: out Iterator) is
      N : Difference_Type := Position - Start(V);
   begin
      if (V.VFinish /= V.End_Of_Storage) and then
        (Position = Finish(V'Unchecked_Access)) then
         Value_Allocators.Construct(V.VFinish.Ptr, X);
         Inc(V.VFinish);
      else
         Insert_Aux(V, Position, X);
      end if;

      NewPos := Start(V'Unchecked_Access) + N;
   end Insert;

   procedure Insert_Range(V: in out Vector;
                          Position: in Iterator;
                          First, Last : in Other_Iterators.Iterator)
   is
      function Copy is new SGL.Basic_Algorithms.Copy
        (Other_Iterators, Vector_Output_Iterators);
      function Copy_Backward is new SGL.Basic_Algorithms.Copy_Backward
        (Vector_Bidirectional_Constant_Iterators,
         Vector_Bidirectional_Iterators);
     function Uninitialized_Copy is new Value_Allocators.Uninitialized_Copy
       (Other_Iterators, Vector_Forward_Iterators);
     function Uninitialized_Copy is new Value_Allocators.Uninitialized_Copy
       (Vector_Input_Constant_Iterators, Vector_Forward_Iterators);
     procedure Destroy_Sequence is new Value_Allocators.Destroy_Sequence
       (Vector_Forward_Iterators);
      function Max is new SGL.Basic_Algorithms.Generic_Max
         (Size_Type, Value_Allocators."<");

      N : Difference_Type := Difference_Type'Val(0);
      Len : Size_Type;
      Tmp, DontCare : Iterator;
   begin
      if Other_Iterators."="(First, Last) then
         return;
      end if;

      Distance(First, Last, N);
      -- is there room in the array
      if Value_Allocators.">="(V.End_Of_Storage - Finish(V), N) then
         -- inserting in the middle ?
         if Value_Allocators.">"(Finish(V) - Position, N) then
            DontCare := Uninitialized_Copy(Finish(V) - N, Finish(V),
                                           Finish(V'Unchecked_Access));
            DontCare := Copy_Backward(Make_Constant(Position), Finish(V) - N,
                                      Finish(V'Unchecked_Access));
            DontCare := Copy(First, Last, Position);
         else
            DontCare := Uninitialized_Copy(Make_Constant(Position), Finish(V),
                                           Position + N);
            DontCare := Copy(First, First + (Finish(V) - Position), Position);
            DontCare := Uninitialized_Copy(First + (Finish(V) - Position),
                                           Last, Finish(V'Unchecked_Access));
         end if;
         IncBy(V.VFinish, N);
      else
         Len := Value_Allocators."+"(Size(V),
                                     Max(Size(V),
                                         Value_Allocators.To_Size_Type(N)));
         Tmp.Ptr := Value_Allocators.Allocate(Len);
         DontCare := Uninitialized_Copy(Start(V), Make_Constant(Position),
                                        Tmp);
         DontCare := Uninitialized_Copy(First, Last,
                                        Tmp + (Position - Start(V)));
         DontCare := Uninitialized_Copy
            (Make_Constant(Position),
             Finish(V),
             Tmp + (Value_Allocators."+" (Position - Start(V), N)));
         Destroy_Sequence(Start(V'Unchecked_Access),
                          Finish(V'Unchecked_Access));
         Value_Allocators.Deallocate(V.VStart.Ptr);
         V.End_Of_Storage := Tmp + Value_Allocators.To_Difference_Type(Len);
         V.VFinish :=
            Tmp + Value_Allocators."+"
               (Value_Allocators.To_Difference_Type(Size(V)), N);
         V.VStart := Tmp;
      end if;
   end Insert_Range;

   procedure Insert(V: in out Vector;
                    Position : in Iterator;
                    N : Size_Type;
                    X: in Value_Type) is
      function Copy_Backward is new SGL.Basic_Algorithms.Copy_Backward
        (Vector_Bidirectional_Constant_Iterators,
         Vector_Bidirectional_Iterators);
      function Uninitialized_Copy is new Value_Allocators.Uninitialized_Copy
        (Vector_Input_Constant_Iterators, Vector_Forward_Iterators);
      procedure Fill is new SGL.Basic_Algorithms.Fill(Vector_Forward_Iterators);
      function Uninitialized_Fill_N is new
        Value_Allocators.Uninitialized_Fill_N(Vector_Forward_Iterators,
                                              ">" => Value_Allocators.">");
      procedure Destroy_Sequence is new Value_Allocators.Destroy_Sequence
        (Vector_Forward_Iterators);
      function Max is new SGL.Basic_Algorithms.Generic_Max
         (Size_Type, "<" => Value_Allocators."<");
      Len : Size_Type;
      Tmp, DontCare : Iterator;
   begin
      if Value_Allocators."="(N, 0) then
         return;
      end if;

      if Value_Allocators.">="(V.End_Of_Storage - V.VFinish,
                               Difference_Type (N)) then
         if Value_Allocators.">"
            (Finish(V) - Position,
             Value_Allocators.To_Difference_Type(N)) then
            DontCare :=
               Uninitialized_Copy
                  (Finish(V) - Value_Allocators.To_Difference_Type(N),
                   Finish(V),
                   Finish(V'Unchecked_Access));
            DontCare :=
               Copy_Backward(Make_Constant(Position),
                             Finish(V) - Value_Allocators.To_Difference_Type(N),
                             Finish(V'Unchecked_Access));
            Fill(Position, Position + Value_Allocators.To_Difference_Type(N), X);
         else
            DontCare :=
               Uninitialized_Copy
                  (Make_Constant(Position),
                   Finish(V),
                   Position + Value_Allocators.To_Difference_Type(N));
            Fill(Position, Finish(V'Unchecked_Access), X);
            -- assert Finish(V) > Position
            DontCare := Uninitialized_Fill_N
              (Finish(V'Unchecked_Access),
               Value_Allocators."-"
                  (N, Value_Allocators.To_Size_Type(Finish(V) - Position)),
               X);
         end if;
         IncBy(V.VFinish, Value_Allocators.To_Difference_Type(N));
      else
         Len := Value_Allocators."+"(Size(V), Max(Size(V), N));
         Tmp.Ptr := Value_Allocators.Allocate(Len);
         DontCare := Uninitialized_Copy(Start(V), Make_Constant(Position),
                                        Tmp);
         DontCare := Uninitialized_Fill_N
           (Tmp + (Position - Start(V'Unchecked_Access)), N, X);
         DontCare :=
            Uninitialized_Copy(Make_Constant(Position),
                               Finish(V),
                               Tmp + Value_Allocators."+"
                                  (Position - Start(V), Difference_Type(N)));
         Destroy_Sequence(Start(V'Unchecked_Access),
                          Finish(V'Unchecked_Access));
         Value_Allocators.Deallocate(Start(V'Unchecked_Access).Ptr);
         V.End_Of_Storage := Tmp + Value_Allocators.To_Difference_Type(Len);
         V.VFinish :=
            Tmp + Value_Allocators.To_Difference_Type
               (Value_Allocators."+"(Size(V), N));
         V.VStart := Tmp;
      end if;
   end Insert;

   procedure Insert_Aux(V: in out Vector;
                        Position: in Iterator;
                        X: Value_Type) is
      function Copy_Backward is new SGL.Basic_Algorithms.Copy_Backward
        (Vector_Bidirectional_Constant_Iterators,
         Vector_Bidirectional_Iterators);
      function Uninitialized_Copy is new Value_Allocators.Uninitialized_Copy
        (Vector_Input_Constant_Iterators, Vector_Forward_Iterators);
      procedure Destroy_Sequence is new Value_Allocators.Destroy_Sequence
        (Vector_Forward_Iterators);
      Len : Size_Type;
      Tmp, DontCare : Iterator;
      I : Iterator := Position;
   begin
      if (V.VFinish /= V.End_Of_Storage) then
         Value_Allocators.Construct(V.VFinish.Ptr, Val(V.VFinish - 1));
         DontCare := Copy_Backward(Make_Constant(I),
                                   Make_Constant(V.VFinish - 1), V.VFinish);
         Assign(I, X);
         Inc(V.VFinish);
      else
         if Value_Allocators."="(Size(V), Size_Type'Val(0)) then
            Len := Value_Allocators.Init_Page_Size;
         else
            Len := Value_Allocators."+"(Size(V), Size(V));
         end if;
         Tmp.Ptr := Value_Allocators.Allocate(Len);
         DontCare := Uninitialized_Copy(Start(V), Make_Constant(I),
                                        Tmp);
         declare
            Tmp2 : Iterator := Tmp + (I - Start(V));
         begin
            Value_Allocators.Construct(Tmp2.Ptr, X);
         end ;
         DontCare := Uninitialized_Copy(Make_Constant(I), Finish(V),
                                        Tmp + (I - Start(V)) + 1);
         Destroy_Sequence(Start(V'Unchecked_Access),
                          Finish(V'Unchecked_Access));
         Value_Allocators.Deallocate(Start(V'Unchecked_Access).Ptr);
         V.End_Of_Storage := Tmp + Value_Allocators.To_Difference_Type(Len);
         V.VFinish := Tmp + Value_Allocators.To_Difference_Type(Size(V)) + 1;
         V.VStart := Tmp;
      end if;
   end Insert_Aux;

   -- misc operations

   procedure Swap(V1, V2: in out Vector) is
      procedure Value_Swap is new SGL.Basic_Algorithms.Swap(Iterator);
   begin
      Value_Swap(V1.VStart, V2.VStart);
      Value_Swap(V1.VFinish, V2.VFinish);
      Value_Swap(V1.End_Of_Storage, V2.End_Of_Storage);
   end Swap;

   procedure Reserve(V : in out Vector; N: Size_Type) is
      function Uninitialized_Copy is new Value_Allocators.Uninitialized_Copy
        (Vector_Input_Constant_Iterators, Vector_Forward_Iterators);
      procedure Destroy_Sequence is new Value_Allocators.Destroy_Sequence
        (Vector_Forward_Iterators);
      Tmp, DontCare: Iterator;
   begin
      if Value_Allocators."<"(Capacity(V), N) then
         Tmp.Ptr := Value_Allocators.Allocate(N);
         DontCare := Uninitialized_Copy(Start(V), Finish(V), Tmp);
         Destroy_Sequence(Start(V'Unchecked_Access),
                          Finish(V'Unchecked_Access));
         Value_Allocators.Deallocate(V.VStart.Ptr);
         V.VFinish := Tmp + Value_Allocators.To_Difference_Type(Size(V));
         V.VStart := Tmp;
         V.End_Of_Storage :=
            Start(V'Unchecked_Access) + Value_Allocators.To_Difference_Type(N);
      end if;
   end Reserve;

   -- Optional sequence operations

   package body Sequence_Operations is

      function "<"(V1, V2: in Vector) return Boolean is
         function Lexicographical_Compare is new
           Basic_Algorithms.Lexicographical_Compare
           (Vector_Input_Constant_Iterators,
            Vector_Input_Constant_Iterators, "<", "<");
      begin
         return Lexicographical_Compare(Start(V1), Finish(V1),
                                        Start(V2), Finish(V2));
      end "<";

      function ">"(V1, V2: in Vector) return Boolean is
      begin
         return(V2 < V1);
      end ">";

      function "<="(V1, V2: in Vector) return Boolean is
      begin
         return(not (V1 > V2));
      end "<=";

      function ">="(V1, V2: in Vector) return Boolean is
      begin
         return(not (V1 < V2));
      end ">=";

   end Sequence_Operations;

end SGL.Vectors;
