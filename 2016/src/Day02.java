import java.io.IOException;
import java.nio.file.Paths;
import java.util.Scanner;

/**
 * Created by matt on 2016-12-21.
 */
public class Day02 {

    // Return the next number given a current num and a direction (instruction)
    // Assume correct input.
    public int nextNum(int num, char dir) {
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

    public String calculate(Scanner scanner) {
        StringBuilder code = new StringBuilder();

        // Specs state that we always start on 5
        // Also we use the last num as the starting spot for the next line
        int currentNum = 5;

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();

            int numInstructions = line.length();
            for (int i = 0; i < numInstructions; i++) {
                char direction = line.charAt(i);
                currentNum = nextNum(currentNum, direction);
            }

            code.append(currentNum);
        }
        return code.toString();
    }

    public static void main(String[] args) throws IOException {
        Day02 day2 = new Day02();

        Scanner scanner = new Scanner(Paths.get("src/inputs/day02"));

        System.out.print("---> Part 1 ANSWER: ");
        System.out.println(day2.calculate(scanner));

        // Part 2
//        System.out.print("---> Part 2 ANSWER: ");
//        System.out.println();
    }
}
