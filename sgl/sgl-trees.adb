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

with System;

with SGL.Input_Iterators;
with SGL.Bidirectional_Constant_Iterators;

with SGL.Basic_Algorithms;

package body SGL.Trees is

   use Key_Type_Operations;
   use Size_Type_Operations;

   -- Iterator signature instantiations (used in body)

   package Input_Constant_Iterators is new SGL.Input_Iterators
     (Value_Type, Constant_Iterator, Distance_Type_Operations,
      Iterator_Category);

   package Bidirectional_Constant_Iterators
   is new SGL.Bidirectional_Constant_Iterators
     (Value_Type, Constant_Iterator, Constant_Pointer,
      Distance_Type_Operations, Iterator_Category);

   -- Static variables

   Number_Of_Trees : Size_Type := 0;
   Buffer_List : Buffer_Pointer := null;
   Free_List   : Link_Type := null;
   Next_Avail  : Link_Type := null;
   Last        : Link_Type := null;
   NIL         : Link_Type := null;

   -- Operators
   procedure Assign(To: in out Tree_Node; From: in Tree_Node) is
   begin
      To.Color_Field := From.Color_Field;
      To.Parent_Link := From.Parent_Link;
      To.Left_Link := From.Left_Link;
      To.Right_Link := From.Right_Link;
      Assign(To.Value_Field, From.Value_Field);
   end Assign;

   procedure Assign(To: in out Tree_Node_Buffer;
                    From: in Tree_Node_Buffer) is
   begin
      To := From;
   end Assign;

   function "+"(P: Link_Type;
                N: Tree_Node_Allocators.Difference_Type)
                return Link_Type
     renames Tree_Node_Allocators."+";
   function "+"(P: Constant_Link_Type;
                N: Tree_Node_Allocators.Difference_Type)
                return Constant_Link_Type
     renames Tree_Node_Allocators."+";
   function "="(Left, Right : Link_Type) return Boolean
     renames Tree_Node_Allocators."=";
   function "="(Left, Right : Constant_Link_Type) return Boolean
     renames Tree_Node_Allocators."=";
   function "="(Left, Right : Buffer_Pointer) return Boolean
     renames Buffer_Allocators."=";
   function To_Difference_Type(X: Tree_Node_Allocators.Size_Type)
     return Tree_Node_Allocators.Difference_Type
     renames Tree_Node_Allocators.To_Difference_Type;
   function To_Size_Type(X: Tree_Node_Allocators.Difference_Type)
     return Tree_Node_Allocators.Size_Type
     renames Tree_Node_Allocators.To_Size_Type;

   -- Memory allocation

   function Buffer_Size return Tree_Node_Allocators.Size_Type is
   begin
      return Tree_Node_Allocators.Init_Page_Size;
   end Buffer_Size;
   pragma Inline (Buffer_Size);

   procedure Add_New_Buffer is
      Tmp : Buffer_Pointer := Buffer_Allocators.Allocate(1);
   begin
      Tmp.Buffer := Tree_Node_Allocators.Allocate(Buffer_Size);
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
         Tree_Node_Allocators.Deallocate(Tmp.Buffer);
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
         Free_List := Tree_Node_Allocators.To_Pointer(Free_List.Right_Link);
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
      P.Right_Link := Tree_Node_Allocators.To_Void(Free_List);
      Free_List := P;
   end Put_Node;
   pragma Inline(Put_Node);

   procedure Initialize(T: in out Tree) is
   begin
      Number_Of_Trees := Number_Of_Trees + 1;

      if (NIL = null) then
         NIL := Get_Node;
         NIL.Color_Field := black;
         NIL.Parent_Link := System.Null_Address;
         NIL.Right_Link := System.Null_Address;
         NIL.Left_Link := System.Null_Address;

      end if;

      T.Header := Get_Node;

      Set_Color(T.Header, Red);       -- distinguish header from root
      Set_Root(T, NIL);
      Set_Rightmost(T, T.Header);
      Set_Leftmost(T, T.Header);

      T.Node_Count := 0;
      T.Insert_Always := True;
   end Initialize;

   procedure Adjust(T: in out Tree) is
      Old_Header    : constant Link_Type := T.Header;
      Node_Count    : constant Size_Type := T.Node_Count;
      Insert_Always : constant Boolean   := T.Insert_Always;
   begin
      -- We don't have to worry about being called on ourselves !

      Initialize(T);   -- allocate new header, update tree count, initialize
      T.Node_Count := Node_Count;           -- copy those back
      T.Insert_Always := Insert_Always;

      -- make a structural copy of the tree
      Set_Root(T, Copy(Parent(Old_Header), T.Header));
      if (Root(T) = Constant_Link_Type(NIL)) then
         Set_Leftmost(T, T.Header);
         Set_Rightmost(T, T.Header);
      else
         Set_Leftmost(T, Minimum(Root(T'Unchecked_Access)));
         Set_Rightmost(T, Maximum(Root(T'Unchecked_Access)));
      end if;

   end Adjust;

   procedure Finalize(T: in out Tree) is
   begin
      Erase(T, Start(T'Unchecked_Access), Finish(T'Unchecked_Access));
      Put_Node(T.Header);
      Number_Of_Trees := Number_Of_Trees - 1;
      if (Number_Of_Trees = 0) then
         Put_Node(NIL);
         NIL := null;
         Deallocate_Buffers;
      end if;
   end Finalize;

   -- Tree Node read operations

   function Left(X : in Link_Type) return Link_Type is
   begin
      return(Tree_Node_Allocators.To_Pointer(X.Left_Link));
   end Left;

   function Left(X : in Constant_Link_Type) return Constant_Link_Type is
   begin
      return(Tree_Node_Allocators.To_Constant_Pointer(X.Left_Link));
   end Left;

   function Right(X : in Link_Type) return Link_Type is
   begin
      return(Tree_Node_Allocators.To_Pointer(X.Right_Link));
   end Right;

   function Right(X : in Constant_Link_Type) return Constant_Link_Type is
   begin
      return(Tree_Node_Allocators.To_Constant_Pointer(X.Right_Link));
   end Right;

   function Parent(X : in Link_Type) return Link_Type is
   begin
      return(Tree_Node_Allocators.To_Pointer(X.Parent_Link));
   end Parent;

   function Parent(X : in Constant_Link_Type) return Constant_Link_Type is
   begin
      return(Tree_Node_Allocators.To_Constant_Pointer(X.Parent_Link));
   end Parent;

   function Value(X : in Link_Type) return Value_Type is
   begin
      return(X.Value_Field);
   end Value;

   function Value(X : in Constant_Link_Type) return Value_Type is
   begin
      return(X.Value_Field);
   end Value;

   function Key(X : in Link_Type) return Key_Type is
   begin
      return(KeyOfValue(Value(X)));
   end Key;

   function Key(X : in Constant_Link_Type) return Key_Type is
   begin
      return(KeyOfValue(Value(X)));
   end Key;

   function Color(X : in Link_Type) return Color_Type is
   begin
      return(X.Color_Field);
   end Color;

   function Color(X : in Constant_Link_Type) return Color_Type is
   begin
      return(X.Color_Field);
   end Color;

   -- Tree node set operations

   procedure Set_Left(X, Y : in Link_Type) is
   begin
      X.Left_Link := Tree_Node_Allocators.To_Void(Y);
   end Set_Left;

   procedure Set_Right(X, Y : in Link_Type) is
   begin
      X.Right_Link := Tree_Node_Allocators.To_Void(Y);
   end Set_Right;

   procedure Set_Parent(X, Y : in Link_Type) is
   begin
      X.Parent_Link := Tree_Node_Allocators.To_Void(Y);
   end Set_Parent;

   procedure Set_Value(X : in Link_Type; V : in Value_Type) is
   begin
      Assign(X.Value_Field,  V);
   end Set_Value;

   procedure Set_Color(X : in Link_Type; C : in Color_Type) is
   begin
      X.Color_Field := C;
   end Set_Color;


   function Minimum(X : in Link_Type) return Link_Type is
      Curr : Link_Type := X;
   begin
      while(Left(Curr) /= NIL) loop
         Curr := Left(Curr);
      end loop;

      return Curr;
   end Minimum;

   function Minimum(X : in Constant_Link_Type) return Constant_Link_Type is
      Curr : Constant_Link_Type := X;
   begin
      while(Left(Curr) /= Constant_Link_Type(NIL)) loop
         Curr := Left(Curr);
      end loop;

      return Curr;
   end Minimum;

   function Maximum(X : in Link_Type) return Link_Type is
     Curr : Link_Type := X;
   begin
      while(Right(Curr) /= NIL) loop
         Curr := Right(Curr);
      end loop;

      return Curr;
   end Maximum;

   function Maximum(X : in Constant_Link_Type) return Constant_Link_Type is
     Curr : Constant_Link_Type := X;
   begin
      while(Right(Curr) /= Constant_Link_Type(NIL)) loop
         Curr := Right(Curr);
      end loop;

      return Curr;
   end Maximum;


   -- Tree helper functions

   function Root(T: in Tree_Pointer) return Link_Type is
   begin
      return(Parent(T.Header));
   end Root;

   function Root(T: in Tree) return Constant_Link_Type is
   begin
      return(Parent(Constant_Link_Type(T.Header)));
   end Root;

   function Leftmost(T: in Tree_Pointer) return Link_Type is
   begin
      return(Left(T.Header));
   end Leftmost;

   function Leftmost(T: in Tree) return Constant_Link_Type is
   begin
      return(Left(Constant_Link_Type(T.Header)));
   end Leftmost;

   function Rightmost(T: in Tree_Pointer) return Link_Type is
   begin
      return(Right(T.Header));
   end Rightmost;

   function Rightmost(T: in Tree) return Constant_Link_Type is
   begin
      return(Right(Constant_Link_Type(T.Header)));
   end Rightmost;


   procedure Set_Root(T : in out Tree; X : in Link_Type) is
   begin
      Set_Parent(T.Header, X);
   end Set_Root;

   procedure Set_Leftmost(T : in out Tree; X : in Link_Type) is
   begin
      Set_Left(T.Header, X);
   end Set_Leftmost;

   procedure Set_Rightmost(T : in out Tree; X : in Link_Type) is
   begin
      Set_Right(T.Header, X);
   end Set_Rightmost;

   -- Tree functions

   function Empty(T: in Tree) return Boolean is
   begin
      return (T.Node_Count = 0);
   end Empty;

   function Size(T: in Tree) return Size_Type is
   begin
      return T.Node_Count;
   end Size;

   function Max_Size(T: in Tree) return Size_Type is
   begin
      return Value_Allocators.Max_Size;
   end Max_Size;

   procedure Swap(T1, T2: in out Tree) is
      procedure Swap is new SGL.Basic_Algorithms.Swap(Link_Type);
      procedure Swap is new SGL.Basic_Algorithms.Swap(Size_Type);
      procedure Swap is new SGL.Basic_Algorithms.Swap(Boolean);
   begin
      Swap(T1.Header, T2.Header);
      Swap(T1.Node_Count, T2.Node_Count);
      Swap(T1.Insert_Always, T2.Insert_Always);
   end Swap;

   function Start(T: in Tree) return Constant_Iterator is
      I : Constant_Iterator;
   begin
      I.Node := Leftmost(T);
      return(I);
   end Start;

   function Start(T: in Tree_Pointer) return Iterator is
      I : Iterator;
   begin
      I.Node := Leftmost(T);
      return(I);
   end Start;

   function Finish(T: in Tree) return Constant_Iterator is
   begin
      return(Make_Iterator(Constant_Link_Type(T.Header)));
   end Finish;

   function Finish(T: in Tree_Pointer) return Iterator is
   begin
      return(Make_Iterator(T.Header));
   end Finish;

   procedure Set_Insert_Always(T: in out Tree; B : in Boolean) is
   begin
      T.Insert_Always := B;
   end Set_Insert_Always;

   function "="(T1, T2: in Tree) return Boolean is
      function Equal is new SGL.Basic_Algorithms.Equal
        (Input_Constant_Iterators, Input_Constant_Iterators, "=");
   begin
      return ( (Size(T1) = Size(T2)) and then
               (Equal(Start(T1), Finish(T1), Start(T2))) );
   end "=";

   -- Insert operations

   procedure Insert(T: in out Tree; X_IN, Y_IN : in Link_Type;
                                    V: in Value_Type;
                                    I: out Iterator) is
      Z : Link_Type := Get_Node;
      X : Link_Type := X_IN;
      Y : Link_Type := Y_IN;
   begin
      T.Node_Count := T.Node_Count + 1;
      Value_Allocators.Construct(Z.Value_Field'access, V);

      if ( (Y = T.Header) or else (X /= NIL) or else
           (Key_Compare(KeyOfValue(V), Key(Y))) ) then
         Set_Left(Y, Z);         -- also makes leftmost() = z when y = header
         if (Y = T.Header) then
            Set_Root(T, Z);
            Set_Rightmost(T, Z);
         elsif (Y = Leftmost(T'Unchecked_Access)) then
            Set_Leftmost(T, Z);  -- maintain leftmost()
         end if;
      else
         Set_Right(Y, Z);
         if (Y = Rightmost(T'Unchecked_Access)) then
            Set_Rightmost(T, Z); -- maintain rightmost()
         end if;
      end if;

      Set_Parent(Z, Y);
      Set_Left(Z, NIL);
      Set_Right(Z, NIL);
      X := Z;                    -- recolor and rebalance the tree
      Set_Color(X, Red);
      while ( (X /= Root(T'Unchecked_Access)) and then
              (Color(Parent(X)) = Red) ) loop
         if (Parent(X) = Left(Parent(Parent(X)))) then
            Y := Right(Parent(Parent(X)));
            if (Color(Y) = Red) then
               Set_Color(Parent(X), Black);
               Set_Color(Y, Black);
               Set_Color(Parent(Parent(X)), Red);
               X := Parent(Parent(X));
            else
               if (X = Right(Parent(X))) then
                  X := Parent(X);
                  Rotate_Left(T, X);
               end if;
               Set_Color(Parent(X), Black);
               Set_Color(Parent(Parent(X)), Red);
               Rotate_Right(T, Parent(Parent(X)));
            end if;
         else
            Y := Left(Parent(Parent(X)));
            if (Color(Y) = Red) then
               Set_Color(Parent(X), Black);
               Set_Color(Y, Black);
               Set_Color(Parent(Parent(X)), Red);
               X := Parent(Parent(X));
            else
               if (X = Left(Parent(X))) then
                  X := Parent(X);
                  Rotate_Right(T, X);
               end if;

               Set_Color(Parent(X), Black);
               Set_Color(Parent(Parent(X)), Red);
               Rotate_Left(T, Parent(Parent(X)));
            end if;
         end if;
      end loop;

      Set_Color(Root(T'Unchecked_Access), Black);
      I := Make_Iterator(Z);
   end Insert;

   procedure Insert(T: in out Tree; V: in Value_Type;
                                    I: out Iterator;
                                    Success : out Boolean) is
      Y : Link_Type := T.Header;
      X : Link_Type := Root(T'Unchecked_Access);
      Comp : Boolean := True;
      J : Iterator;
   begin
      while (X /= NIL) loop
         Y := X;
         Comp := Key_Compare(KeyOfValue(V), Key(X));
         if (Comp) then
            X := Left(X);
         else
            X := Right(X);
         end if;
      end loop;

      if (T.Insert_Always) then
         Insert(T, X, Y, V, I);
         Success:= True;
         return;
      end if;

      J := Make_Iterator(Y);
      if (Comp) then
         if (J = Start(T'Unchecked_Access)) then
            Insert(T, X, Y, V, I);
            Success:= True;
            return;
         else
            Dec(J);
         end if;
      end if;

      if (Key_Compare(Key(Node(J)), KeyOfValue(V))) then
         Insert(T, X, Y, V, I);
         Success:= True;
      else
         I := J;
         Success:= False;
      end if;

   end Insert;

   procedure Insert(T: in out Tree; Position_IN : in Iterator;
                                    V : in Value_Type;
                                    I: out Iterator) is
      Position : Iterator := Position_IN;
      Before : Iterator;
      Success : Boolean;
   begin
      if (Position = Start(T'Unchecked_Access)) then
         if ( (Size(T) > 0) and then
              (Key_Compare(KeyOfValue(V),
                           Key(Node(Position)))) ) then
            Insert(T, Node(Position), Node(Position), V, I);
            return;
            -- first argument needs to be non-NIL
         else
            Insert(T, V, I, Success);
            return;
         end if;
      elsif (Position = Finish(T'Unchecked_Access)) then
         if (Key_Compare(Key(Rightmost(T)), KeyOfValue(V))) then
            Insert(T, NIL, Rightmost(T'Unchecked_Access), V, I);
            return;
         else
            Insert(T, V, I, Success);
            return;
         end if;
      else
         Dec(Position);
         Before := Position;
         if ( (Key_Compare(Key(Node(Before)), KeyOfValue(V))) and then
              (Key_Compare(KeyOfValue(V), Key(Node(Position)))) ) then
            if (Right(Node(Before)) = NIL) then
               Insert(T, NIL, Node(Before), V, I);
               return;
            else
               Insert(T, Node(Position), Node(Position), V, I);
               return;
            end if;
         else
            Insert(T, V, I, Success);
            return;
         end if;
      end if;
   end Insert;

   procedure Insert(T: in out Tree; First_IN, Last : in Iterator) is
      First : Iterator := First_IN;
      I : Iterator;
      Success : Boolean;
   begin
      while (First /= Last) loop
         Insert(T, Val(First), I, Success);
         Inc(First);
      end loop;
   end Insert;

   procedure Insert(T: in out Tree; First_IN, Last : in Constant_Pointer) is
      First : Constant_Pointer := First_IN;
      I : Iterator;
      Success : Boolean;

      use Value_Allocators;
   begin
      while (First /= Last) loop
         Insert(T, First.all, I, Success);
         First := First + 1;
      end loop;
   end Insert;

   -- Erase operations


   procedure Erase(T: in out Tree; Position : in Iterator) is
      Z : Link_Type := Node(Position);
      Y : Link_Type := Z;
      X, W : Link_Type;
      procedure Swap is new SGL.Basic_Algorithms.Swap(Color_Type);
   begin
      if (Left(Y) = NIL) then
         X := Right(Y);
      else
         if (Right(Y) = NIL) then
            X := Left(Y);
         else
            Y := Right(Y);
            while (Left(Y) /= NIL) loop
               Y := Left(Y);
            end loop;
            X := Right(Y);
         end if;
      end if;

      if (Y /= Z) then   -- relink Y in place of Z
         Set_Parent(Left(Z), Y);
         Set_Left(Y, Left(Z));
         if (Y /= Right(Z)) then
            Set_Parent(X, Parent(Y));  -- possibly X = NIL
            Set_Left(Parent(Y), X);    -- Y must be a left child
            Set_Right(Y, Right(Z));
            Set_Parent(Right(Z), Y);
         else
            Set_Parent(X, Y);          -- needed in case X = NIL
         end if;

         if (Root(T'Unchecked_Access) = Z) then
            Set_Root(T, Y);
         elsif (Left(Parent(Z)) = Z) then
            Set_Left(Parent(Z), Y);
         else
            Set_Right(Parent(Z), Y);
         end if;
         Set_Parent(Y, Parent(Z));
         Swap(Y.Color_Field, Z.Color_Field);
         Y := Z;  -- y points to node to be actually deleted

      else  -- Y = Z

         Set_Parent(X, Parent(Y));
         if (Root(T'Unchecked_Access) = Z) then
            Set_Root(T, X);
         elsif (Left(Parent(Z)) = Z) then
            Set_Left(Parent(Z), X);
         else
            Set_Right(Parent(Z), X);
         end if;

         if (Leftmost(T'Unchecked_Access) = Z) then
            if (Right(Z) = NIL) then    -- left(Z) must be NIL also
               Set_Leftmost(T, Parent(Z));
            else
               Set_Leftmost(T, Minimum(X));
            end if;
         end if;

         if (Rightmost(T'Unchecked_Access) = Z) then
            if (Left(Z) = NIL) then    -- right(Z) must be NIL also
               Set_Rightmost(T, Parent(Z));
            else
               Set_Rightmost(T, Maximum(X));
            end if;
         end if;
      end if;

      if (Color(Y) /= Red) then
         while( (X /= Root(T'Unchecked_Access))
                and then (Color(X) = Black) ) loop
            if (X = Left(Parent(X))) then
               W := Right(Parent(X));
               if (Color(W) = Red) then
                  Set_Color(W, Black);
                  Set_Color(Parent(X), Red);
                  Rotate_Left(T, Parent(X));
                  W := Right(Parent(X));
               end if;

               if ( (Color(Left(W)) = Black) and then
                    (Color(Right(W)) = Black) ) then
                  Set_Color(W, red);
                  X := Parent(X);
               else
                  if (Color(Right(W)) = Black) then
                     Set_Color(Left(W), Black);
                     Set_Color(W, Red);
                     Rotate_Right(T, W);
                     W := Right(Parent(X));
                  end if;
                  Set_Color(W, Color(Parent(X)));
                  Set_Color(Parent(X), Black);
                  Set_Color(Right(W), Black);
                  Rotate_Left(T, Parent(X));
                  exit;
               end if;

            else  -- same as then clause with right and left exchanged

               W := Left(Parent(X));
               if (Color(W) = Red) then
                  Set_Color(W, Black);
                  Set_Color(Parent(X), Red);
                  Rotate_Right(T, Parent(X));
                  W := Left(Parent(X));
               end if;

               if ( (Color(Right(W)) = Black) and then
                    (Color(Left(W)) = Black) ) then
                  Set_Color(W, Red);
                  X := Parent(X);
               else
                  if (Color(Left(W)) = Black) then
                     Set_Color(Right(W), Black);
                     Set_Color(W, Red);
                     Rotate_Left(T, W);
                     W := Left(Parent(X));
                  end if;
                  Set_Color(W, Color(Parent(X)));
                  Set_Color(Parent(X), Black);
                  Set_Color(Left(W), Black);
                  Rotate_Right(T, Parent(X));
                  exit;
               end if;
            end if;
         end loop;

         Set_Color(X, Black);
      end if;

      Value_Allocators.Destroy(Y.Value_Field'access);
      Put_Node(Y);
      T.Node_Count := T.Node_Count - 1;
   end Erase;

   procedure Erase(T: in out Tree; K : in Key_Type;
                                   S : out Size_Type) is
      I1, I2 : Iterator;
      procedure Distance is new SGL.Basic_Algorithms.Bidirectional_Distance
        (Bidirectional_Constant_Iterators, Verify_Tag);
      First, Second : Iterator;
      N : Distance_Type := 0;
   begin
      Equal_Range(T, K, First, Second);
      Distance(Make_Constant(First), Make_Constant(Second), N);
      Erase(T, First, Second);
      -- XXX - Assert (N >= 0)
      S := Size_Type(N);
   end Erase;

   function Copy(X_IN, P_IN : in Link_Type) return Link_Type is
      X : Link_Type := X_IN;
      P : Link_Type := P_IN;
      R : Link_Type := X_IN;
      Y : Link_Type;
   begin
      -- structural copy
      while (X /= NIL) loop
         Y := Get_Node;
         if (R = X) then
            R := Y;  -- save for return value
         end if;
         Value_Allocators.Construct(Y.Value_Field'access, Value(X));
         Set_Left(P, Y);
         Set_Parent(Y, P);
         Set_Color(Y, Color(X));
         Set_Right(Y, Copy(Right(X), Y));
         P := Y;
         X := Left(X);
      end loop;

      Set_Left(P, NIL);
      return R;
   end Copy;

   procedure Erase(X_IN : in Link_Type) is
      X : Link_Type := X_IN;
      Y : Link_Type;
   begin
      -- erase without rebalancing
      while (X /= NIL) loop
         Erase(Right(X));
         Y := Left(X);
         Value_Allocators.Destroy(X.Value_Field'access);
         Put_Node(X);
         X := Y;
      end loop;
   end Erase;

   procedure Erase(T: in out Tree; First_IN, Last : in Iterator) is
      First : Iterator := First_IN;
   begin
      if ( (First = Start(T'Unchecked_Access)) and then
           (Last = Finish(T'Unchecked_Access))
           and then (T.Node_Count /= 0) ) then
         Erase(Root(T'Unchecked_Access));
         Set_Leftmost(T, T.Header);
         Set_Root(T, NIL);
         Set_Rightmost(T, T.Header);
         T.Node_Count := 0;
      else
         while (First /= Last) loop
            Erase(T, First);
            Inc(First);
         end loop;
      end if;
   end Erase;

-- XXX - remove this
-- procedure Erase(T: in out Tree; First_IN, Last : in Key_Constant_Pointer) is
--    First : Key_Constant_Pointer := First_IN;
--       N : Size_Type;
--       use Key_Allocators;
--    begin
--       while (First /= Last) loop
--          Erase(T, First.all, N);
--          First := First + 1;
--       end loop;
--    end Erase;

   -- Other Tree functions

   function Find(T: in Tree_Pointer; K : in Key_Type) return Iterator is
      Y : Link_Type := T.Header; -- last node which is not less that k
      X : Link_Type := Root(T);  -- current node
   begin
      while(X /= NIL) loop
         if (not Key_Compare(Key(X), K)) then
            Y := X;
            X := Left(X);
         else
            X := Right(X);
         end if;
      end loop;

      if ( (Make_Iterator(Y) = Finish(T) or else
            (Key_Compare(K, Key(Y)))) ) then
         return (Finish(T));
      else
         return (Make_Iterator(Y));
      end if;

   end Find;

   function Find(T: in Tree; K : in Key_Type) return Constant_Iterator is
      Y : Constant_Link_Type := Constant_Link_Type(T.Header);
                             -- last node which is not less that k
      X : Constant_Link_Type := Root(T);  -- current node
   begin
      while(X /= Constant_Link_Type(NIL)) loop
         if (not Key_Compare(Key(X), K)) then
            Y := X;
            X := Left(X);
         else
            X := Right(X);
         end if;
      end loop;

      if ( (Make_Iterator(Y) = Finish(T)) or else
           (Key_Compare(K, Key(Y))) ) then
         return (Finish(T));
      else
         return (Make_Iterator(Y));
      end if;

   end Find;

   function Count(T: in Tree; K : in Key_Type) return Size_Type is
      N : Difference_Type := 0;
      First, Second : Constant_Iterator;
      procedure Distance is new SGL.Basic_Algorithms.Bidirectional_Distance
        (Bidirectional_Constant_Iterators, Verify_Tag);
   begin
      Equal_Range(T, K, First, Second);
      Distance(First, Second, N);

      -- XXX - Assert(N >= 0)
      return Size_Type(N);
   end Count;

   function Lower_Bound(T: in Tree_Pointer; K : in Key_Type) return Iterator is
      Y : Link_Type := (T.Header); -- last node which is not less that k
      X : Link_Type := Root(T);    -- current node
   begin
      while (X /= NIL) loop
         if (not Key_Compare(Key(X), K)) then
            Y := X;
            X := Left(X);
         else
            X := Right(X);
         end if;
      end loop;

      return Make_Iterator(Y);
   end Lower_Bound;

   function Lower_Bound(T: in Tree; K : in Key_Type)
                        return Constant_Iterator is
      Y : Constant_Link_Type := Constant_Link_Type(T.Header);
                             -- last node which is not less that k
      X : Constant_Link_Type := Root(T);  -- current node
   begin
      while (X /= Constant_Link_Type(NIL)) loop
         if (not Key_Compare(Key(X), K)) then
            Y := X;
            X := Left(X);
         else
            X := Right(X);
         end if;
      end loop;

      return Make_Iterator(Y);
   end Lower_Bound;


   function Upper_Bound(T: in Tree_Pointer; K : in Key_Type) return Iterator is
      Y : Link_Type := T.Header; -- last node which is greater that k
      X : Link_Type := Root(T);  -- current node
   begin
      while (X /= NIL) loop
         if (Key_Compare(K, Key(X))) then
            Y := X;
            X := Left(X);
         else
            X := Right(X);
         end if;
      end loop;

      return Make_Iterator(Y);
   end Upper_Bound;

   function Upper_Bound(T: in Tree; K : in Key_Type)
                        return Constant_Iterator is
      Y : Constant_Link_Type := Constant_Link_Type(T.Header);
                             -- last node which is greater that k
      X : Constant_Link_Type := Root(T);  -- current node
   begin
      while (X /= Constant_Link_Type(NIL)) loop
         if (Key_Compare(K, Key(X))) then
            Y := X;
            X := Left(X);
         else
            X := Right(X);
         end if;
      end loop;

      return Make_Iterator(Y);
   end Upper_Bound;


   procedure Equal_Range(T: in out Tree;
                         K : in Key_Type;
                         First, Second : out Iterator) is

   begin
      First := Lower_Bound(T'Unchecked_Access, K);
      Second := Upper_Bound(T'Unchecked_Access, K);
   end Equal_Range;

   procedure Equal_Range(T: in Tree;
                         K : in Key_Type;
                         First, Second : out Constant_Iterator) is

   begin
      First := Lower_Bound(T, K);
      Second := Upper_Bound(T, K);
   end Equal_Range;


   -- Tree operations

   procedure Rotate_Left(T : in out Tree; X : in Link_Type) is
      Y : Link_Type := Right(X);
   begin
      Set_Right(X, Left(Y));
      if (Left(Y) /= NIL) then
         Set_Parent(Left(Y), X);
      end if;
      Set_Parent(Y, Parent(X));
      if (X = Root(T'Unchecked_Access)) then
         Set_Root(T, Y);
      elsif (X = Left(Parent(X))) then
         Set_Left(Parent(X), Y);
      else
         Set_Right(Parent(X), Y);
      end if;
      Set_Left(Y, X);
      Set_Parent(X, Y);
   end Rotate_Left;


   procedure Rotate_Right(T : in out Tree; X : in Link_Type) is
      Y : Link_Type := Left(X);
   begin
      Set_Left(X, Right(Y));
      if (Right(Y) /= NIL) then
         Set_Parent(Right(Y), X);
      end if;
      Set_Parent(Y, Parent(X));
      if (X = Root(T'Unchecked_Access)) then
         Set_Root(T, Y);
      elsif (X = Right(Parent(X))) then
         Set_Right(Parent(X), Y);
      else
         Set_Left(Parent(X), Y);
      end if;
      Set_Right(Y, X);
      Set_Parent(X, Y);
   end Rotate_Right;


   -- Iterator operations

   function Val(I: in Iterator) return Value_Type is
   begin
      return Value(I.Node);
   end Val;

   function Val(I: in Constant_Iterator) return Value_Type is
   begin
      return Value(I.Node);
   end Val;

   procedure Inc(I: in out Iterator) is
      Y : Link_Type;
   begin
      if (Right(I.Node) /= NIL) then
         Set_Node(I, Right(Node(I)));
         while (Left(Node(I)) /= NIL) loop
            Set_Node(I, Left(Node(I)));
         end loop;
      else
         Y := Parent(Node(I));
         while (Node(I) = Right(Y)) loop
            Set_Node(I, Y);
            Y := Parent(Y);
         end loop;
         if (Right(Node(I)) /= Y) then -- necessary because of rightmost
            Set_Node(I, Y);
         end if;
      end if;
   end Inc;

   procedure Inc(I: in out Constant_Iterator) is
      Y : Constant_Link_Type;
   begin
      if (Right(I.Node) /= Constant_Link_Type(NIL)) then
         Set_Node(I, Right(Node(I)));
         while (Left(Node(I)) /= Constant_Link_Type(NIL)) loop
            Set_Node(I, Left(Node(I)));
         end loop;
      else
         Y := Parent(Node(I));
         while (Node(I) = Right(Y)) loop
            Set_Node(I, Y);
            Y := Parent(Y);
         end loop;
         if (Right(Node(I)) /= Y) then -- necessary because of rightmost
            Set_Node(I, Y);
         end if;
      end if;
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
      Y : Link_Type;
   begin
      if ( (Color(Node(I)) = Red) and then
           (Parent(Parent(Node(I))) = Node(I)) ) then
         -- check for header
         Set_Node(I, Right(Node(I)));  -- return rightmost
      elsif (Left(Node(I)) /= NIL) then
         Y := Left(Node(I));
         while (Right(Y) /= NIL) loop
            Y := Right(Y);
         end loop;
         Set_Node(I, Y);
      else
         Y := Parent(Node(I));
         while (Node(I) = Left(Y)) loop
            Set_Node(I, Y);
            Y := Parent(Y);
         end loop;
         Set_Node(I, Y);
      end if;
   end Dec;

   procedure Dec(I: in out Constant_Iterator) is
      Y : Constant_Link_Type;
   begin
      if ( (Color(Node(I)) = Red) and then
           (Parent(Parent(Node(I))) = Node(I)) ) then
         -- check for header
         Set_Node(I, Right(Node(I)));  -- return rightmost
      elsif (Left(Node(I)) /= Constant_Link_Type(NIL)) then
         Y := Left(Node(I));
         while (Right(Y) /= Constant_Link_Type(NIL)) loop
            Y := Right(Y);
         end loop;
         Set_Node(I, Y);
      else
         Y := Parent(Node(I));
         while (Node(I) = Left(Y)) loop
            Set_Node(I, Y);
            Y := Parent(Y);
         end loop;
         Set_Node(I, Y);
      end if;
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
      Assign(I.Node.Value_Field, V);
   end Assign;

   function Ref(I: in Iterator) return Pointer is
   begin
      return I.Node.Value_Field'access;
   end;

   function Ref(I: in Constant_Iterator) return Constant_Pointer is
   begin
      return I.Node.Value_Field'access;
   end;

   function "=" (I, J: in Iterator) return Boolean is
   begin
      return(I.Node = J.Node);
   end "=";

   function "=" (I, J: in Constant_Iterator) return Boolean is
   begin
      return(I.Node = J.Node);
   end "=";

   function Make_Constant(I: in Iterator) return Constant_Iterator is
      C : Constant_Iterator;
   begin
      C.Node := Tree_Node_Allocators.Make_Constant(I.Node);
      return C;
   end Make_Constant;

   -- Iterator constructor functions

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

   function Node(I : in Iterator) return Link_Type is
   begin
      return I.Node;
   end Node;

   function Node(I : in Constant_Iterator) return Constant_Link_Type is
   begin
      return I.Node;
   end Node;

   procedure Set_Node(I : in out Iterator; X : in Link_Type) is
   begin
      I.Node := X;
   end Set_Node;

   procedure Set_Node(I : in out Constant_Iterator;
                      X : in Constant_Link_Type) is
   begin
      I.Node := X;
   end Set_Node;

end SGL.Trees;
