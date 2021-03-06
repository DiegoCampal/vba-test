Attribute VB_Name = "Tests_TestCase"
Public Sub RunTests(Suite As TestSuite)
    Dim Tests As New TestSuite
    Dim Test As TestCase
    Dim A As Variant
    Dim B As Variant
    
    With Suite.Test("should pass if all assertions pass")
        Set Test = Tests.Test("should pass")
        With Test
            .IsEqual "A", "A"
            .IsEqual 2, 2
        End With
        
        .IsEqual Test.Result, TestResultType.Pass
    End With
    
    With Suite.Test("should fail if any assertion fails")
        Set Test = Tests.Test("should fail")
        With Test
            .IsEqual "A", "A"
            .IsEqual 2, 1
        End With
        
        .IsEqual Test.Result, TestResultType.Fail
    End With
    
    With Suite.Test("should contain collection of failures")
        Set Test = Tests.Test("should have failures")
        With Test
            .IsEqual "A", "A"
            .IsEqual 2, 1
            .IsEqual True, False
        End With
        
        .IsEqual Test.Failures(1), "Expected 2 to equal 1"
        .IsEqual Test.Failures(2), "Expected True to equal False"
    End With
    
    With Suite.Test("should be pending if there are no assertions")
        Set Test = Tests.Test("pending")
        .IsEqual Test.Result, TestResultType.Pending
    End With
    
    With Suite.Test("should skip even with failed assertions")
        Set Test = Tests.Test("skipped")
        With Test
            .IsEqual 2, 1
            .Skip
        End With
        
        .IsEqual Test.Result, TestResultType.Skipped
    End With
    
    With Suite.Test("should explicitly pass test")
        Set Test = Tests.Test("pass")
        With Test
            .IsEqual 2, 1
            .Pass
        End With
        
        .IsEqual Test.Result, TestResultType.Pass
    End With
    
    With Suite.Test("should explicitly fail test")
        Set Test = Tests.Test("fail")
        With Test
            .IsEqual 2, 2
            .Fail
        End With
        
        .IsEqual Test.Result, TestResultType.Fail
    End With
    
    With Suite.Test("should fail if plan doesn't match")
        Set Test = Tests.Test("plan")
        With Test
            .Plan 2
            .IsEqual 2, 2
        End With
        
        .IsEqual Test.Result, TestResultType.Fail
    End With
    
    PassingAssertions Suite
    FailingAssertions Suite
End Sub

Sub PassingAssertions(Suite As TestSuite)
    With Suite.Test("IsEqual")
        .IsEqual 1, 1
        .IsEqual 1.2, 1.2
        .IsEqual True, True
        .IsEqual Array(1, 2, 3), Array(1, 2, 3)
        
        Set A = New Collection
        A.Add 1
        A.Add 2
        
        Set B = New Collection
        B.Add 1
        B.Add 2
        
        .IsEqual A, B
        
        Set A = New Dictionary
        A("a") = 1
        A("b") = 2
        
        Set B = New Dictionary
        B("a") = 1
        B("b") = 2
        
        .IsEqual A, B
    End With
    
    With Suite.Test("NotEqual")
        .NotEqual 1, 2
        .NotEqual 1.2, 1.1
        .NotEqual True, False
        .NotEqual Array(1, 2, 3), Array(3, 2, 1)
        
         Set A = New Collection
        A.Add 1
        A.Add 2
        
        Set B = New Collection
        B.Add 2
        B.Add 1
        
        .NotEqual A, B
        
        Set A = New Dictionary
        A("a") = 1
        A("b") = 2
        
        Set B = New Dictionary
        B("a") = 2
        B("b") = 1
        
        .NotEqual A, B
    End With
    
    With Suite.Test("IsOk")
        .IsOk True
        .IsOk 4
    End With
    
    With Suite.Test("NotOk")
        .NotOk False
        .NotOk 0
    End With
    
    With Suite.Test("IsUndefined")
        .IsUndefined
        .IsUndefined Nothing
        .IsUndefined Null
        .IsUndefined Empty
    End With
    
    With Suite.Test("NotUndefined")
        .NotUndefined 4
        .NotUndefined True
    End With
    
    With Suite.Test("IsError")
        On Error Resume Next
        
        Err.Raise vbObjectError + 10, Description:="Error Description"
        .IsError Number:=vbObjectError + 10, Description:="Error Description"
        
        Err.Clear
        On Error GoTo 0
    End With
    
    With Suite.Test("NotError")
        .NotError
    End With
    
    With Suite.Test("Includes")
        .Includes Array(1, 2, 3), 2
        .Includes Array(Array(1, 2, 3), 4, 5), 2
        
        Set A = New Collection
        A.Add New Collection
        A(1).Add Array(1, 2, 3)
        
        .Includes A, 2
    End With
    
    With Suite.Test("NotIncludes")
        .NotIncludes Array(1, 2, 3), 4
        
        Set A = New Collection
        A.Add New Collection
        A(1).Add Array(1, 2, 3)
        
        .NotIncludes A, 4
    End With
    
    With Suite.Test("IsApproximate")
        .IsApproximate 1.001, 1.002, 3
        .IsApproximate 1.00001, 1.00004, 5
    End With
    
    With Suite.Test("NotApproximate")
        .NotApproximate 1.001, 1.009, 3
    End With
End Sub

Sub FailingAssertions(Suite As TestSuite)
    Dim FailingSuite As New TestSuite
    Dim FailingTest As TestCase
    Set FailingTest = FailingSuite.Test("FailingAssertions")
    
    With Suite.Test("IsEqual (fail)")
        ' Reset FailingTest by calling Pass
        FailingTest.Pass
        FailingTest.IsEqual 1, 2
        FailingTest.IsEqual Array(1, 2, 3), Array(3, 2, 1)
        
        .IsEqual FailingTest.Failures(1), "Expected 1 to equal 2"
        
        ' TODO Indentation here should be two spaces
        .IsEqual FailingTest.Failures(2), "Expected [" & vbNewLine & " 1," & vbNewLine & " 2," & vbNewLine & " 3" & vbNewLine & "] to equal [" & vbNewLine & " 3," & vbNewLine & " 2," & vbNewLine & " 1" & vbNewLine & "]"
    End With
End Sub

