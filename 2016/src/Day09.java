import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Created by matt on 2016-12-26.
 */
public class Day09 {

    public String decompressedString(String input) {
        /*
            Just making notes on how I might do this for now.
            (Note that the approach will be similar to day7, in that we will scan through the string
             character by character.)
            MODES (states):
             - Normal mode: We read a character, and output that character.
             - Marker Parse mode: Marker definition is read and parsed.
             - Marker Read mode: Number of characters required by marker is read without checking for markers.

            - Create a Scanner that will scan with empty string as whitespace.
            - In Normal mode:
                   check for hasNext(Pattern) to see if there is a marker definition:
                        if there is, then read marker with next(Pattern).
                            then parse using regex group matches (did similar thing on previous days)
                        if not, then just read and output next character and move forward one char.
            - Marker Read mode:
                - simply read however many characters required by the marker definition.
                - then append required number of copies of string to output string.

            notes:
             - next(".") should get one character
         */
        return "";
    }

    public int decompressedLength(String input) {
        return decompressedString(input).length();
    }

    public static void main(String[] args) throws Exception {
        Day09 day9 = new Day09();
        String input = new String(Files.readAllBytes(Paths.get("src/inputs/day09")));

        System.out.print("--> Part 1: ");
        System.out.println(day9.decompressedLength(input));
//        System.out.print("--> Part 2: ");
//        System.out.println(countPart2);
    }
}
