public with sharing class IterationRecipes {

    private Account account = null;

    public static List<String> iterableApiClientRecipe() {
        List<String> records = new List<String>();

        Integer target = 7;
        Integer num = 4;
        
        target =- num; // Bad: Target is now -4, not 3. Was this expected?
        target = -num; // Good: This looks like you'd expect and will return -4.

        target =+ num; // Bad: Target would be 4, not 11.
        target += num; // Good: This looks correct and will return 11.

        return records;
    } 
}
