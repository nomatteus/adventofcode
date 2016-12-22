import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Created by matt on 2016-12-21.
 */
public class Day06 {

    public String getMessage_part1(String input) {
        StringBuilder message = new StringBuilder();
        String[] lines = input.split("\n");
        // We will process input columnwise
        int numChars = lines[0].length();
        for (int i = 0; i < numChars; i++) {
            int[] charCounts = new int[26];
            for (String line : lines) {
                char c = line.charAt(i);
                charCounts[c - 97] += 1;
            }
            // Add the winner for this column
            char winner = 0;
            int maxNum = 0;
            for (int j=0; j < 26; j++) {
                if (charCounts[j] > maxNum) {
                    maxNum = charCounts[j];
                    winner = (char) (j + 97);
                }
            }
            message.append(winner);
        }
        return message.toString();
    }

    public String getMessage_part2(String input) {
        StringBuilder message = new StringBuilder();
        String[] lines = input.split("\n");
        // We will process input columnwise
        int numChars = lines[0].length();
        for (int i = 0; i < numChars; i++) {
            int[] charCounts = new int[26];
            for (String line : lines) {
                char c = line.charAt(i);
                charCounts[c - 97] += 1;
            }
            // Add the winner for this column
            char winner = 99;
            int minNum = 99;
            for (int j=0; j < 26; j++) {
                if (charCounts[j] != 0 && charCounts[j] < minNum ) {
                    minNum  = charCounts[j];
                    winner = (char) (j + 97);
                }
            }
            message.append(winner);
        }
        return message.toString();
    }

    public static void main(String[] args) throws Exception{
        Day06 day6 = new Day06();
        // Puzzle input
        String input = new String(Files.readAllBytes(Paths.get("src/inputs/day06")));

        System.out.print("--> Part 1: ");
        System.out.println(day6.getMessage_part1(input));
        System.out.print("--> Part 2: ");
        System.out.println(day6.getMessage_part2(input));
    }
}
