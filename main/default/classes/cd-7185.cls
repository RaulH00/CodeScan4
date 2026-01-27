// =========================================
// GOOD CASES (no violations expected)
// =========================================

// @IsTest class with @IsTest methods
@IsTest
public class GoodCase1 { // âœ… No violation
    @IsTest
    public static void testMethodOne() {}
    @IsTest
    public static void testMethodTwo() {}
}

// @IsTest class with legacy testMethod inside
@IsTest
public class GoodCase2 { // âœ… No violation
    public static testMethod void legacyTestOne() {}
}

// Non-test class without any test methods
public class GoodCase3 { // âœ… No violation
    public void helperMethod() {}
}


// =========================================
// BAD CASES (violations expected)
// =========================================

// No @IsTest annotation but contains test methods
public class BadCase1 { // âŒ Violation: missing @IsTest at class level
    @IsTest
    public static void testMethodOne() {}
    public static testMethod void legacyTestTwo() {}
}

// No @IsTest annotation but only legacy test methods
public class BadCase2 { // âŒ Violation: missing @IsTest at class level
    public static testMethod void legacyTestOne() {}
    public static testMethod void legacyTestTwo() {}
}

// No @IsTest annotation, mixed style test methods
public class BadCase3 { // âŒ Violation: missing @IsTest at class level
    @IsTest
    public static void mixedTestOne() {}
    public static testMethod void mixedTestTwo() {}
}

// Class has @IsTest on a single method but not on class
public class BadCase4 { // âŒ Violation: missing @IsTest at class level
    @IsTest
    public static void testOne() {}
}
