import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;

/**
 * Created by matt on 2016-12-22.
 */
public class Day07 {

    public boolean supportsTLS(String ip) {
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

    /*
     The difference here is that we need to find an 'aba' occurrence outside of square brackets,
        as well as a matching 'bab' occurrence in square brackets.
     The logic to find these sequences is the same as part 1, except we only need to store the previous 2
        characters. But, in addition, we need to store the actual characters of all the matches, so we can
        tell if there is a match for the corresponding bab.
        i.e. we do a pass through the string to find all aba/bab strings in and out of square brackets,
            and then do a matching step to find if there are any matches in the 2 sets.
     Data Structure Notes:
        - When an aba set is found outside of square brackets, store in array list as [a,b]
        - when bab set is found inside square brackets, store in arrayList in reverse, as [a,b]
        This way, when these 2 matching items are compared, they will be equal.
        - Then, store the inside and outside square brackets in a Set-based data structure.
        - Then, at the end, do an intersection (in java, that's retainAll()), and if there are
            any elements in the intersection, then return true (since there is a match)
     */
    public boolean supportsSSL(String ip) {
        // Store the 2 previous seen characters
        Character prev1 = null;
        Character prev2 = null;

        // Init data structure to store matches.
        HashSet<ArrayList<Character>> outsideSquareBrackets = new HashSet<>();
        HashSet<ArrayList<Character>> insideSquareBrackets = new HashSet<>();

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
            } else {
                if (curChar.equals(prev2) && !curChar.equals(prev1)) {
                    ArrayList<Character> match = new ArrayList<>();

                    if (inSquareBrackets) {
                        // Note that we add this in reverse order (so we will be able to compare
                        // using equality)
                        match.add(prev1);
                        match.add(curChar);
                        insideSquareBrackets.add(match);
                    } else {
                        match.add(curChar);
                        match.add(prev1);
                        outsideSquareBrackets.add(match);
                    }
                }

                // Set previous chars for next iteration
                prev2 = prev1;
                prev1 = curChar;
            }
        }
        // Check if there are any matches.
        // Perform set intersection ("retainAll") to modify outsideSquareBrackets set to
        // only contain the items that also are in insideSquareBrackets set
        outsideSquareBrackets.retainAll(insideSquareBrackets);
        // If there are any elements left then we have at least one match.
        return outsideSquareBrackets.size() > 0;
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
        int countPart2 = 0;
        for (String ip : ips) {
            if (day7.supportsSSL(ip)) {
                countPart2++;
            }
        }
        System.out.print("--> Part 1: ");
        System.out.println(countPart1);
        System.out.print("--> Part 2: ");
        System.out.println(countPart2);
    }
}
