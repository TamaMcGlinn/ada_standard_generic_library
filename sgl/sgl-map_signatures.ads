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

--  Instantiates Map iterator signature packages for general iterators,
--  constant iterators, and restricted (general iterators with only constant
--  operations) iterators.  Also instantiates Reverse_Iterators and their
--  iterator signatures.
--

with SGL;
with SGL.Maps;
with SGL.Containers;
with SGL.Reverse_Iterator_Operations;
with SGL.Function_Adaptors;

with SGL.Input_Iterators;
with SGL.Output_Iterators;
with SGL.Forward_Iterators;
with SGL.Forward_Constant_Iterators;
with SGL.Bidirectional_Iterators;
with SGL.Bidirectional_Constant_Iterators;
with SGL.Reverse_Bidirectional_Iterators;

generic
   with package Instance_Maps is new SGL.Maps(<>);

package SGL.Map_Signatures is

   -- Input

   package Map_Input_Iterators is new SGL.Input_Iterators
     (Value_Type => Instance_Maps.Value_Type,
      Iterator => Instance_Maps.Iterator,
      Distance_Type_Operations => Instance_Maps.Distance_Type_Operations,
      Iterator_Category => Instance_Maps.Iterator_Category,
      Inc => Instance_Maps.Inc,
      "=" => Instance_Maps."=",
      Val => Instance_Maps.Val);

   package Map_Input_Constant_Iterators is new SGL.Input_Iterators
     (Value_Type => Instance_Maps.Value_Type,
      Iterator => Instance_Maps.Constant_Iterator,
      Distance_Type_Operations => Instance_Maps.Distance_Type_Operations,
      Iterator_Category => Instance_Maps.Iterator_Category,
      Inc => Instance_Maps.Inc,
      "=" => Instance_Maps."=",
      Val => Instance_Maps.Val);

   -- Output

