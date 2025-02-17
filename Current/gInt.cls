VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "gInt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
'@PredeclaredId
'@Exposed
'@IgnoreModule EmptyMethod, UnassignedVariableUsage, VariableNotAssigned, SuspiciousPredeclaredInstanceAccess, ProcedureNotUsed, ConstantNotUsed, AssignedByValParameter
'@Folder "Primitives"
Option Explicit

Implements IGeneric
Implements IGenericValue

Private Const INTEGER_CACHE_HIGH As Long = 255
Private Const INTEGER_CACHE_LOW As Long = -5
Private Const MIN_VALUE As Long = -(2 ^ 31)
Private Const MAX_VALUE As Long = 2 ^ 31 - 1 '2,147,483,647
Private Const NUMERIC_SCALE As Long = 8
Private Const PRECISION As Long = 4
Private Const DEFAULT_VALUE As Long = 0&

Private Type Member
    Value As Long
End Type
Private This As Member

Public Property Get Instance() As IGeneric: Set Instance = Me: End Property

Public Property Get MinValue() As Long: MinValue = MIN_VALUE: End Property
Public Property Get MaxValue() As Long: MaxValue = MAX_VALUE: End Property

Public Property Get IsDefault() As Boolean: IsDefault = Me Is gInt: End Property
Public Property Get IsZero() As Boolean: IsZero = This.Value = 0: End Property
Public Property Get IsNegative() As Boolean: IsNegative = Not ((This.Value And MIN_VALUE) = 0): End Property
Public Property Get IsEven() As Boolean: IsEven = ((This.Value And 1) = 0): End Property '((This.Value Mod 2&) = 0)
Public Property Get Negate() As gInt: Set Negate = gInt.Of(-This.Value): End Property

Public Property Get IsPowerOfTwo() As Boolean
    
    If (This.Value > 0) Then _
        IsPowerOfTwo = ((This.Value And (This.Value - 1)) = 0)
    
End Property

'@DefaultMember
Public Property Get ToLong() As Long: ToLong = This.Value: End Property
Attribute ToLong.VB_UserMemId = 0

Public Function Of(ByVal Value As Long) As gInt
    
    If Not (Me Is gInt) Then _
        Set Of = gInt.Of(Value): Exit Function
    
    If (Value <= INTEGER_CACHE_HIGH) Then
        If (Value >= INTEGER_CACHE_LOW) Then
            
            Dim Number As gInt
            Static IntegerCache As GenericArray
            
            If (IntegerCache Is Nothing) Then _
                Set IntegerCache = GenericArray.Build(INTEGER_CACHE_HIGH - INTEGER_CACHE_LOW + 1)
            
            Set Number = IntegerCache.ElementAt(Value + (-INTEGER_CACHE_LOW))
            
            If (Number Is Nothing) Then
                This.Value = Value
                Set Number = New gInt
                This.Value = DEFAULT_VALUE
                Set IntegerCache.ElementAt(Value + (-INTEGER_CACHE_LOW)) = Number
            End If
            
            Set Of = Number
            Exit Function
        End If
    End If

    This.Value = Value
    Set Of = New gInt: This.Value = DEFAULT_VALUE

End Function

Private Sub Class_Initialize(): This.Value = gInt.ToLong: End Sub

Public Function IsPrime() As Boolean
    
  Dim i As Long
                    
  If This.Value <= 1 Then _
    Exit Function
  
  If This.Value = 2 Then _
    IsPrime = True: Exit Function
  
  If Me.IsEven Then _
    Exit Function
  
  For i = 3 To VBA.Int(VBA.Sqr(This.Value)) Step 2
    If (This.Value Mod i) = 0 Then _
      Exit Function
                                
  Next

  IsPrime = True
                                  
End Function

Public Function MaxOf(ByVal A As Long, ByVal B As Long) As gInt: Set MaxOf = gInt.Of(VBA.IIf(A > B, A, B)): End Function
Public Function MinOf(ByVal A As Long, ByVal B As Long) As gInt: Set MinOf = gInt.Of(VBA.IIf(A < B, A, B)): End Function
Public Function EqualsTo(ByVal Value As Long) As Boolean: EqualsTo = This.Value = Value: End Function
Public Function CompareTo(ByVal Value As Long) As CompareResult: CompareTo = Compare(This.Value, Value): End Function
Public Function Compare(ByVal A As Long, ByVal B As Long) As CompareResult: Compare = (A > B) - (A < B): End Function

Public Function IsBetween(ByVal A As Long, B As Long) As Boolean
    
    If (A > This.Value) Then _
        Exit Function
    
    If (B < This.Value) Then _
        Exit Function

    IsBetween = True
    
End Function

