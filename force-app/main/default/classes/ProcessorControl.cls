public class ProcessorControl
{
     public static boolean inFutureContext = false;
     public static boolean inCntUpdtCntxt = false;
     public static boolean inUsrUpdtCntxt = false;
     public static boolean isLeadUpdating = false;
     public static boolean isEscapeCDLTrigger = false;   // to escape the execution of ContentDocumentLinkTrigger while BatchUtilityHelperTest' execution
     public static boolean isCntDltCntxt = false;
     public static Boolean BIsExecuting = false;
}