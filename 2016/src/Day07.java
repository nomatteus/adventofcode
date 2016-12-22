import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Scanner;

/**
 * Created by matt on 2016-12-22.
 */
public class Day07 {

    public boolean supportsTLS(String ip) {
        /*
        Ideas....
        * Is this like a parser? Can we scan through character by character?
        * And then consume character by character, saving 3 prev chars as lookbehind.
        *    We are looking for the abba-type sequence.
        * And use square brackets to determine the "mode". Once we see a [, we enter reject mode,
        *    which means if we see an abba-sequence, we immediately reject (return false).
        *    Note that we also throw away all previous characters when changing modes.
        *    When we see a ], then we enter accept mode, and when we find an abba-sequence in this mode,
        *       we set a boolean flag to true (but still need to check the entire string, since there may
        *       be another abba in square brackets that will cause a rejection)
         */
        // Store the 3 previous seen characters
        Character prev1 = null;
        Character prev2 = null;
        Character prev3 = null;
        // Init flag
        boolean abbaSequenceFound = false;
        // Boolean to represent 2 modes: reject and accept (in square brackets or not)
        // Start off not in square brackets.
        boolean inSquareBrackets = false;
        for (Character curChar : ip.toCharArray() ) {
            // Note that we do not support nested square brackets, so this simplifies things.
            if (curChar.charValue() == '[' || curChar.charValue() == ']') {
                inSquareBrackets = !inSquareBrackets ;
                // Null out previous chars
                prev1 = null;
                prev2 = null;
                prev3 = null;
            } else {
                if (curChar.equals(prev3) && prev2.equals(prev1) && !curChar.equals(prev1)) {
                    // This means we have found an abba sequence.
                    // If we are in square brackets, we can reject immediately
                    if (inSquareBrackets) {
                        return false;
                    } else { // Otherwise, set a flag and continue checking
                        abbaSequenceFound = true;
                    }
                }

                // Set previous chars for next iteration
                prev3 = prev2;
                prev2 = prev1;
                prev1 = curChar;
            }
        }
        return abbaSequenceFound;
    }

    public static void main(String[] args) throws Exception {
        Day07 day7 = new Day07();
        String[] ips = new String(Files.readAllBytes(Paths.get("src/inputs/day07"))).split("\n");
        int countPart1 = 0;
        for (String ip : ips) {
            if (day7.supportsTLS(ip)) {
                countPart1++;
            }
        }
        System.out.print("--> Part 1: ");
        System.out.println(countPart1);
//        System.out.print("--> Part 2: ");
//        System.out.println(countPart2);
    }
}