Public Function Multiply(ByVal Value As Long) As gInt: Set Multiply = gInt.Of(This.Value * Value): End Function
Public Function Minus(ByVal Value As Long) As gInt: Set Minus = gInt.Of(This.Value - Value): End Function
Public Function Plus(ByVal Value As Long) As gInt: Set Plus = gInt.Of(This.Value + Value): End Function
Public Function Modulo(ByVal Value As Long) As gInt: Set Modulo = gInt.Of(This.Value Mod Value): End Function

'IGeneric
Private Property Get IGeneric_ClassName() As String: IGeneric_ClassName = VBA.TypeName$(Me): End Property
Private Property Get IGeneric_IsDefault() As Boolean: IGeneric_IsDefault = Me.IsDefault: End Property
Private Property Get IGeneric_GetType() As IGeneric: Set IGeneric_GetType = gInt: End Property
Private Property Get IGeneric_VirtualPointer() As Long: IGeneric_VirtualPointer = VarPtr(This): End Property
Private Property Get IGeneric_VirtualSize() As Long: IGeneric_VirtualSize = LenB(This): End Property
Private Property Get IGeneric_HashCode() As Long: IGeneric_HashCode = This.Value: End Property

Private Property Get IGeneric_IsMutable() As Boolean: IGeneric_IsMutable = False: End Property
Private Property Get IGeneric_IsRelatedTo(ByVal Other As Object) As Boolean

    If (Other Is Nothing) Then _
        Exit Property
        
    If (TypeOf Other Is gInt) Then _
        IGeneric_IsRelatedTo = True: Exit Property
        
    If (TypeOf Other Is IGenericValue) Then _
        IGeneric_IsRelatedTo = True: Exit Property

End Property

'@Ignore NonReturningFunction
Private Function EmptyStructure() As Member: End Function

Private Function IGeneric_Equals(ByVal Other As Object) As Boolean
    
    If (Other Is Nothing) Then _
        Exit Function
        
    If TypeOf Other Is gInt Then
        Dim otherNumber As gInt: Set otherNumber = Other
        IGeneric_Equals = (This.Value = otherNumber.ToLong)
    End If
    
End Function

Private Function IGeneric_ToString() As String: IGeneric_ToString = This.Value: End Function

'IGenericValue
Private Property Get IGenericValue_GetValueOrDefault(Optional ByVal DefaultValue As Variant = Null) As Variant: IGenericValue_GetValueOrDefault = VBA.IIf(Me.IsDefault, DefaultValue, This.Value): End Property
Private Property Get IGenericValue_HasValue() As Boolean: IGenericValue_HasValue = Not Me.IsDefault: End Property
Private Property Get IGenericValue_VarType() As VBA.VbVarType: IGenericValue_VarType = VBA.VbVarType.vbLong: End Property
Private Property Get IGenericValue_Size() As Byte: IGenericValue_Size = LenB(This.Value): End Property
Private Property Get IGenericValue_SqlType() As ISqlDataType: IGenericValue_SqlType = ISqlDataType.Numeric_Type: End Property
Private Property Get IGenericValue_GetValue() As Variant: IGenericValue_GetValue = This.Value: End Property
Private Property Get IGenericValue_ToString() As String: IGenericValue_ToString = This.Value: End Property
Private Function IGenericValue_HashCode() As Long: IGenericValue_HashCode = This.Value: End Function
Private Function IGenericValue_Of(ByRef Value As Variant) As IGenericValue: Set IGenericValue_Of = gInt.Of(Value): End Function

Private Function IGenericValue_Equals(ByVal Other As IGenericValue) As Boolean: IGenericValue_Equals = (This.Value = Other.GetValue): End Function
Private Function IGenericValue_IsLessThan(ByVal Other As IGenericValue) As Boolean: IGenericValue_IsLessThan = (This.Value < Other.GetValue): End Function
Private Function IGenericValue_IsGreaterThan(ByVal Other As IGenericValue) As Boolean: IGenericValue_IsGreaterThan = (This.Value > Other.GetValue): End Function

Private Function IGenericValue_IsBetween(ByVal A As IGenericValue, ByVal B As IGenericValue) As Boolean
    
    If (A Is Nothing) Then _
        Exit Function
    
    If (B Is Nothing) Then _
        Exit Function
    
    If (A.HasValue) Then _
        If (B.HasValue) Then _
            IGenericValue_IsBetween = Me.IsBetween(A.GetValue, B.GetValue)
    
End Function

Private Function IGenericValue_ToSqlParameter(Optional ByVal Direction As ISqlParameterDirection = 1&, Optional ByVal Name As String) As Object
    
    Dim p As ADODB.Parameter
    Set p = New ADODB.Parameter
    
    With p
        .Direction = Direction
        .Attributes = adParamNullable '64
        .PRECISION = PRECISION
        .NumericScale = NUMERIC_SCALE
        .Type = IGenericValue_VarType
        .Name = Name
        .Value = This.Value
    End With
    
    Set IGenericValue_ToSqlParameter = p
    
End Function
