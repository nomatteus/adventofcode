import java.io.IOException;
import java.nio.file.Paths;
import java.util.Scanner;

/**
 * Created by matt on 2016-12-21.
 */
public class Day02 {

    // Return the next number given a current num and a direction (instruction)
    // Assume correct input.
    public int nextNum_part1(int num, char dir) {
        // Handle (literal) edge cases
        if (num <=3 && dir == 'U') { // top edge: 123
            return num;
        }
        if (num % 3 == 0 && dir == 'R') { // right edge: 369
            return num;
        }
        if (num % 3 == 1 && dir == 'L') { // left edge: 147
            return num;
        }
        if (num >= 7 && dir == 'D') { // bottom edge: 789
            return num;
        }

        // Now we notice that going right or left, we add/subtract 1
        // and going up and down we add/subtract 3
        int increment;
        int signMultiplier;
        if (dir == 'U' || dir == 'D') {
            increment = 3;
        } else {
            increment = 1;
        }
        if (dir == 'R' || dir == 'D') {
            signMultiplier = 1;
        } else {
            signMultiplier = -1;
        }

        // Use that info to return the next number
        return num + increment * signMultiplier;
    }

    // Layout for part 2:
    //     1
    //   2 3 4
    // 5 6 7 8 9
    //   A B C
    //     D
    // Note that we now have A-D. So use ints 1-13, and then
    // will convert to hex for output (see calculate()).
    public int nextNum_part2(int num, char dir) {
        if ((num == 1 || num == 2 || num == 5) && (dir == 'L' || dir == 'U')) {  // top left edge
            return num;
        }
        if ((num == 1 || num == 4 || num == 9) && (dir == 'U' || dir == 'R')) {  // top right edge
            return num;
        }
        if ((num == 9 || num == 12 || num == 13) && (dir == 'R' || dir == 'D')) {  // bottom right edge
            return num;
        }
        if ((num == 5 || num == 10 || num == 13) && (dir == 'L' || dir == 'D')) {  // bottom left edge
            return num;
        }

        // If we are going right or left, then increment/decrement in 1s
        if (dir == 'R') {
            return num + 1;
        } else if (dir == 'L') {
            return num - 1;
        }

        // Now handle up and down cases...
        if (dir == 'D') {
            if (num == 1) {
                return 3;
            } else if (num <= 9) {
                return num + 4;
            } else if (num == 11) {
                return 13;
            }
        } else if (dir == 'U') {
            if (num == 13) {
                return 11;
            } else if (num >= 5) {
                return num - 4;
            } else if (num == 3) {
                return 1;
            }
        }
        return -1; // invalid input
    }

    public String calculate(Scanner scanner, int part) {
        StringBuilder code = new StringBuilder();

        // Specs state that we always start on 5
        // Also we use the last num as the starting spot for the next line
        int currentNum = 5;

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();

            int numInstructions = line.length();
            for (int i = 0; i < numInstructions; i++) {
                char direction = line.charAt(i);
                if (part == 1) {
                    currentNum = nextNum_part1(currentNum, direction);
                } else {
                    currentNum = nextNum_part2(currentNum, direction);
                }
            }

            code.append(Integer.toHexString(currentNum));
        }
        return code.toString().toUpperCase();
    }

    public static void main(String[] args) throws IOException {
        Day02 day2 = new Day02();

        Scanner scanner = new Scanner(Paths.get("src/inputs/day02"));

        System.out.print("---> Part 1 ANSWER: ");
        System.out.println(day2.calculate(scanner, 1));

        // Part 2
        scanner = new Scanner(Paths.get("src/inputs/day02"));
        System.out.print("---> Part 2 ANSWER: ");
        System.out.println(day2.calculate(scanner, 2));
    }
}