-- XXX sjw: overloaded Assign() means can't use named association
--    package Map_Output_Iterators is new SGL.Output_Iterators
--      (Value_Type => Value_Type,
--       Assign => Instance_Maps.Map_Pairs_Extension.Assign,
--       Iterator => Instance_Maps.Iterator,
--       Distance_Type_Operations => Instance_Maps.Distance_Type_Operations,
--       Iterator_Category => Instance_Maps.Iterator_Category,
--       Inc => Instance_Maps.Inc,
--       Assign => Instance_Maps.Assign);

   package Map_Output_Iterators is new SGL.Output_Iterators
     (Instance_Maps.Value_Type,
      Instance_Maps.Map_Pairs_Extension.Assign,
      Instance_Maps.Iterator,
      Instance_Maps.Distance_Type_Operations,
      Instance_Maps.Iterator_Category,
      Instance_Maps.Inc,
      Instance_Maps.Assign);

   -- Forward

   -- XXX sjw: overloaded Assign() means can't use named association
   package Map_Forward_Iterators is new SGL.Forward_Iterators
     (Instance_Maps.Value_Type,
      Instance_Maps.Map_Pairs_Extension.Assign,
      Instance_Maps.Iterator,
      Instance_Maps.Constant_Iterator,
      Instance_Maps.Pointer,
      Instance_Maps.Constant_Pointer,
      Instance_Maps.Distance_Type_Operations,
      Instance_Maps.Iterator_Category,
      Instance_Maps.Inc,
      Instance_Maps.Inc,
      Instance_Maps.Next,
      Instance_Maps.Next,
      Instance_Maps."=",
      Instance_Maps."=",
      Instance_Maps.Val,
      Instance_Maps.Val,
      Instance_Maps.Assign,
      Instance_Maps.Ref,
      Instance_Maps.Ref,
      Instance_Maps.Make_Constant);

   package Map_Forward_Constant_Iterators is
     new SGL.Forward_Constant_Iterators
     (Value_Type => Instance_Maps.Value_Type,
      Constant_Iterator => Instance_Maps.Constant_Iterator,
      Constant_Pointer => Instance_Maps.Constant_Pointer,
      Distance_Type_Operations => Instance_Maps.Distance_Type_Operations,
      Iterator_Category => Instance_Maps.Iterator_Category,
      Inc => Instance_Maps.Inc,
      Next => Instance_Maps.Next,
      "=" => Instance_Maps."=",
      Val => Instance_Maps.Val,
      Ref => Instance_Maps.Ref);

   package Map_Forward_Restricted_Iterators is
     new SGL.Forward_Constant_Iterators
     (Value_Type => Instance_Maps.Value_Type,
      Constant_Iterator => Instance_Maps.Iterator,
      Constant_Pointer => Instance_Maps.Pointer,
      Distance_Type_Operations => Instance_Maps.Distance_Type_Operations,
      Iterator_Category => Instance_Maps.Iterator_Category,
      Inc => Instance_Maps.Inc,
      Next => Instance_Maps.Next,
      "=" => Instance_Maps."=",
      Val => Instance_Maps.Val,
      Ref => Instance_Maps.Ref);

   -- Bidirectional

   package Map_Bidirectional_Iterators is new SGL.Bidirectional_Iterators
     (Instance_Maps.Value_Type,
      Instance_Maps.Map_Pairs_Extension.Assign,
      Instance_Maps.Iterator,
      Instance_Maps.Constant_Iterator,
      Instance_Maps.Pointer,
      Instance_Maps.Constant_Pointer,
      Instance_Maps.Distance_Type_Operations,
      Instance_Maps.Iterator_Category,
      Instance_Maps.Inc,
      Instance_Maps.Inc,
      Instance_Maps.Next,
      Instance_Maps.Next,
      Instance_Maps.Dec,
      Instance_Maps.Dec,
      Instance_Maps.Prev,
      Instance_Maps.Prev,
      Instance_Maps."=",
      Instance_Maps."=",
      Instance_Maps.Val,
      Instance_Maps.Val,
      Instance_Maps.Assign,
      Instance_Maps.Ref,
      Instance_Maps.Ref,
      Instance_Maps.Make_Constant);

   package Map_Bidirectional_Constant_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type => Instance_Maps.Value_Type,
      Constant_Iterator => Instance_Maps.Constant_Iterator,
      Constant_Pointer => Instance_Maps.Constant_Pointer,
      Distance_Type_Operations => Instance_Maps.Distance_Type_Operations,
      Iterator_Category => Instance_Maps.Iterator_Category,
      Inc => Instance_Maps.Inc,
      Next => Instance_Maps.Next,
      Dec => Instance_Maps.Dec,
      Prev => Instance_Maps.Prev,
      "=" => Instance_Maps."=",
      Val => Instance_Maps.Val,
      Ref => Instance_Maps.Ref);

   package Map_Bidirectional_Restricted_Iterators is
     new SGL.Bidirectional_Constant_Iterators
     (Value_Type => Instance_Maps.Value_Type,
      Constant_Iterator => Instance_Maps.Constant_Iterator,
      Constant_Pointer => Instance_Maps.Constant_Pointer,
      Distance_Type_Operations => Instance_Maps.Distance_Type_Operations,
      Iterator_Category => Instance_Maps.Iterator_Category,
      Inc => Instance_Maps.Inc,
      Next => Instance_Maps.Next,
      Dec => Instance_Maps.Dec,
      Prev => Instance_Maps.Prev,
      "=" => Instance_Maps."=",
      Val => Instance_Maps.Val,
      Ref => Instance_Maps.Ref);

   -- Instantiate container signature

    package Map_Containers is new SGL.Containers
      (Instance_Maps.Map,
       Instance_Maps.Map_Pointer,
       Instance_Maps.Map_Constant_Pointer,
       Map_Input_Iterators,
       Instance_Maps.Constant_Iterator,
       Instance_Maps.Size_Type_Operations,
       Instance_Maps.Difference_Type_Operations,
       Instance_Maps.Iterator_Category,
       Instance_Maps.Verify_Tag,
       Instance_Maps.Start,
       Instance_Maps.Start,
       Instance_Maps.Finish,
       Instance_Maps.Finish,
       Instance_Maps.Size,
       Instance_Maps.Max_Size,
       Instance_Maps.Empty,
       Instance_Maps.Swap);

   -- Reverse Iterators

--    -- XXX : Gnat 3.09 internal bug caused by code below

--    package Map_Reverse_Bidirectional_Iterators is
--      new SGL.Reverse_Bidirectional_Iterators(Map_Bidirectional_Iterators);

