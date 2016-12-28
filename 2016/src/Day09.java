import java.nio.CharBuffer;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Scanner;

/**
 * Created by matt on 2016-12-26.
 */
public class Day09 {

    enum Mode {
        Normal,         // In normal mode we read and output characters, and look for markers
//        MarkerParse,    // Reading the marker definition -- NOT USED.
        MarkerRead      // Reading characters needed for marker, will take any character.
    }

    Mode mode = Mode.Normal;

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


          UPDATE:
           - the above will not work, as the scanner pattern matching only works on a token. in this
           case we do not really have tokens.
           - so do a simpler approach, by reading through character array of string and parsing as we go,
           setting the modes as necessary.
           - assume correct input, i.e. if we see an opening parenthesis, we will always see a number, followed
           by x followed by another integer and then close parenthesis
         */
        StringBuilder output = new StringBuilder();
        // Init to normal mode
        mode = Mode.Normal;
        // Vars to store lengths
        Integer sequenceLength = 0;
        Integer sequenceRepetitions = 0;
        // Holds the string that we will be repeating.
        StringBuilder sequence = new StringBuilder();


        char[] inputChars = input.toCharArray();
        for (int i=0; i < inputChars.length; i++) {
            if (mode == Mode.Normal) {
                if (inputChars[i] == '(') { // start of marker definition
                    // MARKER DEFINITION PARSING
                    i++; // move past '('
                    // read first number
                    StringBuilder sequenceLengthStr = new StringBuilder();
                    // consume all digits up to the x
                    while (inputChars[i] != 'x') {
                        sequenceLengthStr.append(inputChars[i]);
                        i++;
                    }
                    i++; // move past 'x' character

                    // read second number (number of repetitions) -- [copy pasta]
                    StringBuilder sequenceRepetitionsStr = new StringBuilder();
                    // consume all digits up to the )
                    while (inputChars[i] != ')') {
                        sequenceRepetitionsStr.append(inputChars[i]);
                        i++;
                    }

                    // convert to integers
                    sequenceLength = Integer.parseInt(sequenceLengthStr.toString());
                    sequenceRepetitions = Integer.parseInt(sequenceRepetitionsStr.toString());

                    // set mode
                    mode = Mode.MarkerRead;

                    // NOTE: Do not increment i for the last ')' because the for loop will do that for us.
                } else {
                    output.append(inputChars[i]);
                }
            } else if (mode == Mode.MarkerRead) {
                if (sequenceLength > 0) {
                    // Read a character to the sequence, and decrement the length marker
                    sequence.append(inputChars[i]);
                    sequenceLength--;
                }
                // sequenceLength == 0, so we add the repetitions
                if (sequenceLength == 0) {
                    while (sequenceRepetitions > 0) {
                        output.append(sequence);
                        sequenceRepetitions--;
                    }

                    // reset the sequence string
                    sequence = new StringBuilder();
                    // change back to normal mode.
                    mode = Mode.Normal;
                }
            }


        }
        return output.toString();
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
