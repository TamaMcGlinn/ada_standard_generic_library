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
--  $Id: sgl-lists.adb,v 2.1 1997/07/12 00:39:33 akonstan Exp $
--

with SGL.Input_Iterators;
with SGL.Forward_Iterators;
with SGL.Bidirectional_Constant_Iterators;

with SGL.Basic_Algorithms;

package body SGL.Lists is
   use Size_Type_Operations;
   use Difference_Type_Operations;

   -- Static variables
   Number_Of_Lists : Size_Type := 0;
   Buffer_List : Buffer_Pointer := null;
   Free_List  : Link_Type := null;
   Next_Avail : Link_Type := null;
   Last       : Link_Type := null;


   -- Iterator signature instantiations (used in body)

   package List_Input_Iterators is
     new SGL.Input_Iterators
     (Value_Type, Iterator, Distance_Type_Operations, Iterator_Category);

   package List_Input_Constant_Iterators is
     new SGL.Input_Iterators
     (Value_Type, Constant_Iterator, Distance_Type_Operations,
      Iterator_Category);

   package List_Forward_Iterators is
     new SGL.Forward_Iterators
     (Value_Type, Assign, Iterator, Constant_Iterator, Pointer,
      Constant_Pointer, Distance_Type_Operations, Iterator_Category);

   package List_Bidirectional_Restricted_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type, Iterator, Pointer, Distance_Type_Operations,
      Iterator_Category);

   -- Operators

   procedure Assign(To: in out List_Node; From: in List_Node) is
   begin
      To.Next := From.Next;
      To.Prev := From.Prev;
      Assign(To.Data, From.Data);
   end Assign;

   function "+"(P: Link_Type; N: List_Node_Allocators.Difference_Type)
                return Link_Type renames List_Node_Allocators."+";
   function "="(Left, Right : Link_Type) return Boolean
     renames List_Node_Allocators."=";
   function "="(Left, Right : Buffer_Pointer) return Boolean
     renames Buffer_Allocators."=";
   function To_Difference_Type(X: List_Node_Allocators.Size_Type)
     return List_Node_Allocators.Difference_Type
     renames List_Node_Allocators.To_Difference_Type;
   function To_Size_Type(X: List_Node_Allocators.Difference_Type)
     return List_Node_Allocators.Size_Type
     renames List_Node_Allocators.To_Size_Type;

   -- Memory allocation

   function Buffer_Size return List_Node_Allocators.Size_Type is
   begin
      return List_Node_Allocators.Init_Page_Size;
   end Buffer_Size;
   pragma Inline (Buffer_Size);

   procedure Add_New_Buffer is
      Tmp : Buffer_Pointer := Buffer_Allocators.Allocate(1);
   begin
      Tmp.Buffer := List_Node_Allocators.Allocate(Buffer_Size);
      Tmp.Next_Buffer := Buffer_Allocators.To_Void(Buffer_List);
      Buffer_List := Tmp;
      Next_Avail := Buffer_List.Buffer;
      Last := Next_Avail + To_Difference_Type(Buffer_Size);
   end Add_New_Buffer;
   pragma Inline(Add_New_Buffer);

   procedure Deallocate_Buffers is
      Tmp : Buffer_Pointer;
   begin
      while (Buffer_List /= null) loop
         Tmp := Buffer_List;
         Buffer_List := Buffer_Allocators.To_Pointer(Buffer_List.Next_Buffer);
         List_Node_Allocators.Deallocate(Tmp.Buffer);
         Buffer_Allocators.Deallocate(Tmp);
      end loop;

      Free_List := null;
      Next_Avail := null;
      Last := null;
   end Deallocate_Buffers;
   pragma Inline(Deallocate_Buffers);

   function Get_Node return Link_Type is
      Tmp : Link_Type := Free_List;
   begin
      if (Free_List /= null) then
         Free_List := List_Node_Allocators.To_Pointer(Free_List.Next);
      elsif (Next_Avail = Last) then
         Add_New_Buffer;
         Tmp := Next_Avail;
         Next_Avail := Next_Avail + 1;
      else
         Tmp := Next_Avail;
         Next_Avail := Next_Avail + 1;
      end if;
      return(Tmp);
   end Get_Node;
   pragma Inline(Get_Node);

   procedure Put_Node(P : Link_Type) is
   begin
      P.Next := List_Node_Allocators.To_Void(Free_List);
      Free_List := P;
   end Put_Node;
   pragma Inline(Put_Node);

   procedure Initialize(L: in out List) is
   begin
      Number_Of_Lists := Number_Of_Lists + 1;

      L.Node := Get_Node;
      L.Node.Next := List_Node_Allocators.To_Void(L.Node);
      L.Node.Prev := List_Node_Allocators.To_Void(L.Node);
      L.Length := 0;
   end Initialize;

   procedure Adjust(L: in out List) is
      Start_Copy  : Constant_Iterator := Start(L);
      Finish_Copy : Constant_Iterator := Finish(L);
      procedure Insert is
        new Insert_Range(List_Input_Constant_Iterators, Val);
   begin
      -- We don't have to worry about being called on ourselves !
      Initialize(L);
      Insert(L, Start(L'Unchecked_Access), Start_Copy, Finish_Copy);
   end Adjust;

   procedure Finalize(L: in out List) is
   begin
      Erase(L, Start(L'Unchecked_Access), Finish(L'Unchecked_Access));
      Number_Of_Lists := Number_Of_Lists - 1;
      if (Number_Of_Lists = 0) then
         Deallocate_Buffers;
      end if;
   end Finalize;

   -- List access procedures

   function Empty(L: in List) return Boolean is
   begin
      return (L.Length = 0);
   end Empty;

   function Size(L: in List) return Size_Type is
   begin
      return L.Length;
   end Size;

   function Max_Size(L: in List) return Value_Allocators.Size_Type is
   begin
      return Value_Allocators.Max_Size;
   end Max_Size;

   procedure Swap(L1, L2: in out List) is
      procedure Swap is new SGL.Basic_Algorithms.Swap(Link_Type);
      procedure Swap is new SGL.Basic_Algorithms.Swap(Size_Type);
   begin
      Swap(L1.Node, L2.Node);
      Swap(L1.Length, L2.Length);
   end Swap;

   function "="(L1, L2: in List) return Boolean is
      function Equal is new SGL.Basic_Algorithms.Equal
        (List_Input_Constant_Iterators,
         List_Input_Constant_Iterators);
   begin
      return (Size(L1) = Size(L2)) and then
        Equal(Start(L1), Finish(L1), Start(L2));
   end "=";

   function Start(L: in List) return Constant_Iterator is
      I : Constant_Iterator;
   begin
      I.Node := List_Node_Allocators.Make_Constant
                 (List_Node_Allocators.To_Pointer(L.Node.Next));
      return(I);
   end Start;

   function Start(L: in List_Pointer) return Iterator is
      I : Iterator;
   begin
      I.Node := List_Node_Allocators.To_Pointer(L.Node.Next);
      return(I);
   end Start;

   function Finish(L: in List) return Constant_Iterator is
      C : Constant_Iterator;
   begin
      C.Node := List_Node_Allocators.Make_Constant(L.Node);
      return(C);
   end Finish;

   function Finish(L: in List_Pointer) return Iterator is
      I : Iterator;
   begin
      I.Node := L.Node;
      return(I);
   end Finish;

   function Front(L: in List) return Value_Type is
   begin
      return(Val(Start(L)));
   end Front;

   function Back(L: in List) return Value_Type is
   begin
      return(Val(Prev(Finish(L))));
   end Back;

   -- insert/erase

   procedure Insert(L: in out List;
                    Position : in Iterator;
                    X: in Value_Type;
                    I: out Iterator) is
      Tmp    : Link_Type := Get_Node;
      P      : Link_Type := Position.Node;
      P_Prev : Link_Type := List_Node_Allocators.To_Pointer(P.Prev);
   begin
      Value_Allocators.Construct(Tmp.Data'access, X);
      Tmp.Next := List_Node_Allocators.To_Void(P);
      Tmp.Prev := P.Prev;
      P_Prev.Next := List_Node_Allocators.To_Void(Tmp);
      P.Prev := List_Node_Allocators.To_Void(Tmp);
      L.Length := L.Length + 1;
      I := Make_Iterator(Tmp);
   end Insert;

   procedure Insert(L: in out List; Position: in Iterator;
                                    N: in Size_Type;
                                    X: in Value_Type) is
      Tmp: Iterator;
      I : Size_Type := N;
   begin
      while (I > 0) loop
         Insert(L, Position, X, Tmp);
         I := I - 1;
      end loop;
   end Insert;

   procedure Insert_Range(L: in out List;
                          Position: in Iterator;
                          First, Last : in Other_Iterators.Iterator)
   is
      Cur : Other_Iterators.Iterator := First;
      Tmp : Iterator;
      use Other_Iterators;
   begin
      while (Cur /= Last) loop
         Insert(L, Position, Val(Cur), Tmp);
         Inc(Cur);
      end loop;
   end Insert_Range;

   procedure Erase(L : in out List; Position : in Iterator) is
      P      : Link_Type := Position.Node;
      P_Prev : Link_Type := List_Node_Allocators.To_Pointer(P.Prev);
      P_Next : Link_Type := List_Node_Allocators.To_Pointer(P.Next);
   begin
      P_Prev.Next := P.Next;
      P_Next.Prev := P.Prev;
      Value_Allocators.Destroy(P.Data'access);
      Put_Node(P);
      L.Length := L.Length - 1;
   end Erase;


   procedure Erase(L : in out List; First, Last : in Iterator) is
      Tmp  : Iterator := First;
      Tmp2 : Iterator;
   begin
      while (Tmp /= Last) loop
         Tmp2 := Tmp;
         Inc(Tmp2);
         Erase(L, Tmp);
         Tmp := Tmp2;
      end loop;
   end Erase;

   procedure Push_Back(L: in out List; X: in Value_Type) is
      Tmp : Iterator;
   begin
      Insert(L, Finish(L'Unchecked_Access), X, Tmp);
   end Push_Back;

   procedure Pop_Back(L: in out List) is
      Tmp : Iterator;
   begin
      Tmp := Finish(L'Unchecked_Access);
      Dec(Tmp);
      Erase(L, Tmp);
   end Pop_Back;

   procedure Push_Front(L: in out List; X: in Value_Type) is
      Tmp : Iterator;
   begin
      Insert(L, Start(L'Unchecked_Access), X, Tmp);
   end Push_Front;

   procedure Pop_Front(L: in out List) is
   begin
      Erase(L, Start(L'Unchecked_Access));
   end Pop_Front;

   procedure Transfer(Position, First, Last: in Iterator) is
      Tmp, Tmp2 : Link_Type;
   begin
      --Last.Prev.Next := Position;
      Tmp := List_Node_Allocators.To_Pointer(Last.Node.Prev);
      Tmp.Next := List_Node_Allocators.To_Void(Position.Node);
      -- First.Prev.Next := Last;
      Tmp := List_Node_Allocators.To_Pointer(First.Node.Prev);
      Tmp.Next := List_Node_Allocators.To_Void(Last.Node);
      -- Position.Prev.Next := First;
      Tmp := List_Node_Allocators.To_Pointer(Position.Node.Prev);
      Tmp.Next := List_Node_Allocators.To_Void(First.Node);
      -- Tmp2 := Position.Prev;
      Tmp2 := List_Node_Allocators.To_Pointer(Position.Node.Prev);
      -- Position.Prev := Last.Prev;
      Tmp := Position.Node;
      Tmp.Prev := Last.Node.Prev;
      -- Last.Prev := First.Prev;
      Tmp := Last.Node;
      Tmp.Prev := First.Node.Prev;
      -- First.Prev := Tmp2;
      Tmp := First.Node;
      Tmp.Prev := List_Node_Allocators.To_Void(Tmp2);
   end Transfer;

   procedure Splice(L: in out List; Position: in Iterator; X: in out List) is
   begin
      if ( not Empty(X) ) then
         Transfer(Position, Start(X'Unchecked_Access),
                  Finish(X'Unchecked_Access));
         L.Length := L.Length + X.Length;
         X.Length := 0;
      end if;
   end Splice;

   procedure Splice(L: in out List; Position: in Iterator;
                                    X: in out List;
                                    I: in Iterator) is
      J : Iterator := I;
   begin
      if (Position = I) then
         return;
      else
         Inc(J);
         if (Position = J) then
            return;
         end if;
      end if;

      Transfer(Position, I, J);
      L.Length := L.Length + 1;
      X.Length := X.Length - 1;
   end Splice;

   procedure Splice(L: in out List; Position: in Iterator;
                                    X: in out List;
                                    First, Last : in Iterator) is
      N : Difference_Type := 0;
      procedure Distance is new SGL.Basic_Algorithms.Bidirectional_Distance
        (List_Bidirectional_Restricted_Iterators, Verify_Tag);
   begin
      if ( First /= Last ) then
         -- We can do this since objects of type list are passed by reference
         if ( L'access /= X'access ) then
            Distance(First, Last, N);
            -- XXX - Assert (N >= 0) - Should we do this explicitely ?
            X.Length := X.Length - Size_Type(N);
            L.Length := L.Length + Size_Type(N);
         end if;
         Transfer(Position, First, Last);
      end if;
   end Splice;


   procedure Remove(L: in out List; Value: Value_Type) is
      First : Iterator := Start(L'Unchecked_Access);
      Last  : Iterator := Finish(L'Unchecked_Access);
      Next  : Iterator;
   begin
      while (First /= Last) loop
         Next := First;
         Inc(Next);
         if (Val(First) = Value) then
            Erase(L, First);
         end if;
         First := Next;
      end loop;
   end Remove;

   procedure Unique(L: in out List) is
      First : Iterator := Start(L'Unchecked_Access);
      Last  : Iterator := Finish(L'Unchecked_Access);
      Next  : Iterator;
   begin
      if (First = Last) then
         return;
      end if;
      Next := First;
      Inc(Next);
      while (Next /= Last) loop
         if (Val(First) = Val(Next)) then
            Erase(L, Next);
         else
            First := Next;
         end if;
         Next := First;
         Inc(Next);
      end loop;
   end Unique;

   procedure Invert(L: in out List) is
      First, Old : Iterator;
   begin
      if (Size(L) < 2) then
         return;
      end if;
      First := Start(L'Unchecked_Access);
      Inc(First);
      while (First /= Finish(L'Unchecked_Access)) loop
         Old := First;
         Inc(Old);
         Transfer(Start(L'Unchecked_Access), Old, First);
      end loop;
   end Invert;

   -- optional sequence operations

   package body Sequence_Operations is

      procedure Merge(L1: in out List; L2: in out List) is
         First1 : Iterator := Start(L1'Unchecked_Access);
         Last1  : Iterator := Finish(L1'Unchecked_Access);
         First2 : Iterator := Start(L2'Unchecked_Access);
         Last2  : Iterator := Finish(L2'Unchecked_Access);
         Next   : Iterator;
      begin
         while (First1 /= Last1) and then (First2 /= Last2) loop
            if (Val(First2) < Val(First1)) then
               Next := First2;
               Inc(Next);
               Transfer(First1, First2, Next);
               First2 := Next;
            else
               Inc(First1);
            end if;
         end loop;

         if (First2 /= Last2) then
            Transfer(Last1, First2, Last2);
         end if;
         L1.Length := L1.Length + L2.Length;
         L2.Length := 0;
      end Merge;

      procedure Sort(L: in out List) is
         Carry   : aliased List;
         Counter : array (0..63) of List;
         Fill    : Integer := 0;
         I : Integer;
      begin
         if (Size(L) < 2) then
            return;
         end if;

         while (not Empty(L)) loop
            Splice(Carry, Start(Carry'Unchecked_Access), L,
                   Start(L'Unchecked_Access));
            I := 0;
            while (I < Fill) and then (not Empty(Counter(I))) loop
               Merge(Counter(I), Carry);
               Swap(Carry, Counter(I));
               I := Integer'Succ(I);
            end loop;
            Swap(Carry, Counter(I));
            if (I = Fill) then
               Fill := Integer'Succ(Fill);
            end if;
         end loop;

         while (Fill > 0) loop
            Fill := Integer'Pred(Fill);
            Merge(L, Counter(Fill));
         end loop;
      end Sort;


      function "<"(L1, L2: in List) return Boolean is
         function Lexicographical_Compare is
           new SGL.Basic_Algorithms.Lexicographical_Compare
           (List_Input_Constant_Iterators,
            List_Input_Constant_Iterators,
            "<", "<");
      begin
         return Lexicographical_Compare(Start(L1), Finish(L1),
                                        Start(L2), Finish(L2));
      end "<";

      function ">"(L1, L2: in List) return Boolean is
      begin
         return(L2 < L1);
      end ">";

      function "<="(L1, L2: in List) return Boolean is
      begin
         return(not (L1 > L2));
      end "<=";

      function ">="(L1, L2: in List) return Boolean is
      begin
         return(not (L1 < L2));
      end ">=";

   end Sequence_Operations;

   -- Iterator operations

   function Val(I: in Iterator) return Value_Type is
   begin
      return I.Node.data;
   end Val;

   function Val(I: in Constant_Iterator) return Value_Type is
   begin
      return I.Node.data;
   end Val;

   procedure Inc(I: in out Iterator) is
   begin
      I.Node := List_Node_Allocators.To_Pointer(I.Node.Next);
   end Inc;

   procedure Inc(I: in out Constant_Iterator) is
   begin
      I.Node := List_Node_Allocators.To_Constant_Pointer(I.Node.Next);
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
      I.Node := List_Node_Allocators.To_Pointer(I.Node.Prev);
   end Dec;

   procedure Dec(I: in out Constant_Iterator) is
   begin
      I.Node := List_Node_Allocators.To_Constant_Pointer(I.Node.Prev);
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

   procedure Assign(I: in out Iterator; V: in Value_Type) is
   begin
      Assign(I.Node.Data, V);
   end Assign;

   function Ref(I: in Iterator) return Pointer is
   begin
      return I.Node.Data'access;
   end;

   function Ref(I: in Constant_Iterator) return Constant_Pointer is
   begin
      return I.Node.Data'access;
   end;

   function "=" (I, J: in Iterator) return Boolean is
   begin
      return(I.Node = J.Node);
   end "=";

   function "=" (I, J: in Constant_Iterator) return Boolean is
      use List_Node_Allocators;
   begin
      return(I.Node = J.Node);
   end "=";

   function Make_Constant(I: in Iterator) return Constant_Iterator is
      C : Constant_Iterator;
   begin
      C.Node := List_Node_Allocators.Make_Constant(I.Node);
      return(C);
   end Make_Constant;

   -- Iterator constructor operations

   function Make_Iterator(X: in Link_Type) return Iterator is
      I : Iterator;
   begin
      I.Node := X;
      return(I);
   end Make_Iterator;

   function Make_Iterator(X: in Constant_Link_Type) return Constant_Iterator is
      I : Constant_Iterator;
   begin
      I.Node := X;
      return(I);
   end Make_Iterator;

end SGL.Lists;