--    -- Instantiate iterator signature packages with Reverse Iterators

--    use Map_Reverse_Bidirectional_Iterators;

--    -- Input Reverse Bidirectional Iterators

--    package Map_Input_RIterators is new SGL.Input_Iterators
--      (Map_Reverse_Bidirectional_Iterators.Value_Type,
--       Map_Reverse_Bidirectional_Iterators.Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
--       Map_Reverse_Bidirectional_Iterators.Iterator_Category);

--    package Map_Input_Constant_RIterators is new SGL.Input_Iterators
--      (Map_Reverse_Bidirectional_Iterators.Value_Type,
--       Map_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
--       Map_Reverse_Bidirectional_Iterators.Iterator_Category);

--    -- Output Reverse Bidirectional Iterators

--    package Map_Output_RIterators is new SGL.Output_Iterators
--      (Map_Reverse_Bidirectional_Iterators.Value_Type,
--       Map_Reverse_Bidirectional_Iterators.Assign,
--       Map_Reverse_Bidirectional_Iterators.Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
--       Map_Reverse_Bidirectional_Iterators.Iterator_Category);

--    -- Forward Reverse Bidirectional Iterators

--    package Map_Forward_RIterators is new SGL.Forward_Iterators
--      (Map_Reverse_Bidirectional_Iterators.Value_Type,
--       Map_Reverse_Bidirectional_Iterators.Assign,
--       Map_Reverse_Bidirectional_Iterators.Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Pointer,
--       Map_Reverse_Bidirectional_Iterators.Constant_Pointer,
--       Map_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
--       Map_Reverse_Bidirectional_Iterators.Iterator_Category);

--    package Map_Forward_Constant_RIterators is
--      new SGL.Forward_Constant_Iterators
--      (Map_Reverse_Bidirectional_Iterators.Value_Type,
--       Map_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Constant_Pointer,
--       Map_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
--       Map_Reverse_Bidirectional_Iterators.Iterator_Category);

--    package Map_Forward_Restricted_RIterators is
--      new SGL.Forward_Constant_Iterators
--      (Map_Reverse_Bidirectional_Iterators.Value_Type,
--       Map_Reverse_Bidirectional_Iterators.Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Pointer,
--       Map_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
--       Map_Reverse_Bidirectional_Iterators.Iterator_Category);

--    -- Bidirectional Reverse Bidirectional Iterators

--    package Map_Bidirectional_RIterators is new SGL.Bidirectional_Iterators
--      (Map_Reverse_Bidirectional_Iterators.Value_Type,
--       Map_Reverse_Bidirectional_Iterators.Assign,
--       Map_Reverse_Bidirectional_Iterators.Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Pointer,
--       Map_Reverse_Bidirectional_Iterators.Constant_Pointer,
--       Map_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
--       Map_Reverse_Bidirectional_Iterators.Iterator_Category);

--    package Map_Bidirectional_Constant_RIterators is
--      new SGL.Bidirectional_Constant_Iterators
--      (Map_Reverse_Bidirectional_Iterators.Value_Type,
--       Map_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Constant_Pointer,
--       Map_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
--       Map_Reverse_Bidirectional_Iterators.Iterator_Category);

--    package Map_Bidirectional_Restricted_RIterators is
--      new SGL.Bidirectional_Constant_Iterators
--      (Map_Reverse_Bidirectional_Iterators.Value_Type,
--       Map_Reverse_Bidirectional_Iterators.Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Pointer,
--       Map_Reverse_Bidirectional_Iterators.Distance_Type_Operations,
--       Map_Reverse_Bidirectional_Iterators.Iterator_Category);

--    -- Instantiate Reverse Iterators operations (RStart, RFinish) ...

--    function Identity is new SGL.Function_Adaptors.Identity
--      (Map_Containers.Iterator);
--    function Identity is new SGL.Function_Adaptors.Identity
--      (Map_Containers.Constant_Iterator);

--    package Map_Reverse_Bidirectional_Iterator_Operations is
--      new SGL.Reverse_Iterator_Operations
--      (Map_Containers,
--       Map_Reverse_Bidirectional_Iterators.Reverse_Iterator,
--       Map_Reverse_Bidirectional_Iterators.Constant_Reverse_Iterator);

end SGL.Map_Signatures;
